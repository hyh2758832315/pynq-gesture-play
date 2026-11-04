#include <xrt/xrt_bo.h>
#include <xrt/xrt_device.h>

#include <algorithm>
#include <array>
#include <atomic>
#include <chrono>
#include <cstdint>
#include <cstring>
#include <functional>
#include <memory>
#include <stdexcept>
#include <string>
#include <thread>
#include <type_traits>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <sys/syscall.h>
#include <time.h>
#include <unistd.h>

namespace {
constexpr std::size_t samples_per_packet = 960;
constexpr std::size_t queue_capacity = 64;
thread_local std::string last_error;

class OwnerProof {
    int descriptor;
    std::string path;
    std::string journal;
    dev_t device;
    ino_t inode;
    pid_t process;
    long producer_thread;

public:
    OwnerProof(int descriptor_value, std::string path_value, std::string journal_value,
               dev_t device_value, ino_t inode_value)
        : descriptor(descriptor_value), path(std::move(path_value)), journal(std::move(journal_value)),
          device(device_value), inode(inode_value), process(getpid()), producer_thread(syscall(SYS_gettid)) {}

    bool confirmed() const {
        struct stat file{}, named{};
        if (getpid() != process || syscall(SYS_gettid) != producer_thread
                || fstat(descriptor, &file) != 0 || lstat(path.c_str(), &named) != 0
                || !S_ISREG(file.st_mode) || !S_ISREG(named.st_mode) || file.st_nlink != 1
                || file.st_uid != geteuid() || named.st_uid != geteuid()
                || file.st_dev != device || file.st_ino != inode
                || named.st_dev != device || named.st_ino != inode || journal.size() > 4096)
            return false;
        std::array<char, 4097> bytes{};
        const auto count = pread(descriptor, bytes.data(), bytes.size(), 0);
        return count >= 0 && static_cast<std::size_t>(count) == journal.size()
            && std::memcmp(bytes.data(), journal.data(), journal.size()) == 0;
    }
};

class RegisterMap {
    int descriptor = -1;
    void* mapping = MAP_FAILED;

public:
    explicit RegisterMap(std::uint32_t physical_address) {
        if (physical_address != 0x413e0000 && physical_address != 0x40430000)
            throw std::runtime_error("Native mapping outside frozen audio register ABI");
        descriptor = open("/dev/mem", O_RDWR | O_SYNC | O_CLOEXEC);
        if (descriptor < 0)
            throw std::runtime_error("Native audio register mapping open failed");
        mapping = mmap(nullptr, 4096, PROT_READ | PROT_WRITE, MAP_SHARED, descriptor, physical_address);
        if (mapping == MAP_FAILED) {
            close(descriptor);
            descriptor = -1;
            throw std::runtime_error("Native audio register mmap failed");
        }
    }

    ~RegisterMap() {
        if (mapping != MAP_FAILED) munmap(mapping, 4096);
        if (descriptor >= 0) close(descriptor);
    }

    std::uint32_t read(std::uint32_t offset) const {
        if (offset >= 4096 || offset % 4 != 0)
            throw std::runtime_error("Native register offset invalid");
        std::atomic_thread_fence(std::memory_order_seq_cst);
        const auto value = static_cast<volatile std::uint32_t*>(mapping)[offset / 4];
        std::atomic_thread_fence(std::memory_order_seq_cst);
        return value;
    }

    void write(std::uint32_t offset, std::uint32_t value) {
        if (offset >= 4096 || offset % 4 != 0)
            throw std::runtime_error("Native register offset invalid");
        std::atomic_thread_fence(std::memory_order_seq_cst);
        static_cast<volatile std::uint32_t*>(mapping)[offset / 4] = value;
        std::atomic_thread_fence(std::memory_order_seq_cst);
    }
};

bool stopped_audio(std::uint32_t magic, std::uint32_t abi, std::uint32_t request,
        std::uint32_t live, std::uint32_t control, std::uint32_t status) {
    return magic == 0x56535431 && abi == 0x10001 && request == 0 && live == 0
        && (control & 0x1du) == 0 && (status & 9u) == 9 && (status & 0x4770u) == 0;
}

double monotonic_seconds();

class NativeRoots {
    OwnerProof owner;
    std::unique_ptr<xrt::device> device;
    std::unique_ptr<RegisterMap> capture_map;
    std::unique_ptr<RegisterMap> dma_map;
    std::array<std::unique_ptr<xrt::bo>, 8> buffers{};
    bool armed = false;

public:
    NativeRoots(int descriptor, const std::string& journal, dev_t file_device, ino_t inode)
        : owner(descriptor, "/run/lock/voice_pcm_audio.lock", journal, file_device, inode) {
        if (!owner.confirmed())
            throw std::runtime_error("Native allocation requires the original active audio owner");
        capture_map = std::make_unique<RegisterMap>(0x413e0000);
        dma_map = std::make_unique<RegisterMap>(0x40430000);
        if (!release_after_stop())
            throw std::runtime_error("Native allocation requires a fresh stopped-source/SG proof");
        device = std::make_unique<xrt::device>(0u);
        for (std::size_t index = 0; index < buffers.size(); ++index) {
            if (!owner.confirmed())
                throw std::runtime_error("Audio owner lost during native allocation");
            const auto size = index % 2 == 0 ? 64u : 3840u;
            buffers[index] = std::make_unique<xrt::bo>(*device, size, xrt::bo::flags::normal, 0);
            const auto address = buffers[index]->address();
            if (address < 64 || address % 64 != 0 || address + size > 0x20000000ULL
                    || buffers[index]->size() != size)
                throw std::runtime_error("Native root allocation outside aligned DDR");
            for (std::size_t previous = 0; previous < index; ++previous) {
                const auto previous_address = buffers[previous]->address();
                if (address < previous_address + buffers[previous]->size()
                        && previous_address < address + size)
                    throw std::runtime_error("Native root allocations overlap");
            }
        }
    }

