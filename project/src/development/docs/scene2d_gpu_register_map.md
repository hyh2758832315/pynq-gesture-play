# Scene2D GPU ABI and Register Map

## 1. Binary conventions

- ABI version: 1.0
- Byte order: little-endian
- AXI data width: 32 bits
- Scene header: 64 bytes, 16 words
- Command: 32 bytes, 8 words
- Command capacity: 128 entries per 4 KiB bank
- Signed coordinates: two's-complement
- Reserved fields: write zero, ignore on read

## 2. Scene header

| Word | Field | Description |
| ---: | --- | --- |
| 0 | `MAGIC` | Bytes `S2DG` |
| 1 | `ABI_VERSION` | Major in bits 31:16, minor in bits 15:0 |
| 2 | `FRAME_ID` | Game frame identifier |
| 3 | `SUBMIT_SEQ` | Monotonic submission sequence |
| 4 | `COMMAND_COUNT` | 0 through 128 |
| 5 | `CAMERA_X` | Signed 32-bit world camera X |
| 6 | `CAMERA_Y` | Signed 32-bit world camera Y |
| 7 | `BACKGROUND_RGB` | R in 23:16, G in 15:8, B in 7:0 |
| 8 | `PALETTE_GENERATION` | Required resident palette generation |
| 9 | `PREDICTED_CYCLES` | PS estimate used for early rejection |
| 10 | `ASSET_GENERATION` | Required resident Asset generation |
| 11-15 | Reserved | Zero |

## 3. Common command word

Every command uses word 0:

| Bits | Field |
| --- | --- |
| 7:0 | Opcode |
| 15:8 | Flags |
| 31:16 | Reserved |

Opcodes are `CLEAR=1`, `DRAW_TILE_LAYER=2`, `BLIT_INDEX4=3`, `FILL_RECT=4`, and `END_FRAME=255`.

## 4. CLEAR

| Word | Field |
| ---: | --- |
| 0 | Opcode |
| 1 bits 7:0 | Framebuffer token |
| 2-7 | Reserved |

The standard Scene compiler clears to token `0x00`.

## 5. DRAW_TILE_LAYER

| Word | Field |
| ---: | --- |
| 0 | Opcode |
| 1 bits 15:0 | Tile atlas asset ID |
| 1 bits 31:16 | Tilemap ID |
| 2 | Signed 32-bit screen origin X |
| 3 | Signed 32-bit screen origin Y |
| 4 bits 15:0 | Width in tiles |
| 4 bits 31:16 | Height in tiles |
| 5 bits 15:0 | Tile size, positive power of two |
| 6-7 | Reserved |

V1 tile descriptors are 32 bits: tile ID in 15:0, palette bank in 19:16, flip X in bit 20, flip Y in bit 21, and zero in 31:22.

Tilemap payloads begin with a 16-byte header: width/height packed into word 0, signed 32-bit origin X and Y in words 1 and 2, and tile size in word 3. The descriptor array follows immediately.

## 6. BLIT_INDEX4

| Word | Field |
| ---: | --- |
| 0 bit 8 | Flip X |
| 0 bit 9 | Flip Y |
| 1 bits 15:0 | Asset ID |
| 1 bits 19:16 | Palette bank |
| 2 bits 15:0 | Signed destination X |
| 2 bits 31:16 | Signed destination Y |
| 3 bits 15:0 | Width |
| 3 bits 31:16 | Height |
| 4 bits 15:0 | Unsigned source X |
| 4 bits 31:16 | Unsigned source Y |
| 5-7 | Reserved |

Source index 0 is transparent. Other source indices form the output token with the command palette bank.

## 7. Asset descriptors

Each asset descriptor is 16 bytes:

| Word | Field |
| ---: | --- |
| 0 | Byte offset in the asset payload window |
| 1 bits 15:0 | Width in pixels |
| 1 bits 31:16 | Height in pixels |
| 2 bits 15:0 | Packed row stride in bytes |
| 2 bits 23:16 | Format, `INDEX4=1` |
| 2 bits 31:24 | Asset generation |
| 3 | Packed payload size in bytes |

