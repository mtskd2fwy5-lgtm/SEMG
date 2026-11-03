@echo off
setlocal

set "PROJECT_ROOT=%~dp0..\.."
set "VIVADO_ROOT=<amd-tools>\Vivado"
set "RESULT_DIR=%PROJECT_ROOT%\sim\results"

if not exist "%VIVADO_ROOT%\bin\xvlog.bat" (
    echo Vivado simulator not found: %VIVADO_ROOT%\bin\xvlog.bat
    exit /b 1
)

if not exist "%RESULT_DIR%" mkdir "%RESULT_DIR%"
cd /d "%RESULT_DIR%"

call "%VIVADO_ROOT%\bin\xvlog.bat" -work work ^
    "%PROJECT_ROOT%\src\rtl\ads1299_spi.v" ^
    "%PROJECT_ROOT%\sim\ads1299_model.v" ^
    "%PROJECT_ROOT%\sim\ads1299_functional_tb.v"
if errorlevel 1 exit /b 1

call "%VIVADO_ROOT%\bin\xelab.bat" ads1299_functional_tb -s ads1299_sim -debug typical
if errorlevel 1 exit /b 1

call "%VIVADO_ROOT%\bin\xsim.bat" ads1299_sim -runall -log ads1299_bias.log
if errorlevel 1 exit /b 1
findstr /c:"TEST_PASS ADS1299" ads1299_bias.log >nul
if errorlevel 1 exit /b 1
findstr /i /c:"Fatal:" /c:"ERROR:" ads1299_bias.log >nul
if not errorlevel 1 exit /b 1
exit /b 0