    xrt::bo& at(std::uint32_t index) {
        if (!owner.confirmed() || index >= buffers.size())
            throw std::runtime_error("Native buffer index or audio owner invalid");
        return *buffers[index];
    }

    void mark_armed() {
        if (armed || !owner.confirmed())
            throw std::runtime_error("Native root session cannot restart");
        armed = true;
    }

    bool release_without_dma() const {
        return !armed && owner.confirmed();
    }

    bool owned() const { return owner.confirmed(); }

    RegisterMap& registers(bool capture) {
        if (!owner.confirmed())
            throw std::runtime_error("Native register owner lost");
        return *(capture ? capture_map : dma_map);
    }

    bool release_after_stop() const {
        if (!owner.confirmed() || !capture_map || !dma_map)
            return false;
        const bool result = stopped_audio(capture_map->read(0), capture_map->read(0x24),
            capture_map->read(0x28), capture_map->read(0x2c), dma_map->read(0x30), dma_map->read(0x34));
        return result && owner.confirmed();
    }

    std::string stop_audio() {
        std::string errors;
        auto deadline = monotonic_seconds() + .05;
        auto check = [&] {
            if (monotonic_seconds() >= deadline || !owner.confirmed()
                    || monotonic_seconds() >= deadline)
                throw std::runtime_error("Native stop owner/deadline invalid");
        };
        auto read = [&](bool source, std::uint32_t offset) {
            check();
            const auto value = registers(source).read(offset);
            check();
            return value;
        };
        auto write = [&](bool source, std::uint32_t offset, std::uint32_t value) {
            check();
            registers(source).write(offset, value);
            check();
        };
        try {
            write(false, 0x30, 0x10000);
            bool halted = false;
            for (unsigned poll = 0; poll < 1024; ++poll) {
                const auto status = read(false, 0x34);
                if ((status & 8u) == 0)
                    throw std::runtime_error("Native stop lost SG identity");
                if ((status & 1u) != 0) { halted = true; break; }
                std::this_thread::sleep_for(std::chrono::microseconds(10));
                check();
            }
            if (!halted || (read(false, 0x30) & 0x1du) != 0)
                throw std::runtime_error("Native DMA halt unconfirmed");
        } catch (const std::exception& error) { errors = error.what(); }
        deadline = monotonic_seconds() + .05;
        try {
            if (read(true, 0) != 0x56535431 || read(true, 0x24) != 0x10001)
                throw std::runtime_error("Native stop capture identity invalid");
            write(true, 0x28, 0);
            bool off = false;
            for (unsigned poll = 0; poll < 1024; ++poll) {
                if (read(true, 0x28) == 0 && read(true, 0x2c) == 0) { off = true; break; }
                std::this_thread::sleep_for(std::chrono::microseconds(10));
                check();
            }
            if (!off || (read(false, 0x34) & 9u) != 9 || (read(false, 0x30) & 0x1du) != 0)
                throw std::runtime_error("Native source-off/final halt unconfirmed");
        } catch (const std::exception& error) {
            if (!errors.empty()) errors += "; ";
            errors += error.what();
        }
        return errors;
    }
};

struct Packet {
    std::uint32_t index = 0;
    double copied_at = 0;
    std::array<std::int32_t, samples_per_packet> samples{};
};

class PacketQueue {
    std::array<Packet, queue_capacity> packets{};
    std::atomic<std::uint32_t> written{0};
    std::atomic<std::uint32_t> consumed{0};

public:
    bool push(const Packet& packet) {
        const auto position = written.load(std::memory_order_relaxed);
        if (position - consumed.load(std::memory_order_acquire) >= queue_capacity)
            return false;
        packets[position % queue_capacity] = packet;
        written.store(position + 1, std::memory_order_release);
        return true;
    }

