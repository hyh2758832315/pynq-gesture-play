param(
    [switch]$Force
)

$ErrorActionPreference = "Stop"

$pynqCommit = "19ed17d4fd4ea71f95a97d30f8ccd0d62b8dbaaa"
$sourceBase = "https://raw.githubusercontent.com/Xilinx/PYNQ/$pynqCommit/boards/ip/rgb2dvi_v1_2"
$interfaceSourceBase = "https://raw.githubusercontent.com/Xilinx/PYNQ/$pynqCommit/boards/ip/if/tmds_v1_0"
$outputDir = Join-Path $PSScriptRoot "..\generated\rgb2dvi_v1_2"
$expectedFiles = [ordered]@{
    "component.xml" = "1AF6FD9C43AB6D824A7A2DAFF30B2CD12224AFAE7C8FA1A4982E0C1206E2CB22"
    "src/ClockGen.vhd" = "A3AC3A940D9455B342D5217B008502EBEEF2DA35A2B27A4074EB9AB3C58E6B1B"
    "src/DVI_Constants.vhd" = "D8DBBBC3C8696D4527EE0D3C4757F1A40D0ACEBC845899483BC61C2BB8270CDE"
    "src/OutputSERDES.vhd" = "6205D58405919D4F899A525256E2CAFA725408F6644642755CD0DE63E69B286E"
    "src/SyncAsync.vhd" = "5561AC8099ED13F3114E97387AAB5F7F30AD28A8BE2FC540004CBEE3F19EB3A7"
    "src/SyncAsyncReset.vhd" = "3CE7ADE3267959DA59B4D448CC6641018E4F0AC3DE9F8F998D0B9FF84A3794BC"
    "src/TMDS_Encoder.vhd" = "B047A257C1172412D1B354A98E3CC77D013D0F3C1AF6FF646233ABF8B669C196"
    "src/rgb2dvi.vhd" = "7268A67D557E36200847D494536733026DC7E2CA0980B6D2138FE9BAC735F0CC"
    "src/rgb2dvi.xdc" = "51B9AC7F1229A2250CDDB1D490E45E536DD836EB5C42851F67359C7A5AEF6130"
    "src/rgb2dvi_clocks.xdc" = "D39D2F58A6CF74C30EEF3C4B7D37C436359EA3FCFAFF3DDCC0A1A69388B73AC8"
    "src/rgb2dvi_ooc.xdc" = "77F9820235B2C3CE1E99D369DB4932A76705633EEB5F950908855183931DC1A2"
    "xgui/rgb2dvi_v1_1.tcl" = "44D93693F4A4EAC11A86D7FF2BE4DC03E2BAB44A407C342BD3DD8F1477C55F92"
    "xgui/rgb2dvi_v1_2.tcl" = "B5C7922F8CE09CA0022ACD406397EC1D1E602914851EA33E38934612344210B2"
    "docs/rgb2dvi_v1_2.pdf" = "63325751909F90A731069D81968A2CDF158468FF5019D08D7396C865954F4C39"
    "tmds_v1_0/tmds.xml" = "C6A3CBCFA3DE47CA91A2FBE49DE15F1F61C7196039F14381D1598A26233BE489"
    "tmds_v1_0/tmds_rtl.xml" = "F79979C9844723343C83A80CC6BB9D1E49BDEB0796729517F5E339965E70D2C1"
}

function Test-Rgb2DviPackage {
    param([string]$Root)

    foreach ($entry in $expectedFiles.GetEnumerator()) {
        $path = Join-Path $Root $entry.Key
        if (-not (Test-Path $path)) {
            return $false
        }
        if ((Get-FileHash -Algorithm SHA256 $path).Hash -ne $entry.Value) {
            return $false
        }
    }
    return $true
}

if ((Test-Path $outputDir) -and -not $Force -and (Test-Rgb2DviPackage $outputDir)) {
    Write-Host "C3_RGB2DVI=$outputDir"
    Write-Host "C3_RGB2DVI_STATUS=EXISTS_VERIFIED"
    return
}

$temporaryDir = Join-Path $env:TEMP ("pynq_rgb2dvi_" + [guid]::NewGuid().ToString("N"))
try {
    foreach ($entry in $expectedFiles.GetEnumerator()) {
        $target = Join-Path $temporaryDir $entry.Key
        New-Item -ItemType Directory -Force (Split-Path $target) | Out-Null
        if ($entry.Key.StartsWith("tmds_v1_0/")) {
            $sourceName = $entry.Key.Substring("tmds_v1_0/".Length)
            $sourceUrl = "$interfaceSourceBase/$sourceName"
        } else {
            $sourceUrl = "$sourceBase/$($entry.Key)"
        }
        Invoke-WebRequest -UseBasicParsing -Uri $sourceUrl -OutFile $target
        $actualHash = (Get-FileHash -Algorithm SHA256 $target).Hash
        if ($actualHash -ne $entry.Value) {
            throw "rgb2dvi SHA-256 mismatch for $($entry.Key): expected $($entry.Value), got $actualHash"
        }
    }

    Remove-Item -Recurse -Force $outputDir -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Force (Split-Path $outputDir) | Out-Null
    Move-Item $temporaryDir $outputDir
} finally {
    Remove-Item -Recurse -Force $temporaryDir -ErrorAction SilentlyContinue
}

Write-Host "C3_RGB2DVI=$outputDir"
Write-Host "C3_RGB2DVI_STATUS=GENERATED_VERIFIED"
Write-Host "C3_RGB2DVI_SOURCE_COMMIT=$pynqCommit"