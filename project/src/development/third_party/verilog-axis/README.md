# verilog-axis vendored files

- Upstream: https://github.com/alexforencich/verilog-axis
- Commit: `48ff7a7e2ef782cf778d47910cf85835c64b1bce`
- License: MIT, retained in `COPYING`
- Vendored file: `rtl/axis_demux.v`
- Local modifications: line endings and trailing whitespace normalized only

The Scene2D packet router uses the upstream frame-locked `select` and `drop`
behavior. Replacement or upgrades require rerunning the standalone packet
router simulation.