    bool pop(Packet& packet) {
        const auto position = consumed.load(std::memory_order_relaxed);
        if (position == written.load(std::memory_order_acquire))
            return false;
        packet = packets[position % queue_capacity];
        consumed.store(position + 1, std::memory_order_release);
        return true;
    }
};

bool valid_pcm(const Packet& packet) {
    for (const auto sample : packet.samples)
        if (sample < -32768 || sample > 32767)
            return false;
    return true;
}

double monotonic_seconds() {
    struct timespec value{};
    if (clock_gettime(CLOCK_MONOTONIC, &value) != 0)
        throw std::runtime_error("Native monotonic clock unavailable");
    return value.tv_sec + value.tv_nsec * 1e-9;
}

double thread_seconds() {
    struct timespec value{};
    if (clock_gettime(CLOCK_THREAD_CPUTIME_ID, &value) != 0)
        throw std::runtime_error("Native producer CPU clock unavailable");
    return value.tv_sec + value.tv_nsec * 1e-9;
}

struct Snapshot {
    std::uint32_t sequence = 0;
    std::uint32_t hardware_epoch = 0;
    std::uint64_t observed = 0;
    std::uint64_t accepted = 0;
    std::uint64_t dropped = 0;
    std::uint32_t flags = 0;
};

void validate_snapshot(const Snapshot& previous, const Snapshot& current) {
    if (current.sequence != previous.sequence + 1u
            || current.hardware_epoch != previous.hardware_epoch
            || current.observed < previous.observed || current.accepted < previous.accepted
            || (current.flags & ~3u) != 0
            || static_cast<bool>(current.flags & 2u) != static_cast<bool>(current.dropped)
            || current.dropped != 0 || (current.flags & 1u) == 0)
        throw std::runtime_error("Native capture sequence/epoch/progress/readiness/loss invalid");
}

class NativeMailbox {
    std::function<std::uint32_t(std::uint32_t)> read;
    std::function<void(std::uint32_t, std::uint32_t)> write;
    Snapshot previous;

public:
    NativeMailbox(std::function<std::uint32_t(std::uint32_t)> read_value,
            std::function<void(std::uint32_t, std::uint32_t)> write_value, Snapshot initial)
        : read(std::move(read_value)), write(std::move(write_value)), previous(initial) {}

    Snapshot snapshot() {
        if (read(0) != 0x56535431 || read(0x24) != 0x10001 || read(0x2c) != 3
                || read(0x30) != previous.hardware_epoch)
            throw std::runtime_error("Native capture identity/live/epoch changed");
        const auto old_control = read(4);
        const auto old_sequence = read(0x0c);
        if ((old_control != 0 && old_control != 2) || old_sequence != previous.sequence)
            throw std::runtime_error("Native mailbox busy or another snapshot owner");
        const auto expected = old_sequence + 1u;
        write(8, 1);
        bool completed = false;
        for (std::uint32_t poll = 0; poll < 1024; ++poll) {
            const auto control = read(4);
            const auto sequence = read(0x0c);
            if (control > 2 || (sequence != old_sequence && sequence != expected))
                throw std::runtime_error("Native mailbox encoding/sequence invalid");
            if (control == 2 && sequence == expected) {
                completed = true;
                break;
            }
        }
        if (!completed)
            throw std::runtime_error("Native mailbox poll ceiling");
        Snapshot current{};
        current.sequence = expected;
        current.hardware_epoch = previous.hardware_epoch;
        current.observed = read(0x10) | static_cast<std::uint64_t>(read(0x14)) << 32;
        current.dropped = read(0x18) | static_cast<std::uint64_t>(read(0x1c)) << 32;
        current.flags = read(0x20);
        current.accepted = read(0x34) | static_cast<std::uint64_t>(read(0x38)) << 32;
        if (read(0x0c) != expected || read(4) != 2 || read(0x30) != current.hardware_epoch
                || read(0x2c) != 3)
            throw std::runtime_error("Native snapshot changed during multiword copy");
        validate_snapshot(previous, current);
        previous = current;
        return current;
    }
};

struct LoopHooks {
    std::function<std::uint32_t(bool, std::uint32_t)> read_register;
    std::function<void(bool, std::uint32_t, std::uint32_t)> write_register;
    std::function<std::array<std::uint32_t, 16>(std::uint32_t)> read_descriptor;
    std::function<void(std::uint32_t, Packet&)> read_samples;
    std::function<void(std::uint32_t, const std::array<std::uint32_t, 16>&)> recycle;
    std::function<bool()> owner;
    std::array<std::array<std::uint32_t, 2>, 4> addresses{};
};

class NativeLoop {
    LoopHooks hooks;
    PacketQueue packets;
    std::atomic<bool> cancelled{false};
    std::atomic<bool> complete{false};
    std::atomic<bool> failed{false};
    bool used = false;
    double wall_deadline = 0;
    double cpu_deadline = 0;
    double last_poll;
    double last_packet;

