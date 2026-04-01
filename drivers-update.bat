@echo off
setlocal EnableDelayedExpansion
title Universal Driver Injector (Path-Hardened)

:: 1. Force Administrative Privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] ERROR: This must be run as Administrator.
    powershell -Command "Start-Process -FilePath '%0' -Verb RunAs" 2>nul || (
        echo [!] Manual Intervention Required: Right-click this file and select 'Run as Administrator'.
        pause
        exit /b
    )
)

:: 2. Locate PowerShell Manually (Since your PATH is broken)
set "PS_PATH=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"
if not exist "!PS_PATH!" (
    echo [ERROR] PowerShell was not found at !PS_PATH!
    echo Your Windows installation might be heavily modified or corrupted.
    pause
    exit /b
)

echo [*] PowerShell found at: !PS_PATH!
echo [*] Initializing hardware recovery...
set "PS_SCRIPT=%temp%\DriverUpdater.ps1"

:: 3. Create the PowerShell Sidecar Script
echo $Searcher = New-Object -ComObject Microsoft.Update.Searcher > "%PS_SCRIPT%"
echo $SearchResult = $Searcher.Search("IsInstalled=0 and Type='Driver' and IsHidden=0") >> "%PS_SCRIPT%"
echo if ($SearchResult.Updates.Count -gt 0) { >> "%PS_SCRIPT%"
echo     Write-Host "[+] Found $($SearchResult.Updates.Count) missing drivers." -Fore Green >> "%PS_SCRIPT%"
echo     $UpdateCollection = New-Object -ComObject Microsoft.Update.UpdateColl >> "%PS_SCRIPT%"
echo     foreach ($Update in $SearchResult.Updates) { >> "%PS_SCRIPT%"
echo         Write-Host "    - Preparing: $($Update.Title)" >> "%PS_SCRIPT%"
echo         $UpdateCollection.Add($Update) ^| Out-Null >> "%PS_SCRIPT%"
echo     } >> "%PS_SCRIPT%"
echo     Write-Host "[*] Downloading and Installing drivers..." -Fore Cyan >> "%PS_SCRIPT%"
echo     $Downloader = New-Object -ComObject Microsoft.Update.Downloader >> "%PS_SCRIPT%"
echo     $Downloader.Updates = $UpdateCollection >> "%PS_SCRIPT%"
echo     $Downloader.Download() ^| Out-Null >> "%PS_SCRIPT%"
echo     $Installer = New-Object -ComObject Microsoft.Update.Installer >> "%PS_SCRIPT%"
echo     $Installer.Updates = $UpdateCollection >> "%PS_SCRIPT%"
echo     $Result = $Installer.Install() >> "%PS_SCRIPT%"
echo     Write-Host "[+] Installation Complete." -Fore Green >> "%PS_SCRIPT%"
echo } else { >> "%PS_SCRIPT%"
echo     Write-Host "[-] No missing drivers found in the Microsoft Catalog." -Fore Yellow >> "%PS_SCRIPT%"
echo } >> "%PS_SCRIPT%"

:: 4. Trigger Hardware Rescan
echo [*] Rescanning hardware bus for Wi-Fi/Bluetooth/Ports...
pnputil /scan-devices
timeout /t 2 >nul

:: 5. Execute the Script using the Absolute Path
echo [*] Querying Microsoft Driver Catalog (This may take a moment)...
"!PS_PATH!" -NoProfile -ExecutionPolicy Bypass -File "%PS_SCRIPT%"

:: 6. Cleanup
if exist "%PS_SCRIPT%" del "%PS_SCRIPT%"

echo.
echo ======================================================
echo  PROCESS FINISHED. 
echo  IMPORTANT: Reboot your PC to initialize new hardware.
echo ======================================================
pause