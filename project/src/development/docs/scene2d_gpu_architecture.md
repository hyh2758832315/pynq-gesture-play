# Scene2D GPU Architecture

## 1. Scope

`scene2d_gpu` is a command-driven FPGA 2D graphics processor for PYNQ-Z2. The PS runs game logic at 60 Hz and compiles a high-level `Scene` into drawing commands. The PL rasterizes those commands into an inactive on-chip framebuffer and presents the completed frame at the next vertical blank.

The first hardware profile is fixed:

| Item | Value |
| --- | --- |
| Device | XC7Z020CLG400-1 |
| AXI/render clock | 100 MHz |
| Pixel clock | 74.25 MHz |
| Logical frame | 320x180 |
| HDMI output | 1280x720@60 |
| Scale | 4x nearest-neighbor |
| Asset format | 4-bit indexed color |
| Framebuffer format | 8-bit palette token |
| Palette | 16 banks x 16 RGB888 colors |
| Transparency | Source color index 0 |
| Command bank | 4 KiB, 128 commands |

Rotation, arbitrary scaling, alpha blending, triangles, shaders, and paged DDR textures are versioned extensions rather than V1 requirements.

## 2. Reference project boundary

PainterEngine provides useful patterns for opcode dispatch, parameter latching, status reporting, error states, and pipeline-valid alignment. Its renderer performs DDR source/destination read-modify-write operations and then presents an RGB framebuffer through VDMA.

Scene2D uses an independent implementation:

- AXI-Lite is limited to control and counters.
- A 64-bit AXI DMA reads command and asset batches from PS DDR through HP0.
- The PL validates the stream and stores accepted data in command and asset BRAM.
- Rendering targets on-chip indexed framebuffers.
- Pixel scanout never waits for AXI or DDR.
- Clock-domain crossings use Xilinx XPM memory and handshake primitives.

PainterEngine remains a read-only Apache-2.0 architectural reference. Any future line-level reuse requires preservation of its license notice and a separate audit of bundled display logic.

## 3. Data flow

1. The PS creates a `Scene` and sorts sprites by ascending priority. Python sorting is stable, so equal-priority sprites retain submission order.
2. `SceneCompiler` emits `CLEAR`, optional `DRAW_TILE_LAYER`, ordered `BLIT_INDEX4`, HUD `FILL_RECT`/font blits, and `END_FRAME` with required Palette and Asset generations.
3. The PS packs the scene in contiguous DDR memory and starts an AXI DMA MM2S transfer through HP0.
4. The PL validates and stores the uploaded scene, then the PS submits its sequence number and bank through GP0.
5. The 100 MHz renderer validates the header and executes commands into the inactive framebuffer.
6. Completion crosses to the pixel domain as `{ready_seq, ready_bank, palette_bank}` through `xpm_cdc_handshake`.
7. The pixel domain swaps banks only at vertical blank, scans one logical pixel for each 4x4 output block, and expands the token through the active palette.
8. `displayed_seq` crosses back to the render domain before that framebuffer can be reused.

### 3.1 Runtime resource packet ABI

Scene uploads retain the existing fixed 64-byte header and 4 KiB command bank. Runtime resources share a separate 64-byte header followed immediately by an unpadded payload; the final AXI beat uses `TKEEP` for byte validity.

| Word | Field |
| ---: | --- |
| 0 | Type-specific routing magic: `S2DA`, `S2DT`, `S2DP`, or `S2DF` |
| 1 | ABI major in bits 31:16 and minor in bits 15:0 |
| 2 | Packet type: ASSET=1, TILEMAP=2, PALETTE=3, FRAME8=4 |
| 3 | Target slot ID |
| 4 | 32-bit generation |
| 5 | Payload byte count |
| 6 | Payload CRC-32 |
| 7 | Flags, zero in ABI 1.0 |
| 8-15 | Reserved, zero in ABI 1.0 |

The first 32-bit word is available in the first 64-bit AXI beat. `scene2d_packet_router` therefore selects SCENE, ASSET, TILEMAP, PALETTE, or FRAME8 without consuming and replaying that beat. Selection and unknown-packet drop state remain locked through `TLAST`. CRC-32 covers payload bytes only, using the Ethernet polynomial implemented by Python `zlib.crc32` and the RTL upload sinks.