    void guard() const {
        if (monotonic_seconds() >= wall_deadline || thread_seconds() >= cpu_deadline)
            throw std::runtime_error("Native receive 50ms wall/15ms CPU deadline exceeded");
        if (!hooks.owner())
            throw std::runtime_error("Native audio producer owner lost");
        if (monotonic_seconds() >= wall_deadline || thread_seconds() >= cpu_deadline)
            throw std::runtime_error("Native owner check exceeded receive deadline");
    }

    std::uint32_t read(bool capture, std::uint32_t offset) {
        guard();
        const auto value = hooks.read_register(capture, offset);
        guard();
        return value;
    }

    void write(bool capture, std::uint32_t offset, std::uint32_t value) {
        guard();
        hooks.write_register(capture, offset, value);
        guard();
    }

    void dma_status() {
        const auto value = read(false, 0x34);
        if ((value & 8u) == 0 || (value & 0x4770u) != 0 || (value & 1u) != 0
                || (read(false, 0x30) & 0x1du) != 1u)
            throw std::runtime_error("Native DMA SG/status/control changed");
    }

    std::array<std::uint32_t, 16> descriptor(std::uint32_t slot) const {
        std::array<std::uint32_t, 16> words{};
        words[0] = hooks.addresses[(slot + 1) % 4][0];
        words[2] = hooks.addresses[slot][1];
        words[6] = 3840;
        return words;
    }

    bool poll() {
        const auto begun = monotonic_seconds();
        const auto cpu = thread_seconds();
        wall_deadline = begun + .05;
        cpu_deadline = cpu + .015;
        max_service_gap = std::max(max_service_gap, begun - last_poll);
        if (begun - last_poll > .05 || begun - last_packet > .05)
            throw std::runtime_error("Native DMA service gap/packet stall");
        dma_status();
        const auto slot = produced % 4;
        guard();
        const auto words = hooks.read_descriptor(slot);
        guard();
        const auto expected = descriptor(slot);
        for (std::size_t word = 0; word < 7; ++word)
            if (words[word] != expected[word])
                throw std::runtime_error("Native descriptor ownership/address/control corruption");
        if ((words[7] & 0x70000000u) != 0)
            throw std::runtime_error("Native descriptor transfer error");
        Packet packet{};
        const bool ready = (words[7] & 0x80000000u) != 0;
        if (ready) {
            if (words[7] != 0x8c000f00u)
                throw std::runtime_error("Native descriptor not exactly 960 complete PCM samples");
            packet.index = produced;
            guard();
            hooks.read_samples(slot, packet);
            guard();
            if (!valid_pcm(packet))
                throw std::runtime_error("Native PCM is not sign-extended signed16");
        }
        latest = mailbox->snapshot();
        if (ready) {
            dma_status();
            packet.copied_at = monotonic_seconds();
            guard();
            hooks.recycle(slot, expected);
            guard();
            write(false, 0x40, hooks.addresses[slot][0]);
            guard();
            if (!packets.push(packet))
                throw std::runtime_error("Native CPU queue full; no overwrite or packet loss allowed");
            ++produced;
            last_packet = monotonic_seconds();
        }
        last_poll = monotonic_seconds();
        max_poll_wall = std::max(max_poll_wall, last_poll - begun);
        max_poll_cpu = std::max(max_poll_cpu, thread_seconds() - cpu);
        return ready;
    }

    std::unique_ptr<NativeMailbox> mailbox;

public:
    NativeRoots* bound_roots = nullptr;
    bool source_stopped = false;
    std::uint32_t produced = 0;
    double max_poll_wall = 0;
    double max_poll_cpu = 0;
    double max_service_gap = 0;
    Snapshot latest;
    std::string error;

    NativeLoop(LoopHooks supplied, Snapshot initial, double previous_poll, double previous_packet)
        : hooks(std::move(supplied)), last_poll(previous_poll), last_packet(previous_packet), latest(initial) {
        mailbox = std::make_unique<NativeMailbox>(
            [this](std::uint32_t offset) { return read(true, offset); },
            [this](std::uint32_t offset, std::uint32_t value) { write(true, offset, value); }, initial);
    }

