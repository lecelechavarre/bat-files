# Batch Files Repository

A comprehensive collection of hardened batch scripts designed to optimize, diagnose, and maintain Windows 10/11 systems. These tools address common performance issues, system maintenance, and driver management challenges.

---

## Scripts Overview

### 1. **win10-optimizer.bat** - CPU Performance Optimizer
Advanced CPU usage optimization tool with multiple intervention levels.

**Features:**
- **Quick Fix Mode**: Disables common CPU-heavy services (Windows Search, SysMain, Background Apps)
- **Aggressive Mode**: Maximum performance configuration with system restore point creation
- **CPU Monitoring**: Real-time CPU usage analysis with top process identification
- **Windows Defender Control**: Toggle Windows Defender on/off as needed
- **Settings Restoration**: Revert all changes back to Windows defaults
- **Task Manager Integration**: Quick access to system processes

**Use Cases:**
- High CPU usage troubleshooting
- System slowdown diagnosis
- Performance optimization before gaming/resource-intensive tasks

**⚠️ Warning:** Aggressive mode disables critical security features. Use only when necessary.

---

### 2. **maintenance.bat** - System Command Center
All-in-one system repair and maintenance utility with hardened path handling.

**Features:**
- **System File Repair**: Automated DISM and SFC scanning/restoration
- **Network Stack Reset**: Complete network configuration refresh
- **Battery Report Generation**: Detailed battery health analysis (exports to Desktop)
- **Temp File Cleanup**: Safe removal of temporary and cache files
- **Update Scan**: Forces Windows Update agent to scan for updates
- **System Path Recovery**: Fixes broken environment variables

**Use Cases:**
- Corrupted system files
- Network connectivity issues
- Battery/power management troubleshooting
- System PATH errors preventing applications from running

---

### 3. **drivers-update.bat** - Universal Driver Injector
Intelligent driver discovery and installation using Microsoft Update Catalog.

**Features:**
- **Automatic Driver Detection**: Scans for missing drivers from Microsoft's official catalog
- **Hardware Bus Rescan**: Triggers PnP device rescanning (Wi-Fi, Bluetooth, USB ports)
- **Batched Installation**: Queues and installs all discovered drivers simultaneously
- **PowerShell Integration**: Leverages Microsoft Update COM objects for reliability
- **Path-Hardened Execution**: Works even when system PATH is corrupted
- **Auto-Cleanup**: Removes temporary scripts after execution

**Use Cases:**
- Fresh Windows installation driver setup
- Missing device drivers after system reset
- Wi-Fi/Bluetooth connectivity issues
- Unknown device identification

**ℹ️ Note:** Requires internet connection and administrative privileges.

---

### 4. **application-driver-updates.bat** - Winget Driver Update Manager
Debug-friendly driver and application update utility using Windows Package Manager.

**Features:**
- **Admin Validation**: Ensures elevated privileges before execution
- **Winget Integration**: Uses official Microsoft package manager
- **Source Refresh**: Updates all package sources before checking updates
- **Transparent Logging**: Shows all available upgrades with detailed prompts
- **Selective Updates**: Option to update all packages or specific drivers
- **Interactive Prompts**: User confirms each update (no silent/forced updates)

**Use Cases:**
- Keeping drivers and applications current
- Safe update verification before deployment
- Troubleshooting driver installation issues
- Application version management

**Prerequisites:**
- Windows Package Manager (Winget) installed
- [Download Winget](https://github.com/microsoft/winget-cli/releases)

---

## Quick Start

### Prerequisites
- **Windows 10/11** (64-bit recommended)
- **Administrator privileges** (required for all scripts)
- **Backup**: Create a system restore point before running aggressive scripts

### Usage

1. **Clone or download** this repository
2. **Right-click** any `.bat` file
3. Select **"Run as administrator"**
4. Follow the on-screen prompts

---

## Comparison Matrix

| Script | Complexity | Risk Level | Reboot Required | Reversible |
|--------|-----------|-----------|-----------------|-----------|
| win10-optimizer.bat | Medium | 🔴 High (Aggressive) | Yes | ✅ Via Restore |
| maintenance.bat | High | 🟡 Medium | Yes | ✅ Partially |
| drivers-update.bat | Medium | 🟢 Low | Yes | ✅ Via Uninstall |
| application-driver-updates.bat | Low | 🟢 Low | Maybe | ✅ Full |

---

## Safety & Security

### What These Scripts Do
- Modify Windows services and registry keys
- Disable security features (when opted)
- Install system drivers from Microsoft Catalog
- Delete temporary files

### What These Scripts DON'T Do
- Install software from untrusted sources
- Modify user data or documents
- Execute malicious code
- Bypass Windows security permanently

### Best Practices
1. **Always create a restore point** before running aggressive optimizations
2. **Test on non-critical systems** first
3. **Review changes** before restarting
4. **Re-enable security features** if disabling temporarily
5. **Keep system backups** for critical machines

---

## Advanced Configuration

### Customizing Scripts
All scripts use standard batch commands and are fully editable:
- Modify service lists in `win10-optimizer.bat`
- Adjust cleanup paths in `maintenance.bat`
- Change driver filtering in `drivers-update.bat`

### System PATH is Broken?
All scripts include **hardened path handling** using absolute System32 paths:
```batch
set "SYS32=%SystemRoot%\System32"
set "SC_EXE=%SYS32%\sc.exe"
