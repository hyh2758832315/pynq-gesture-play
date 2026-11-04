# C2 BTN/SW Constraint Source

| Field | Value |
| --- | --- |
| Board | PYNQ-Z2 / XC7Z020CLG400-1 |
| Source repository | `https://github.com/Xilinx/PYNQ` |
| Source commit | `19ed17d4fd4ea71f95a97d30f8ccd0d62b8dbaaa` |
| Source file | `boards/Pynq-Z2/base/vivado/constraints/base.xdc` |
| Source Git blob | `fb77db7aee82cc9ad8614c8b77ba953d7c28a8f4` |
| Source SHA-256 | `05D99C9032CEB21B2F6850955DD897A14A30D77EBDA21D57867DAA65CAEF2D3B` |
| License | BSD-3-Clause, as declared in the source file |

`constraints/c2_buttons_switches.xdc` extracts only the official BTN0-3 and SW0-1 constraints, renaming the official `btns_4bits_tri_i` and `sws_2bits_tri_i` ports to the C2 top-level `btn` and `sw` ports. The extracted pin map is BTN0-3 = `D19/D20/L20/L19`, SW0-1 = `M20/M19`, all `LVCMOS33`.