Assets start on 64-byte boundaries. In each packed byte, the even-X pixel occupies bits 3:0 and the odd-X pixel occupies bits 7:4. Odd-width rows pad the final high nibble with zero.

C4M6 defines ASSET target ID 0 as an atomic bundle containing exactly the descriptors for asset IDs 0, 1, and 2. Its first 48 payload bytes are the descriptor table; each `base_offset` addresses the following shared payload window. A bundle generation is committed as one bank switch.

Palette payloads contain 256 little-endian 32-bit words in bank-major order. Each word has red in bits 23:16, green in 15:8, blue in 7:0, and zero in 31:24.

## 8. FILL_RECT

| Word | Field |
| ---: | --- |
| 0 | Opcode |
| 1 bits 7:0 | Framebuffer token |
| 2 bits 15:0 | Signed destination X |
| 2 bits 31:16 | Signed destination Y |
| 3 bits 15:0 | Width |
| 3 bits 31:16 | Height |
| 4-7 | Reserved |

## 9. END_FRAME

Word 0 contains opcode 255 and words 1 through 7 are zero. Commands after `END_FRAME` are ignored.

## 10. AXI-Lite control registers

The physical base address is assigned by the C4 Block Design and recorded in the HWH and build manifest.

| Offset | Name | Access | Description |
| ---: | --- | --- | --- |
| 0x00 | `BUILD_ID` | R | C4 build identifier |
| 0x04 | `ABI_VERSION` | R | Implemented major/minor |
| 0x08 | `CAPABILITIES0` | R | Supported opcodes and fixed profile |
| 0x0C | `STATUS` | R | Idle, validating, rendering, ready, error |
| 0x10 | `CONTROL` | W | Submit, abort, soft reset, clear errors |
| 0x14 | `SUBMIT_SEQ` | RW | Sequence associated with the next submit |
| 0x18 | `SUBMIT_BANK` | RW | Inactive command bank 0 or 1 |
| 0x1C | `COMMAND_COUNT` | RW | Number of valid commands |
| 0x20 | `ACCEPTED_SEQ` | R | Most recently accepted submission |
| 0x24 | `DISPLAYED_SEQ` | R | Most recently presented submission |
| 0x28 | `ACTIVE_FB` | R | Active framebuffer and command banks |
| 0x2C | `VSYNC_COUNT` | R | Monotonic displayed-frame count |
| 0x30 | `RENDER_CYCLES_LAST` | R | Last completed render duration |
| 0x34 | `RENDER_CYCLES_MAX` | R | Maximum render duration since clear |
| 0x38 | `DEADLINE_MISS_COUNT` | R | Watchdog or late-display count |
| 0x3C | `ERROR_FLAGS` | R | Sticky error bitmap |
| 0x40 | `ERROR_COUNT` | R | Total rejected or aborted frames |
| 0x44 | `ERROR_FIRST_COMMAND` | R | First failing command index |
| 0x48 | `IRQ_ENABLE` | RW | Interrupt enable bitmap |
| 0x4C | `IRQ_STATUS` | RW1C | Interrupt status |

`CONTROL.SUBMIT` is the final write after the PS has completed the header and command bank. The driver must issue a memory barrier before this write.

## 11. Submission states

1. PS verifies that the selected command bank and framebuffer are available.
2. PS writes the complete header and commands.
3. PS writes `SUBMIT_SEQ`, `SUBMIT_BANK`, and `COMMAND_COUNT`.
4. PS performs a write memory barrier.
5. PS writes `CONTROL.SUBMIT`.
6. PL validates the bank and updates `ACCEPTED_SEQ`.
7. PL renders the inactive framebuffer.
8. Pixel logic presents it at vertical blank and updates `DISPLAYED_SEQ`.

Only one submission is outstanding in V1. A submit while busy is rejected and increments the error counter.

## 12. Error flags

