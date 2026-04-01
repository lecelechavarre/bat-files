@echo off
setlocal EnableDelayedExpansion

:: Define Absolute Paths because the System Path is broken
set "SYS32=%SystemRoot%\System32"
set "NET_EXE=%SYS32%\net.exe"
set "SC_EXE=%SYS32%\sc.exe"
set "IP_EXE=%SYS32%\ipconfig.exe"
set "NS_EXE=%SYS32%\netsh.exe"
set "DISM_EXE=%SYS32%\dism.exe"
set "SFC_EXE=%SYS32%\sfc.exe"
set "PWR_EXE=%SYS32%\powercfg.exe"
set "REG_EXE=%SYS32%\reg.exe"

:menu
cls
echo ======================================================
echo    SYSTEM COMMAND CENTER - HARDENED v1.1
echo ======================================================
echo  1. Repair System Files
echo  2. Reset Network Stack
echo  3. Generate Battery Report
echo  4. Clean Temp Files
echo  5. Force Update Scan
echo  6. Fix System Path Errors
echo  7. Exit
echo ======================================================
set /p opt="Select (1-7): "

if "%opt%"=="1" goto repair
if "%opt%"=="2" goto network
if "%opt%"=="3" goto battery
if "%opt%"=="4" goto clean
if "%opt%"=="5" goto update
if "%opt%"=="6" goto fixpath
if "%opt%"=="7" exit
goto menu

:repair
echo [*] Running DISM and SFC...
"%DISM_EXE%" /online /cleanup-image /restorehealth
"%SFC_EXE%" /scannow
pause
goto menu

:network
echo [*] Resetting Network...
"!IP_EXE!" /release
"!IP_EXE!" /renew
"!IP_EXE!" /flushdns
"!NS_EXE!" winsock reset
pause
goto menu

:battery
echo [*] Generating report to Desktop...
"%PWR_EXE%" /batteryreport /output "%userprofile%\Desktop\Battery_Report.html"
start "" "%userprofile%\Desktop\Battery_Report.html"
pause
goto menu

:clean
echo [*] Cleaning Cache...
del /q /f /s "%temp%\*"
"%NET_EXE%" stop wuauserv /y
rd /s /q "%systemroot%\SoftwareDistribution\DataStore"
"%NET_EXE%" start wuauserv
pause
goto menu

:update
echo [*] Poking Update Agent...
C:\Windows\System32\usoclient.exe StartScan
pause
goto menu

:fixpath
echo [*] Forcing System Path Recovery...
"%REG_EXE%" add "HKLM\System\CurrentControlSet\Control\Session Manager\Environment" /v Path /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32;%%SystemRoot%%;%%SystemRoot%%\System32\Wbem;%%SystemRoot%%\System32\WindowsPowerShell\v1.0\" /f
echo [!] Path fixed. You MUST reboot for this to take effect.
pause
goto menu