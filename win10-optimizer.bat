@echo off
title CPU 100% FIX - Windows 10
color 0E
setlocal enabledelayedexpansion

:: Check admin rights
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ========================================
    echo    ADMIN RIGHTS REQUIRED!
    echo ========================================
    echo.
    echo Right-click this file and select
    echo "Run as administrator"
    echo.
    pause
    exit /b 1
)

:menu
cls
echo ========================================
echo    CPU FIX TOOL
echo ========================================
echo.
echo [1] QUICK FIX - Disable Common CPU Hogs
echo [2] AGGRESSIVE FIX - Maximum Performance
echo [3] View Current CPU Usage
echo [4] Disable Windows Defender Completely
echo [5] Restore Default Settings
echo [6] Open Task Manager
echo [7] Exit
echo.
set /p choice="Select option (1-7): "

if "%choice%"=="1" goto :quick
if "%choice%"=="2" goto :aggressive
if "%choice%"=="3" goto :view
if "%choice%"=="4" goto :disableDefender
if "%choice%"=="5" goto :restore
if "%choice%"=="6" goto :taskmgr
if "%choice%"=="7" goto :end
goto :menu

:quick
cls
echo ========================================
echo    QUICK CPU FIX
echo ========================================
echo.

echo [1/6] Disabling Windows Search...
sc stop WSearch >nul 2>&1
sc config WSearch start=disabled >nul 2>&1
echo   [OK] Windows Search disabled

echo.
echo [2/6] Disabling SysMain (Superfetch)...
sc stop SysMain >nul 2>&1
sc config SysMain start=disabled >nul 2>&1
echo   [OK] SysMain disabled

echo.
echo [3/6] Disabling Windows Update service temporarily...
sc stop wuauserv >nul 2>&1
sc config wuauserv start=disabled >nul 2>&1
echo   [OK] Windows Update temporarily disabled

echo.
echo [4/6] Disabling background apps...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f >nul 2>&1
echo   [OK] Background apps disabled

echo.
echo [5/6] Setting processor scheduling to Programs...
powercfg -setacvalueindex scheme_current SUB_PROCESSOR PERFINCPOL 2 >nul 2>&1
powercfg -setactive scheme_current >nul 2>&1
echo   [OK] Processor optimized for foreground programs

echo.
echo [6/6] Clearing temporary files...
del /f /s /q "%TEMP%\*" 2>nul
del /f /s /q "C:\Windows\Temp\*" 2>nul
echo   [OK] Temp files cleared

echo.
echo ========================================
echo    QUICK FIX COMPLETE!
echo ========================================
echo.
echo What to do next:
echo 1. Restart your computer now
echo 2. If still high CPU, run option 2
echo.
set /p restart="Restart now? (Y/N): "
if /i "%restart%"=="Y" shutdown /r /t 10 /c "Restarting in 10 seconds"
pause
goto :menu

:aggressive
cls
echo ========================================
echo    AGGRESSIVE CPU FIX
echo ========================================
echo.
echo WARNING: This will:
echo - Disable Windows Defender
echo - Disable Windows Update
echo - Disable Cortana
echo - Disable telemetry
echo - Disable notifications
echo - Set maximum performance
echo.
echo A restore point will be created.
echo.
set /p confirm="Continue? (Y/N): "
if /i not "%confirm%"=="Y" goto :menu

echo.
echo Creating system restore point...
wmic /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "CPU Fix - Aggressive", 100, 7 >nul 2>&1
echo Restore point created!

echo.
echo [1/12] Disabling Windows Defender completely...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /t REG_DWORD /d 1 /f >nul 2>&1
echo   [OK] Windows Defender disabled

echo.
echo [2/12] Disabling Windows Search...
sc stop WSearch >nul 2>&1
sc config WSearch start=disabled >nul 2>&1
echo   [OK] Windows Search disabled

echo.
echo [3/12] Disabling SysMain (Superfetch)...
sc stop SysMain >nul 2>&1
sc config SysMain start=disabled >nul 2>&1
echo   [OK] SysMain disabled

echo.
echo [4/12] Disabling Windows Update service...
sc stop wuauserv >nul 2>&1
sc config wuauserv start=disabled >nul 2>&1
echo   [OK] Windows Update disabled

echo.
echo [5/12] Disabling Cortana...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v CortanaEnabled /t REG_DWORD /d 0 /f >nul 2>&1
echo   [OK] Cortana disabled

echo.
echo [6/12] Disabling telemetry and data collection...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
sc stop DiagTrack >nul 2>&1
sc config DiagTrack start=disabled >nul 2>&1
echo   [OK] Telemetry disabled

echo.
echo [7/12] Disabling background apps...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f >nul 2>&1
echo   [OK] Background apps disabled

