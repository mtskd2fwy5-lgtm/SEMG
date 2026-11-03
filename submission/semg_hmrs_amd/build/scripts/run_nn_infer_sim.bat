@echo off
setlocal

set "PROJECT_ROOT=%~dp0..\.."
set "VIVADO_ROOT=<amd-tools>\Vivado"
set "RESULT_DIR=%PROJECT_ROOT%\sim\results_nn"

if not exist "%VIVADO_ROOT%\bin\xvlog.bat" (
    echo Vivado simulator not found: %VIVADO_ROOT%\bin\xvlog.bat
    exit /b 1
)

if not exist "%RESULT_DIR%" mkdir "%RESULT_DIR%"
cd /d "%RESULT_DIR%"

call "%VIVADO_ROOT%\bin\xvlog.bat" -work work ^
    "%PROJECT_ROOT%\src\rtl\emg_nn_infer.v" ^
    "%PROJECT_ROOT%\sim\tb_emg_nn_infer.v"
if errorlevel 1 exit /b 1

call "%VIVADO_ROOT%\bin\xelab.bat" tb_emg_nn_infer -s emg_nn_sim -debug typical
if errorlevel 1 exit /b 1

call "%VIVADO_ROOT%\bin\xsim.bat" emg_nn_sim -runall
exit /b %errorlevel%

