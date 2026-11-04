# PYNQ-Z2 / Vivado 2026.1 hand-only OSD pixel simulation.
# Run: pwsh -File subprojects/button_only/sim/run_sim.ps1
# Output: D:/vvg_button_only_sim/xsim.log with BUTTON_OSD_PIXEL_PASS.
# Next: compare RTL result to routed OSD and then verify HDMI on the board.
$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$build = 'D:/vvg_button_only_sim'
if (!(Test-Path -LiteralPath $build)) {
    New-Item -ItemType Directory -Path $build | Out-Null
}
Push-Location $build
try {
    & 'D:/Xilinx/Vivado/2026.1/Vivado/bin/xvlog.bat' -sv -work xil_defaultlib (Join-Path $root 'rtl/input_osd_pixels.sv') (Join-Path $PSScriptRoot 'tb_button_osd.sv')
    if ($LASTEXITCODE -ne 0) { throw 'xvlog failed' }
    & 'D:/Xilinx/Vivado/2026.1/Vivado/bin/xelab.bat' xil_defaultlib.tb_button_osd -s button_osd_tb
    if ($LASTEXITCODE -ne 0) { throw 'xelab failed' }
    & 'D:/Xilinx/Vivado/2026.1/Vivado/bin/xsim.bat' button_osd_tb -runall -log xsim.log
    if ($LASTEXITCODE -ne 0) { throw 'xsim failed' }
    if (!(Select-String -LiteralPath xsim.log -Pattern 'BUTTON_OSD_PIXEL_PASS' -Quiet)) {
        throw 'OSD pixel PASS marker missing'
    }
} finally {
    Pop-Location
}
