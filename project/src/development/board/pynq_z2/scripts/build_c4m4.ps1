param(
    [string]$Vivado = "D:\Xilinx\Vivado\2026.1\Vivado\bin\vivado.bat"
)

$ErrorActionPreference = "Stop"
if (-not (Test-Path $Vivado)) {
    throw "Vivado executable not found: $Vivado"
}

python (Join-Path $PSScriptRoot "..\..\..\sim\scene2d_gpu\generate_c4m4_atlas.py")
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}
& (Join-Path $PSScriptRoot "prepare_c0_ps7_config.ps1")
& $Vivado -mode batch -source (Join-Path $PSScriptRoot "build_c4m4.tcl") -notrace
exit $LASTEXITCODE