param([string]$VivadoRoot='D:\vivado2026_complete\2026.1\Vivado',[switch]$Dma)
# PYNQ-Z2 / Vivado2026.1. Output sim/frontend.log; next OOC synth/integration.
$ErrorActionPreference='Stop'
$outputRoot=Join-Path $PSScriptRoot 'sim'
$priorArch=$env:PROCESSOR_ARCHITECTURE
$priorLicense=$env:XILINXD_LICENSE_FILE
New-Item -ItemType Directory -Force -Path $outputRoot | Out-Null
Push-Location $outputRoot
try {
    $env:PROCESSOR_ARCHITECTURE='AMD64'
    $env:XILINXD_LICENSE_FILE='C:\Users\huanghe\Downloads\Vivado_Basic.lic.lic'
    $top=if($Dma){'tb_bgr_skin_dma'}else{'tb_frontend'}
    $pattern=if($Dma){'BGR_SKIN_DMA_PASS'}else{'BGR_HSV_FRONTEND_PASS'}
    & "$VivadoRoot\bin\xvlog.bat" --sv -i "$PSScriptRoot\rtl" -i "$PSScriptRoot\golden" "$PSScriptRoot\rtl\axis_bgr_hsv_skin.sv" "$PSScriptRoot\rtl\axis_mask_pack32.sv" "$PSScriptRoot\rtl\bgr_skin_dma.sv" "$PSScriptRoot\tb\$top.sv"
    if($LASTEXITCODE){throw 'RTL compile failed'}
    & "$VivadoRoot\bin\xelab.bat" $top -s $top
    if($LASTEXITCODE){throw 'Elaboration failed'}
    $result=& "$VivadoRoot\bin\xsim.bat" $top -runall 2>&1
    $result | Set-Content -LiteralPath "$outputRoot\$top.log"
    if($LASTEXITCODE -or -not($result -match $pattern)){throw 'Simulation failed'}
    Write-Output ($result | Select-String $pattern)
} finally {Pop-Location;$env:PROCESSOR_ARCHITECTURE=$priorArch;$env:XILINXD_LICENSE_FILE=$priorLicense}
