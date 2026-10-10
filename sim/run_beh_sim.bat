@echo off
rem Behavioral full-chain reference sim. Run from sim\results_gate_beh.
setlocal
set "ROOT=d:\FPGA\sEMG-HMRS"
set "VIVADO_ROOT=D:\FPGA\VIVADO\2025.2\Vivado"

call "%VIVADO_ROOT%\bin\xvlog.bat" -work work ^
    "%ROOT%\src\rtl\emg_pl_export.v" ^
    "%ROOT%\src\rtl\ads1299_spi.v" ^
    "%ROOT%\src\rtl\emg_data_path.v" ^
    "%ROOT%\src\rtl\emg_feature_bank.v" ^
    "%ROOT%\src\rtl\emg_bandpass.v" ^
    "%ROOT%\src\rtl\emg_window_features.v" ^
    "%ROOT%\src\rtl\emg_nn_infer.v" ^
    "%ROOT%\src\rtl\emg_fatigue.v" ^
    "%ROOT%\src\rtl\axis_packet_mux.v" ^
    "%ROOT%\src\rtl\axis_async_fifo.v" ^
    "%ROOT%\sim\emg_pl_export_tb.v"
if errorlevel 1 exit /b 1
call "%VIVADO_ROOT%\bin\xelab.bat" emg_pl_export_tb -s beh_sim -debug typical
if errorlevel 1 exit /b 1
call "%VIVADO_ROOT%\bin\xsim.bat" beh_sim -runall
exit /b %errorlevel%
