@echo off
title Driver Update Debugger
echo [DEBUG] Checking for Admin rights...
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] This script MUST be run as Administrator. 
    echo Right-click the file and select "Run as Administrator".
    pause
    exit /b
)

echo [DEBUG] Checking Winget version...
winget --version
if %errorlevel% neq 0 (
    echo [ERROR] Winget not found. 
    echo Install it here: https://github.com/microsoft/winget-cli/releases
    pause
    exit /b
)

echo [DEBUG] Refreshing Winget sources...
winget source update

echo [DEBUG] Listing ALL available upgrades (no filter)...
winget upgrade

echo.
echo [DEBUG] Attempting to update all drivers specifically...
:: We remove the "silent" flags here so you can see the prompts
winget upgrade --all --include-unknown

echo.
echo [DEBUG] Script cycle finished.
pause