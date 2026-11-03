@echo off
rem Wrapper for build_all.ps1 so the guarded five-gate pipeline can be
rem launched by double-click or from cmd without touching the machine's
rem Restricted PowerShell execution policy. Arguments pass through:
rem   build_all.bat              full build + gates + BOOT.BIN package
rem   build_all.bat -SkipBuild   gates + package on existing artifacts
rem   build_all.bat -SkipBoot    build + gates only, no packaging

setlocal
set SCRIPT_DIR=%~dp0
powershell -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%build_all.ps1" %*
exit /b %ERRORLEVEL%

