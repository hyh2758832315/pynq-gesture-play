#include <pybind11/pybind11.h>
#include <xrt/xrt_bo.h>

#include <stdexcept>

#ifdef VVG_SYNC_MODEL
#include <chrono>
#include <thread>

struct ModelBuffer {
    unsigned int calls = 0;
    bool fail = false;

    void sync(xclBOSyncDirection) {
        ++calls;
        std::this_thread::sleep_for(std::chrono::milliseconds(10));
        if (fail) {
            throw std::runtime_error("model sync failure");
        }
    }
};
#endif

namespace py = pybind11;

template <typename Buffer>
void synchronize(Buffer& buffer, int direction) {
    if (direction != XCL_BO_SYNC_BO_TO_DEVICE && direction != XCL_BO_SYNC_BO_FROM_DEVICE) {
        throw std::invalid_argument("Only host/device buffer cache synchronization is permitted");
    }
    py::gil_scoped_release release;
    buffer.sync(static_cast<xclBOSyncDirection>(direction));
}

PYBIND11_MODULE(voice_xrt_sync, module) {
    module.attr("abi") = 10000;
#ifdef VVG_SYNC_MODEL
    module.attr("model") = true;
    py::class_<ModelBuffer>(module, "ModelBuffer")
        .def(py::init<>())
        .def_readwrite("fail", &ModelBuffer::fail)
        .def_readonly("calls", &ModelBuffer::calls);
    module.def("sync", &synchronize<ModelBuffer>);
#else
    module.attr("model") = false;
    module.def("sync", &synchronize<xrt::bo>);
#endif
}