    int run(std::uint32_t limit) {
        try {
            if (used || limit == 0 || limit > 900)
                throw std::runtime_error("Native producer requires one finite 1..900 packet run");
            used = true;
            while (produced < limit && !cancelled.load(std::memory_order_acquire)) {
                if (!poll())
                    std::this_thread::sleep_for(std::chrono::milliseconds(1));
            }
            complete.store(true, std::memory_order_release);
            return 0;
        } catch (const std::exception& failure) {
            error = failure.what();
            failed.store(true, std::memory_order_release);
            complete.store(true, std::memory_order_release);
            return -1;
        }
    }

    int pop(Packet& packet) {
        if (failed.load(std::memory_order_acquire))
            return -1;
        return packets.pop(packet) ? 1 : 0;
    }

    void request_stop() { cancelled.store(true, std::memory_order_release); }
    bool finished() const { return complete.load(std::memory_order_acquire); }
};

static_assert(std::is_constructible<xrt::device, unsigned int>::value);
static_assert(std::is_constructible<xrt::bo, const xrt::device&, std::size_t,
              xrt::bo::flags, xrt::memory_group>::value);
static_assert(sizeof(std::int32_t) * samples_per_packet == 3840);
}

extern "C" std::uint32_t vvg_voice_native_abi() {
    return 0x00010000;
}

extern "C" const char* vvg_voice_native_error() {
    return last_error.c_str();
}

extern "C" void* vvg_voice_native_roots_create(int descriptor, const char* journal,
        std::uint32_t journal_size, std::uint64_t file_device, std::uint64_t inode) {
    try {
        if (!journal || journal_size == 0 || journal_size > 4096)
            throw std::runtime_error("Invalid active owner journal bytes");
        const std::string expected(journal, journal_size);
        if (expected.find("\"state\": \"ACTIVE\"") == std::string::npos)
            throw std::runtime_error("Native allocation requires an ACTIVE journal");
        return new NativeRoots(descriptor, expected, static_cast<dev_t>(file_device), static_cast<ino_t>(inode));
    } catch (const std::exception& error) {
        last_error = error.what();
        return nullptr;
    }
}

extern "C" int vvg_voice_native_root_info(void* context, std::uint32_t index,
        std::uint64_t* address, std::uint64_t* pointer, std::uint32_t* size) {
    try {
        if (!context || !address || !pointer || !size)
            throw std::runtime_error("Native root info arguments missing");
        auto& buffer = static_cast<NativeRoots*>(context)->at(index);
        *address = buffer.address();
        *pointer = reinterpret_cast<std::uintptr_t>(buffer.map());
        *size = static_cast<std::uint32_t>(buffer.size());
        return 0;
    } catch (const std::exception& error) {
        last_error = error.what();
        return -1;
    }
}

extern "C" int vvg_voice_native_root_sync(void* context, std::uint32_t index, int to_device) {
    try {
        if (!context || (to_device != 0 && to_device != 1))
            throw std::runtime_error("Native root sync arguments invalid");
        auto& buffer = static_cast<NativeRoots*>(context)->at(index);
        buffer.sync(to_device ? XCL_BO_SYNC_BO_TO_DEVICE : XCL_BO_SYNC_BO_FROM_DEVICE);
        return 0;
    } catch (const std::exception& error) {
        last_error = error.what();
        return -1;
    }
}

extern "C" int vvg_voice_native_roots_mark_armed(void* context) {
    try {
        if (!context)
            throw std::runtime_error("Native roots context missing");
        static_cast<NativeRoots*>(context)->mark_armed();
        return 0;
    } catch (const std::exception& error) {
        last_error = error.what();
        return -1;
    }
}

extern "C" int vvg_voice_native_roots_release_unarmed(void* context) {
    if (!context || !static_cast<NativeRoots*>(context)->release_without_dma()) {
        last_error = "Armed or owner-invalid native roots must remain retained";
        return -1;
    }
    delete static_cast<NativeRoots*>(context);
    return 0;
}

extern "C" int vvg_voice_native_roots_release_stopped(void* context) {
    try {
        if (!context || !static_cast<NativeRoots*>(context)->release_after_stop())
            throw std::runtime_error("Native audio roots retained: fresh SG-halted/source-off proof missing");
        delete static_cast<NativeRoots*>(context);
        return 0;
    } catch (const std::exception& error) {
        last_error = error.what();
        return -1;
    }
}

