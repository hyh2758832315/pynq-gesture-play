# C2 BTN/SW Constraints

Create `c2_buttons_switches.xdc` only after recording the authoritative PYNQ-Z2 Master XDC source URL or commit and its SHA-256 in the C2 bring-up record. The file must constrain `btn[3:0]` and `sw[1:0]` with the matching `PACKAGE_PIN` and `IOSTANDARD` values.

`build_c2.tcl` rejects builds until that file exists.