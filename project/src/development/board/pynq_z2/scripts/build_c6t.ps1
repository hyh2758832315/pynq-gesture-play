param(
    [string]$Vivado = "D:\Xilinx\Vivado\2026.1\Vivado\bin\vivado.bat"
)

$ErrorActionPreference = "Stop"
if (-not (Test-Path $Vivado)) {
    throw "Vivado executable not found: $Vivado"
}

$preparePs7 = Join-Path $PSScriptRoot "prepare_c0_ps7_config.ps1"
$buildScript = Join-Path $PSScriptRoot "build_c6t.tcl"

& $preparePs7
if ($LASTEXITCODE -ne 0) {
    throw "PS7 configuration preparation failed with exit code $LASTEXITCODE"
}
& $Vivado -mode batch -source $buildScript -notrace
exit $LASTEXITCODE