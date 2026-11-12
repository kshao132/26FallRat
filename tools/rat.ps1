param([ValidateSet('Build','Flash','List')][string]$Action = 'Build')
$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path $PSScriptRoot -Parent
$cubeExe = Get-ChildItem "$env:USERPROFILE/.vscode/extensions/stmicroelectronics.stm32cube-ide-core-*/resources/binaries/win32/x86_64/cube.exe" | Sort-Object LastWriteTime -Descending | Select-Object -First 1 -ExpandProperty FullName
if (-not $cubeExe) { throw 'Install STM32CubeIDE for Visual Studio Code first.' }
Push-Location $projectRoot
try {
    if ($Action -eq 'List') { & $cubeExe programmer -l usb; exit $LASTEXITCODE }
    & $cubeExe cmake --preset Debug
    if ($LASTEXITCODE -ne 0) { throw 'CMake configure failed.' }
    & $cubeExe cmake --build --preset Debug
    if ($LASTEXITCODE -ne 0) { throw 'Build failed.' }
    if ($Action -eq 'Flash') {
        & $cubeExe programmer -c port=USB1 -w "$projectRoot/build/Debug/26Fall_Rat.elf" -v -g
        if ($LASTEXITCODE -ne 0) { throw 'Flash failed. Connect the board in DFU mode and check the USB driver.' }
    }
} finally { Pop-Location }
