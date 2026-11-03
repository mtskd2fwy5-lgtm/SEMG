@echo off
setlocal

set "PROJECT_ROOT=%~dp0..\.."
set "VIVADO_ROOT=<amd-tools>\Vivado"
set "RESULT_DIR=%PROJECT_ROOT%\sim\results_fatigue"

if not exist "%VIVADO_ROOT%\bin\xvlog.bat" (
    echo Vivado simulator not found: %VIVADO_ROOT%\bin\xvlog.bat
    exit /b 1
)

if not exist "%RESULT_DIR%" mkdir "%RESULT_DIR%"
python "%PROJECT_ROOT%\tools\gen_fatigue_mem.py"
if errorlevel 1 exit /b 1
cd /d "%RESULT_DIR%"

call "%VIVADO_ROOT%\bin\xvlog.bat" -sv -work work ^
    "%PROJECT_ROOT%\src\rtl\emg_fatigue.v" ^
    "%PROJECT_ROOT%\sim\tb_emg_fatigue.v" ^
    "%PROJECT_ROOT%\sim\tb_emg_fatigue_state.sv"
if errorlevel 1 exit /b 1

call "%VIVADO_ROOT%\bin\xelab.bat" tb_emg_fatigue_state -s fatigue_state_sim -debug typical
if errorlevel 1 exit /b 1
call "%VIVADO_ROOT%\bin\xsim.bat" fatigue_state_sim -runall -log fatigue_state.log
if errorlevel 1 exit /b 1
findstr /c:"TEST_PASS fatigue state" fatigue_state.log >nul
if errorlevel 1 exit /b 1
call "%VIVADO_ROOT%\bin\xelab.bat" tb_emg_fatigue -s emg_fatigue_sim -debug typical
if errorlevel 1 exit /b 1
call "%VIVADO_ROOT%\bin\xsim.bat" emg_fatigue_sim -runall -log fatigue_fft.log
if errorlevel 1 exit /b 1
findstr /c:"TEST_PASS fatigue FFT" fatigue_fft.log >nul
exit /b %errorlevel%