extern "C" void* vvg_voice_native_loop_create(void* context, std::uint32_t sequence,
        std::uint32_t hardware_epoch, std::uint64_t observed, std::uint64_t accepted,
        double last_poll, double last_packet) {
    try {
        if (!context || !static_cast<NativeRoots*>(context)->owned())
            throw std::runtime_error("Native loop requires exact active root owner");
        auto* roots = static_cast<NativeRoots*>(context);
        LoopHooks hooks{};
        hooks.owner = [roots] { return roots->owned(); };
        hooks.read_register = [roots](bool capture, std::uint32_t offset) {
            return roots->registers(capture).read(offset);
        };
        hooks.write_register = [roots](bool capture, std::uint32_t offset, std::uint32_t value) {
            if ((capture && (offset != 8 || value != 1)) || (!capture && offset != 0x40))
                throw std::runtime_error("Native producer may only request snapshots/replenish S2MM tail");
            roots->registers(capture).write(offset, value);
        };
        for (std::uint32_t slot = 0; slot < 4; ++slot)
            hooks.addresses[slot] = {static_cast<std::uint32_t>(roots->at(slot * 2).address()),
                                    static_cast<std::uint32_t>(roots->at(slot * 2 + 1).address())};
        hooks.read_descriptor = [roots](std::uint32_t slot) {
            auto& buffer = roots->at(slot * 2);
            buffer.sync(XCL_BO_SYNC_BO_FROM_DEVICE);
            std::array<std::uint32_t, 16> words{};
            std::memcpy(words.data(), buffer.map(), 64);
            return words;
        };
        hooks.read_samples = [roots](std::uint32_t slot, Packet& packet) {
            auto& buffer = roots->at(slot * 2 + 1);
            buffer.sync(XCL_BO_SYNC_BO_FROM_DEVICE);
            std::memcpy(packet.samples.data(), buffer.map(), 3840);
        };
        hooks.recycle = [roots](std::uint32_t slot, const std::array<std::uint32_t, 16>& words) {
            roots->at(slot * 2 + 1).sync(XCL_BO_SYNC_BO_TO_DEVICE);
            auto& descriptor = roots->at(slot * 2);
            std::memcpy(descriptor.map(), words.data(), 64);
            descriptor.sync(XCL_BO_SYNC_BO_TO_DEVICE);
        };
        auto* loop = new NativeLoop(std::move(hooks), Snapshot{sequence, hardware_epoch, observed, accepted, 0, 1},
                        last_poll, last_packet);
        loop->bound_roots = roots;
        return loop;
    } catch (const std::exception& error) {
        last_error = error.what();
        return nullptr;
    }
}

extern "C" int vvg_voice_native_loop_run(void* context, std::uint32_t limit) {
    if (!context) { last_error = "Native loop context missing"; return -1; }
    auto* loop = static_cast<NativeLoop*>(context);
    const auto result = loop->run(limit);
    const auto cleanup_error = loop->bound_roots ? loop->bound_roots->stop_audio()
                                               : "Native loop root binding missing";
    loop->source_stopped = cleanup_error.empty();
    if (result != 0 || !cleanup_error.empty()) {
        last_error = loop->error;
        if (!cleanup_error.empty()) last_error += "; native stop: " + cleanup_error;
        return -1;
    }
    return 0;
}

extern "C" int vvg_voice_native_loop_info(void* context, std::uint64_t* counters, double* timing) {
    if (!context || !counters || !timing || !static_cast<NativeLoop*>(context)->finished()) return -1;
    const auto& loop = *static_cast<NativeLoop*>(context);
    counters[0] = loop.produced;
    counters[1] = loop.latest.sequence;
    counters[2] = loop.latest.hardware_epoch;
    counters[3] = loop.latest.observed;
    counters[4] = loop.latest.accepted;
    counters[5] = loop.latest.dropped;
    counters[6] = loop.latest.flags;
    timing[0] = loop.max_poll_wall;
    timing[1] = loop.max_poll_cpu;
    timing[2] = loop.max_service_gap;
    return 0;
}

extern "C" int vvg_voice_native_loop_pop(void* context, std::uint32_t* index,
        double* copied_at, std::int32_t* samples) {
    if (!context || !index || !copied_at || !samples) return -1;
    Packet packet{};
    const auto result = static_cast<NativeLoop*>(context)->pop(packet);
    if (result == 1) {
        *index = packet.index;
        *copied_at = packet.copied_at;
        std::memcpy(samples, packet.samples.data(), 3840);
    }
    return result;
}

extern "C" int vvg_voice_native_loop_finished(void* context) {
    return context && static_cast<NativeLoop*>(context)->finished();
}

extern "C" void vvg_voice_native_loop_request_stop(void* context) {
    if (context) static_cast<NativeLoop*>(context)->request_stop();
}

extern "C" int vvg_voice_native_loop_destroy(void* context) {
    if (!context || !static_cast<NativeLoop*>(context)->finished()) return -1;
    delete static_cast<NativeLoop*>(context);
    return 0;
}