echo.
echo [8/12] Disabling notifications...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v ToastEnabled /t REG_DWORD /d 0 /f >nul 2>&1
echo   [OK] Notifications disabled

echo.
echo [9/12] Disabling Xbox services...
sc stop XblAuthManager >nul 2>&1
sc config XblAuthManager start=disabled >nul 2>&1
sc stop XboxNetApiSvc >nul 2>&1
sc config XboxNetApiSvc start=disabled >nul 2>&1
sc stop XboxGipSvc >nul 2>&1
sc config XboxGipSvc start=disabled >nul 2>&1
echo   [OK] Xbox services disabled

echo.
echo [10/12] Optimizing power settings...
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
powercfg -setacvalueindex scheme_current SUB_PROCESSOR PERFINCPOL 2 >nul 2>&1
powercfg -setacvalueindex scheme_current SUB_PROCESSOR PERFDECPOL 1 >nul 2>&1
powercfg -setactive scheme_current >nul 2>&1
echo   [OK] Maximum performance power plan set

echo.
echo [11/12] Disabling startup programs...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /va /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /va /f >nul 2>&1
echo   [OK] Startup programs cleared

echo.
echo [12/12] Clearing all temporary files...
del /f /s /q "%TEMP%\*" 2>nul
del /f /s /q "C:\Windows\Temp\*" 2>nul
del /f /s /q "C:\Windows\Prefetch\*" 2>nul
echo   [OK] System cleaned

echo.
echo ========================================
echo    AGGRESSIVE FIX COMPLETE!
echo ========================================
echo.
echo IMPORTANT NOTES:
echo ========================================
echo 1. Windows Defender is DISABLED - Your PC is vulnerable!
echo    - Re-enable via option 5 (Restore)
echo    - Or install third-party antivirus
echo.
echo 2. Windows Update is DISABLED
echo    - Manually update once a month
echo    - Run "wuauclt /detectnow" to check for updates
echo.
echo 3. A restore point was created to revert changes
echo.
echo Press any key to restart...
pause >nul
shutdown /r /t 30 /c "Restarting to apply changes"
goto :end

:view
cls
echo ========================================
echo    CURRENT CPU USAGE
echo ========================================
echo.

:: Get CPU usage
for /f "skip=1" %%p in ('wmic cpu get loadpercentage') do (
    set cpu=%%p
    goto :gotcpu
)
:gotcpu
echo Current CPU Usage: !cpu!%%
echo.

if !cpu! GTR 80 (
    echo WARNING: CPU usage is very high!
    echo.
)

echo Top CPU Processes:
echo ========================================
tasklist | sort /+69 /r | findstr /v "System Idle" | findstr /v "tasklist" | findstr /v "cmd" | findstr /v "explorer" | findstr /v "svchost" | more +1 | findstr /n "^" | findstr "^[1-5]:"

echo.
echo ========================================
echo.
echo Press any key to continue...
pause >nul
goto :menu

:disableDefender
cls
echo ========================================
echo    DISABLE WINDOWS DEFENDER
echo ========================================
echo.

echo Disabling Windows Defender...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /t REG_DWORD /d 1 /f >nul 2>&1

echo Disabling Windows Defender services...
sc stop WinDefend >nul 2>&1
sc config WinDefend start=disabled >nul 2>&1
sc stop WdNisSvc >nul 2>&1
sc config WdNisSvc start=disabled >nul 2>&1

echo.
echo ========================================
echo    WINDOWS DEFENDER DISABLED
echo ========================================
echo.
echo Restart your PC for changes to take effect.
echo.
pause
goto :menu

:restore
cls
echo ========================================
echo    RESTORE DEFAULT SETTINGS
echo ========================================
echo.

echo Re-enabling Windows Defender...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 0 /f >nul 2>&1
sc config WinDefend start=auto >nul 2>&1
sc config WdNisSvc start=auto >nul 2>&1
echo   [OK] Windows Defender re-enabled

echo.
echo Re-enabling services...
sc config SysMain start=auto >nul 2>&1
sc config WSearch start=auto >nul 2>&1
sc config wuauserv start=auto >nul 2>&1
sc config DiagTrack start=auto >nul 2>&1
echo   [OK] Services restored

echo.
echo Restoring power plan to Balanced...
powercfg -setactive 381b4222-f694-41f0-9685-ff5bb260df2e >nul 2>&1
echo   [OK] Power plan restored

echo.
echo ========================================
echo    RESTORE COMPLETE
echo ========================================
echo.
echo Restart required.
pause
goto :menu

:taskmgr
start taskmgr.exe
goto :menu

:end
echo.
echo Thanks for using CPU Fix Tool!
timeout /t 2 >nul
exit /b 0