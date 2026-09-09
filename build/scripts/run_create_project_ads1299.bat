@echo off
setlocal

set "PROJECT_ROOT=%~dp0..\.."
set "VIVADO_ROOT=D:\FPGA\VIVADO\2025.2\Vivado"

if not exist "%VIVADO_ROOT%\bin\vivado.bat" (
    echo Vivado not found: %VIVADO_ROOT%\bin\vivado.bat
    exit /b 1
)

if not exist "%PROJECT_ROOT%\build\vivado" mkdir "%PROJECT_ROOT%\build\vivado"
cd /d "%PROJECT_ROOT%\build\vivado"
call "%VIVADO_ROOT%\bin\vivado.bat" -mode batch -source "%PROJECT_ROOT%\build\create_project_ads1299.tcl" -log "vivado_ads1299.log" -journal "vivado_ads1299.jou"
exit /b %errorlevel%
