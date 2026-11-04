# PYNQ-Z2 J8 serial-console capture. Read-only; does not program the board.
# Run after FTDI USB Serial Port is Present/OK (replace COM7 if Windows changed it):
# powershell.exe -NoProfile -File subprojects/hdmi_input_osd/osd_reset_repair_r01/tools/capture_j8_uart.ps1 -PortName COM7 -DurationSeconds 90 -OutputPath build/hosd/osd-reset-r01/j8-uart-r01.log
# Expected output: timestamped UART text at OutputPath.
# Next: start capture before one controlled OSD STATUS read; compare UART output
# with the fsynced read events and preserve both even if SSH stops responding.
param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern('^COM[0-9]+$')]
    [string]$PortName,

    [ValidateRange(1, 3600)]
    [int]$DurationSeconds = 90,

    [Parameter(Mandatory = $true)]
    [string]$OutputPath
)

$resolvedOutput = [System.IO.Path]::GetFullPath($OutputPath)
if ([System.IO.File]::Exists($resolvedOutput)) {
    throw "Output already exists: $resolvedOutput"
}
$directory = [System.IO.Path]::GetDirectoryName($resolvedOutput)
[System.IO.Directory]::CreateDirectory($directory) | Out-Null

$serial = [System.IO.Ports.SerialPort]::new(
    $PortName, 115200, [System.IO.Ports.Parity]::None, 8,
    [System.IO.Ports.StopBits]::One
)
$serial.ReadTimeout = 250
$serial.WriteTimeout = 250
$writer = $null
try {
    $serial.Open()
    $writer = [System.IO.StreamWriter]::new($resolvedOutput, $false, [System.Text.Encoding]::UTF8)
    $writer.AutoFlush = $true
    $writer.WriteLine("# J8 UART $PortName 115200 8N1; started $([DateTime]::UtcNow.ToString('o'))")
    $deadline = [DateTime]::UtcNow.AddSeconds($DurationSeconds)
    while ([DateTime]::UtcNow -lt $deadline) {
        $chunk = $serial.ReadExisting()
        if ($chunk.Length -gt 0) {
            $writer.Write("`n[$([DateTime]::UtcNow.ToString('o'))] ")
            $writer.Write($chunk)
        } else {
            Start-Sleep -Milliseconds 50
        }
    }
    $writer.WriteLine("`n# ended $([DateTime]::UtcNow.ToString('o'))")
} finally {
    if ($null -ne $writer) { $writer.Dispose() }
    if ($serial.IsOpen) { $serial.Close() }
    $serial.Dispose()
}
Write-Output $resolvedOutput