extern "C" int vvg_voice_native_model_check() {
    try {
        PacketQueue queue;
        Packet packet;
        if (queue.pop(packet))
            return 1;
        for (std::uint32_t index = 0; index < queue_capacity; ++index) {
            packet.index = index;
            packet.samples.fill(static_cast<std::int32_t>(index));
            if (!queue.push(packet))
                return 2;
        }
        packet.samples.fill(-1);
        if (queue.push(packet))
            return 3;
        for (std::uint32_t index = 0; index < queue_capacity; ++index) {
            if (!queue.pop(packet) || packet.index != index || !valid_pcm(packet))
                return 4;
            for (const auto sample : packet.samples)
                if (sample != static_cast<std::int32_t>(index))
                    return 5;
        }
        packet.samples.fill(-32768);
        if (!valid_pcm(packet))
            return 6;
        packet.samples[0] = 32767;
        if (!valid_pcm(packet))
            return 7;
        packet.samples[0] = 32768;
        if (valid_pcm(packet))
            return 8;
        packet.samples[0] = -32769;
        if (valid_pcm(packet))
            return 9;
        std::atomic<int> failure{0};
        std::thread consumer([&] {
            Packet received;
            for (std::uint32_t index = 0; index < 900; ++index) {
                while (!queue.pop(received))
                    std::this_thread::yield();
                if (received.index != index || !valid_pcm(received))
                    failure.store(10);
                for (const auto sample : received.samples)
                    if (sample != static_cast<std::int32_t>(index))
                        failure.store(11);
            }
        });
        for (std::uint32_t index = 0; index < 900; ++index) {
            packet.index = index;
            packet.samples.fill(static_cast<std::int32_t>(index));
            while (!queue.push(packet))
                std::this_thread::yield();
        }
        consumer.join();
        return failure.load();
    } catch (...) {
        return 12;
    }
}

extern "C" int vvg_voice_native_owner_model_check() {
    char path[] = "/tmp/vvg-voice-owner-model-XXXXXX";
    const int descriptor = mkstemp(path);
    if (descriptor < 0)
        return 1;
    int failure = 0;
    try {
        const std::string journal = "{\"state\":\"ACTIVE\",\"version\":1}";
        struct stat file{};
        if (write(descriptor, journal.data(), journal.size()) != static_cast<ssize_t>(journal.size())
                || fstat(descriptor, &file) != 0)
            failure = 2;
        else {
            OwnerProof owner(descriptor, path, journal, file.st_dev, file.st_ino);
            if (!owner.confirmed())
                failure = 3;
            bool other_thread_confirmed = true;
            std::thread other([&] { other_thread_confirmed = owner.confirmed(); });
            other.join();
            if (other_thread_confirmed)
                failure = 4;
            const char changed = '!';
            if (pwrite(descriptor, &changed, 1, 0) != 1 || owner.confirmed())
                failure = 5;
            if (pwrite(descriptor, journal.data(), journal.size(), 0) != static_cast<ssize_t>(journal.size())
                    || !owner.confirmed())
                failure = 6;
            if (unlink(path) != 0 || owner.confirmed())
                failure = 7;
        }
    } catch (...) {
        failure = 8;
    }
    unlink(path);
    close(descriptor);
    return failure;
}

extern "C" int vvg_voice_native_health_model_check() {
    Snapshot previous{88, 7, 100, 100, 0, 1};
    Snapshot current{89, 7, 1060, 1060, 0, 1};
    try {
        validate_snapshot(previous, current);
        if (monotonic_seconds() <= 0 || thread_seconds() < 0)
            return 1;
        for (unsigned mutation = 0; mutation < 8; ++mutation) {
            auto invalid = current;
            switch (mutation) {
            case 0: invalid.sequence = 90; break;
            case 1: invalid.hardware_epoch = 8; break;
            case 2: invalid.observed = 99; break;
            case 3: invalid.accepted = 99; break;
            case 4: invalid.flags = 5; break;
            case 5: invalid.flags = 3; break;
            case 6: invalid.flags = 0; break;
            default: invalid.dropped = 1; invalid.flags = 3; break;
            }
            bool rejected = false;
            try { validate_snapshot(previous, invalid); }
            catch (const std::runtime_error&) { rejected = true; }
            if (!rejected)
                return 2;
        }
        auto wrap_previous = previous;
        auto wrap_current = current;
        wrap_previous.sequence = 0xffffffff;
        wrap_current.sequence = 0;
        validate_snapshot(wrap_previous, wrap_current);
        for (unsigned fault = 0; fault < 6; ++fault) {
            std::array<std::uint32_t, 15> registers{};
            registers[0] = 0x56535431;
            registers[1] = 2;
            registers[3] = 88;
            registers[4] = 100;
            registers[8] = 1;
            registers[9] = 0x10001;
            registers[11] = 3;
            registers[12] = 7;
            registers[13] = 100;
            if (fault == 1) registers[0] = 0;
            if (fault == 2) registers[1] = 1;
            if (fault == 3) registers[3] = 87;
            NativeMailbox mailbox([&](std::uint32_t offset) { return registers.at(offset / 4); },
                [&](std::uint32_t offset, std::uint32_t value) {
                    if (offset != 8 || value != 1)
                        throw std::runtime_error("Unexpected native model mailbox command");
                    registers[3] = fault == 4 ? 91 : 89;
                    registers[4] = 1060;
                    registers[13] = 1060;
                    if (fault == 5) { registers[6] = 1; registers[8] = 3; }
                }, previous);
            bool failed = false;
            try {
                const auto result = mailbox.snapshot();
                if (result.observed != 1060 || result.accepted != 1060 || result.sequence != 89)
                    return 3;
            } catch (const std::runtime_error&) { failed = true; }
            if (failed != (fault != 0))
                return 4;
        }
    } catch (...) { return 5; }
    return 0;
}