`third_party/verilog-axis/rtl/axis_demux.v` is vendored from Alex Forencich's MIT-licensed `verilog-axis` commit `48ff7a7e2ef782cf778d47910cf85835c64b1bce`. The local wrapper owns magic decoding and dropped-packet accounting; the upstream module owns AXI framing and backpressure.

### 3.2 C4M6 Asset bundle

C4M6 uses `ASSET` target ID 0 as one atomic bundle with exactly three descriptors: sprite atlas (ID 0), tile atlas (ID 1), and font atlas (ID 2). The payload starts with three 16-byte descriptors, followed by their packed INDEX4 bytes in one shared 64-byte-aligned window. Descriptor `base_offset` is relative to that window, which begins immediately after the 48-byte descriptor table. Both data and descriptors are written to the inactive bundle bank, then switch together when the renderer is idle. A Scene starts only when its required Asset generation matches the committed bundle generation.

### 3.3 Optional P4 Scene upload overlap

`UPLOAD_RENDER_OVERLAP_ENABLE` defaults to zero. The C0060760 profile enables uploading one next Scene while the current frame renders, reusing the two existing 4 KiB command banks. The renderer pins its read bank at start; one READY bank applies backpressure to further uploads. Palette, Asset, and Tilemap generations must match committed resources. A mismatched packet is drained through `TLAST` and rejected without changing accepted metadata or bank ownership.

Rendering completion holds the current result until pixel-domain presentation and software retirement. The next start is blocked on the renderer's done edge as well as the completion hold. Software reads the completion counters, sequence, status, and cycle count before toggling release; an early release is consumed without releasing a future completion.

The optional `overlap_control_gpio` occupies `0x413C0000` through `0x413CFFFF`. Channel 1 at offset 0 writes the release toggle in bit 0, with all other bits zero. Channel 2 at offset 8 exposes:

| Bits | Meaning |
| --- | --- |
| 0-2 | Upload credit, READY, FILLING |
| 3-4 | Completion hold, current frame presented |
| 5 | Consumed release toggle |
| 6 | Resource upload idle |
| 7 | Sticky generation rejection |
| 31:8 | Zero |

Create the P4 session with `expected_build_id=0xC0060760`; the legacy default remains `0xC0060700`. The matching driver verifies BUILD_ID, HWH GPIO presence, and the sibling manifest's overlap flag before enabling the protocol. `enqueue_scene`, `wait_scene`, and `drain` bound software ownership to two tickets; the third enqueue retires the oldest before DMA. `submit_scene` remains synchronous. Shell mode changes and resource uploads drain outstanding tickets; resource upload then waits for the resource-idle fence and committed generation. Per-frame VIDEO asset updates remain serial. Runtime presentation statistics advance only when a ticket retires. Timeout or DMA errors poison the sink; cleanup retains buffers and their owner while DMA or worker threads remain active.

## 4. Pixel representation

Framebuffer tokens use:

| Bits | Meaning |
| --- | --- |
| 7:4 | Palette bank |
| 3:0 | Color index |

Source color index 0 is transparent and therefore does not write a token. `CLEAR` writes token `0x00`; palette bank 0, entry 0 is replaced by the current scene background color. This reproduces the existing renderer's arbitrary RGB background while keeping transparency independent of framebuffer contents.

Palette bank 15 is reserved by V1 for generic UI colors and font glyphs. Games may provide up to 15 asset palette banks.

## 5. Clock domains and memory ownership

| Domain | Clock | Responsibilities |
| --- | --- | --- |
| AXI/render | 100 MHz PS7 FCLK0 | Registers, command fetch, rasterization, counters |
| Pixel | 74.25 MHz Clocking Wizard | Timing, framebuffer read, palette lookup, RGB output |

Each physical framebuffer is a true dual-port, dual-clock BRAM array. The render port writes only the inactive bank. The pixel port reads only the active bank. Ownership changes after rendering has completed and only at vertical blank.

