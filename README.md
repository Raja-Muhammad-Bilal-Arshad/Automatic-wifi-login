# Automatic-wifi-login
This script solves the recent issue that the students of FAST-NUCES were having difficulty logging in


# Windows Auto WiFi Login Script

## Overview
This script automates the login process for Wi-Fi networks that require authentication, such as university or workplace networks. It detects when you are connected to a specified network and automatically submits your credentials for authentication.

## Prerequisites
- Windows 10 or later
- PowerShell (built-in on Windows)
- Administrative privileges may be required for certain networks

## Installation & Setup

### 1️⃣ Download the Script
Save the `wifi-auto-login.ps1` script to a location on your system, such as `C:\Scripts\wifi-auto-login.ps1`.

### 2️⃣ Allow PowerShell Execution
Before running the script, you need to allow PowerShell scripts to execute. Open PowerShell as Administrator and run:
```powershell
Set-ExecutionPolicy Bypass -Scope CurrentUser -Force
```

### 3️⃣ Run the Setup
Execute the following command to configure the script:
```powershell
powershell -ExecutionPolicy Bypass -File C:\Scripts\wifi-auto-login.ps1 setup
```
- Enter the **Wi-Fi SSID(s)** (network names) when prompted.
- Provide your **username** and **password** for authentication.
- The configuration will be saved securely in `wifi-auto-login.conf`.

## Running the Script
To automatically log in when connected to the specified Wi-Fi, run:
```powershell
powershell -ExecutionPolicy Bypass -File C:\Scripts\wifi-auto-login.ps1
```
This will check the network, extract the authentication token, and submit your credentials if needed.

## Automating the Script (Recommended)
To run the script automatically when connecting to Wi-Fi, follow these steps:

### Task Scheduler Setup
1. Open **Task Scheduler** (`Win + R` → type `taskschd.msc` → Enter)
2. Click **Create Basic Task** on the right panel.
3. Name it **WiFi Auto Login** and click **Next**.
4. Select **When a specific event is logged** and click **Next**.
5. Choose **Application** as the log, **Microsoft-Windows-NetworkProfile/Operational** as the source, and **10000** as the event ID (indicates Wi-Fi connection).
6. Click **Next**, select **Start a Program**, and enter the following in the program/script box:
   ```powershell
   powershell.exe
   ```
   In the **Add arguments** field, enter:
   ```powershell
   -ExecutionPolicy Bypass -File C:\Scripts\wifi-auto-login.ps1
   ```
7. Click **Finish** to save the task.

This will ensure the script runs automatically when your PC connects to the specified Wi-Fi networks.

## Modifying Login Details
To update your **username, password, or Wi-Fi SSIDs**, re-run the setup:
```powershell
powershell -ExecutionPolicy Bypass -File C:\Scripts\wifi-auto-login.ps1 setup
```
Alternatively, you can manually edit the configuration file:
```powershell
notepad $env:USERPROFILE\wifi-auto-login.conf
```

## Troubleshooting
- **Script not running?** Ensure PowerShell execution policy is set to `Bypass`.
- **Not logging in automatically?** Verify the SSID in `wifi-auto-login.conf` matches the exact Wi-Fi name.
- **Portal detection not working?** Some networks use different login URLs; check if `http://10.54.0.1:1000/` is correct.

## Credits
Developed for FAST-NU students to automate Wi-Fi authentication.

---
Enjoy hassle-free Wi-Fi login! 🚀🔥 Let me know if you need any improvements or additional features.