| Bit | Meaning |
| ---: | --- |
| 0 | ABI or magic mismatch |
| 1 | Command count overflow |
| 2 | Unknown opcode or nonzero reserved field |
| 3 | Invalid asset or generation |
| 4 | Atlas source out of bounds |
| 5 | Invalid tilemap or tile descriptor |
| 6 | Invalid palette bank |
| 7 | Predicted cycle budget exceeded |
| 8 | Hardware watchdog expired |
| 9 | Submit received while busy |

Errors invalidate only the pending frame. The active framebuffer remains displayed.

## 13. C4T transport validation map

C4T is an independent transport proof with BUILD_ID `0xC0040000`. It validates the PS-to-PL data plane before the complete C4 control block is implemented.

| Address | IP | Register | Access | Description |
| ---: | --- | ---: | --- | --- |
| 0x40400000 | AXI DMA | standard MM2S map | RW | Simple-mode DMA control, 26-bit transfer length |
| 0x41200000 | BUILD_ID GPIO | 0x00 | R | Returns `0xC0040000` |
| 0x41210000 | Upload status GPIO | 0x00 | R | Completed reflected CRC-32 |
| 0x41210000 | Upload status GPIO | 0x08 | R | Completed byte count |
| 0x41220000 | Upload count GPIO | 0x00 | R | Completed packet count |

Software samples the packet count before starting DMA and waits for it to increment after `sendchannel.wait()`. This guarantees that the second CRC pipeline cycle has committed the coherent CRC and byte-count snapshot.

## 14. C4M1 command-upload validation map

C4M1 is the independent SceneHeader and dual-command-bank proof with BUILD_ID `0xC0040100`. The DMA uploads one fixed 4,160-byte packet through HP0. All GPIO channels use offset `0x00` for channel 1 and `0x08` for channel 2.

| Address | IP | Channel 1 | Channel 2 |
| ---: | --- | --- | --- |
| 0x40400000 | AXI DMA | Standard MM2S map | - |
| 0x41200000 | BUILD_ID GPIO | `0xC0040100` | - |
| 0x41210000 | Upload status GPIO | Completed CRC-32 | Completed byte count |
| 0x41220000 | Packet status GPIO | Completed packet count | Accepted packet count |
| 0x41230000 | Command status GPIO | Accepted submit sequence | Count bits 8:0, active bank bit 9, valid bit 10 |
| 0x41240000 | Error status GPIO | Rejected packet count | Sticky error flags bits 5:0 |
| 0x41250000 | Read address GPIO | Active-bank 64-bit word address bits 8:0 | - |
| 0x41260000 | Read data GPIO | Active-bank data bits 31:0 | Active-bank data bits 63:32 |

C4M1 sticky error bits are magic, ABI, command count, reserved header, packet length, and TKEEP in bits 0 through 5 respectively. A rejected packet updates the rejected count and sticky flags while preserving the accepted sequence and active bank.

## 15. C4M6 runtime Asset status map

C4M6 has BUILD_ID `0xC0040600`. It retains the C4M3 scene, render, present, framebuffer, and router mappings, then adds fixed runtime palette and Asset status GPIOs. All dual-channel GPIOs use offset `0x00` for channel 1 and `0x08` for channel 2.

| Address | IP | Channel 1 | Channel 2 |
| ---: | --- | --- | --- |
| 0x412D0000 | Router status GPIO | Dropped packet count | Unsupported packet count |
| 0x412E0000 | Palette packet status GPIO | Accepted packet count | Rejected packet count |
| 0x412F0000 | Palette generation status GPIO | Committed generation | Sticky error flags |
| 0x41300000 | Palette state status GPIO | Bank ownership/state | - |
| 0x41310000 | Asset packet status GPIO | Accepted bundle count | Rejected bundle count |
| 0x41320000 | Asset generation status GPIO | Committed bundle generation | Sticky error flags |
| 0x41330000 | Asset state status GPIO | Bundle bank ownership/state | - |

An ASSET packet targets ID 0 and atomically commits exactly three INDEX4 descriptors for runtime asset IDs 0, 1, and 2. A Scene waits until both its `PALETTE_GENERATION` and `ASSET_GENERATION` match committed runtime state.