Asynchronous reset may assert globally. Deassertion is synchronized separately in each domain. Control crossings use `xpm_cdc_handshake`; counters exposed to AXI use coherent snapshots rather than independently synchronized multi-bit buses.

## 6. Rendering pipeline

The command processor is divided into registered stages:

1. Fetch one 32-byte command from command BRAM.
2. Decode opcode and validate identifiers and dimensions.
3. Clip destination coordinates and initialize iterators.
4. Read tile descriptor or 4-bit atlas source.
5. Apply flip and transparency semantics.
6. Generate the 8-bit palette token and framebuffer address.
7. Write the inactive framebuffer and advance the iterator.

After pipeline fill, `CLEAR`, `FILL_RECT`, and `BLIT_INDEX4` target one candidate pixel per cycle. `DRAW_TILE_LAYER` scans the 320x180 logical viewport once per layer and derives tile coordinates with shifts and masks. Row bases accumulate by 320 to avoid a combinational multiplier.

## 7. Scanout pipeline

The pixel pipeline is fixed-latency:

1. Generate 720p timing and logical coordinates `x >> 2`, `y >> 2`.
2. Read the active framebuffer token.
3. Read RGB888 from the active palette.
4. Register RGB and timing outputs.

`de`, `hsync`, `vsync`, frame-start, and line-start travel through the same number of registers as framebuffer and palette data. A simulation assertion checks that the active framebuffer bank remains constant throughout active video.

## 8. Frame budget

At 100 MHz, one 60 Hz frame provides approximately 1,666,667 cycles. V1 rejects or aborts a render after 1,200,000 cycles and continues displaying the previous frame.

The frozen C1 replay currently measures:

| Measurement | Result |
| --- | ---: |
| Ticks compiled | 330 |
| Maximum commands | 35 |
| Maximum predicted cycles | 122,305 |
| Predicted render time at 100 MHz | 1.22305 ms |

Prediction includes one logical-frame pass for `CLEAR`, one for each Tile layer, each Sprite/rectangle candidate area, and command overhead. Hardware maintains independent actual-cycle counters.

### C4T PS-PL transport proof

The independent C4T Overlay validates the transport layer without changing C3:

| Item | Measured result |
| --- | ---: |
| Path | PS DDR -> 64-bit HP0 -> AXI DMA MM2S -> PL |
| Clock | 100 MHz |
| Integrity cases | 64 B, 4 KiB, 64 KiB, 1 MiB |
| 1 MiB throughput, 100 runs | P50 341.732 MB/s, P99 344.166 MB/s |
| Independent Overlay reloads | 10/10 PASS |
| Post-route timing | WNS 1.895 ns, WHS 0.068 ns |

The two-cycle CRC sink accepts one 64-bit beat every two clocks, giving a 400 MB/s local ceiling. The measured 1 MiB median rate reaches about 85% of that ceiling while preserving CRC-32 and byte-count agreement.

## 9. Initial BRAM budget

| Storage | Approximate RAMB36 |
| --- | ---: |
| Two 320x180x8 framebuffers | 25 |
| 64 KiB packed atlas | 15 |
| 16 KiB tilemap | 4 |
| Two 4 KiB command banks | 2 |
| Palette banks and metadata | 1 |
| Total | 47 of 140 |

Implementation gates for the complete GPU core are 8k LUT, 12k FF, 55 RAMB36, and 8 DSP. Final acceptance uses post-route reports rather than estimates.

## 10. Failure behavior

Header/version mismatch, command overflow, invalid asset generation, invalid palette bank, source bounds failure, malformed tile descriptor, or watchdog expiry invalidates the pending framebuffer. The active frame remains unchanged. The first failing command, sticky error flags, error count, render-cycle maximum, dropped-frame count, and deadline-miss count remain readable through AXI-Lite.

## 11. Verification order

1. Python command renderer equals the existing RGB golden renderer.
2. Each RTL primitive matches Python vectors independently.
3. Framebuffer tokens and expanded RGB match fixed and randomized frames.
4. Bank ownership and vertical-blank exchange pass CDC assertions.
5. C3 proves 720p timing and scanout before C4 adds rasterization.
6. C4 passes post-route timing, DRC, clock-interaction, resource, replay, and long-duration board tests.