extern "C" int vvg_voice_native_loop_model_check() {
    if (!stopped_audio(0x56535431, 0x10001, 0, 0, 0x10000, 0x10009)
            || stopped_audio(0x56535431, 0x10001, 0, 0, 0x10000, 0x10008)
            || stopped_audio(0x56535431, 0x10001, 0, 0, 0x10001, 0x10009)
            || stopped_audio(0x56535431, 0x10001, 0, 3, 0x10000, 0x10009)
            || stopped_audio(0x56535431, 0x10001, 0, 0, 0x10000, 0x14779))
        return 6;
    for (unsigned fault = 0; fault < 6; ++fault) {
        std::array<std::uint32_t, 15> capture{};
        capture[0] = 0x56535431;
        capture[1] = 2;
        capture[3] = 88;
        capture[4] = 100;
        capture[8] = 1;
        capture[9] = 0x10001;
        capture[11] = 3;
        capture[12] = 7;
        capture[13] = 100;
        LoopHooks hooks{};
        for (unsigned slot = 0; slot < 4; ++slot)
            hooks.addresses[slot] = {0x100000 + slot * 0x2000, 0x101000 + slot * 0x2000};
        hooks.owner = [] { return true; };
        hooks.read_register = [&](bool source, std::uint32_t offset) {
            if (source) return capture.at(offset / 4);
            return offset == 0x30 ? 0x10001u : (fault == 3 ? 0x4778u : 8u);
        };
        hooks.write_register = [&](bool source, std::uint32_t offset, std::uint32_t value) {
            if (source) {
                if (offset != 8 || value != 1)
                    throw std::runtime_error("Unexpected model capture write");
                capture[3] += fault == 4 ? 2 : 1;
                capture[4] += 960;
                capture[13] += 960;
            } else if (offset != 0x40) {
                throw std::runtime_error("Unexpected model DMA write");
            }
        };
        hooks.read_descriptor = [&](std::uint32_t slot) {
            std::array<std::uint32_t, 16> words{};
            words[0] = hooks.addresses[(slot + 1) % 4][0];
            words[2] = hooks.addresses[slot][1];
            words[6] = 3840;
            words[7] = 0x8c000f00;
            if (fault == 1) ++words[2];
            return words;
        };
        hooks.read_samples = [&](std::uint32_t, Packet& packet) {
            packet.samples.fill(fault == 2 ? 32768 : 17);
        };
        hooks.recycle = [](std::uint32_t, const std::array<std::uint32_t, 16>&) {};
        const auto now = monotonic_seconds();
        NativeLoop loop(hooks, Snapshot{88, 7, 100, 100, 0, 1}, now, now);
        const auto result = loop.run(fault == 5 ? 65 : 32);
        if ((result == 0) != (fault == 0))
            return 1;
        if (!loop.finished() || loop.produced != (fault == 0 ? 32u : (fault == 5 ? 64u : 0u)))
            return 2;
        Packet packet{};
        if (fault == 0) {
            for (unsigned index = 0; index < 32; ++index)
                if (loop.pop(packet) != 1 || packet.index != index || packet.samples[959] != 17)
                    return 3;
            if (loop.pop(packet) != 0)
                return 4;
        } else if (loop.pop(packet) != -1) {
            return 5;
        }
    }
    return 0;
}

extern "C" int vvg_voice_native_loop_stopped(void* context) {
    return context && static_cast<NativeLoop*>(context)->source_stopped;
}