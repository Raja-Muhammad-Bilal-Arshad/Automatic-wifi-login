# Automatic-wifi-login


# Windows Auto WiFi Login Script

## Overview
This script automates the login process for Wi-Fi networks that require authentication, such as university or workplace networks. It detects when you are connected to a specified network and automatically submits your credentials for authentication.

## Prerequisites
- Windows 10 or later
- PowerShell (built-in on Windows)
- Network should be by connected during the whole process

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
- After that You have to open the notepad( where your credidentials are saved ) and remove the commas( " " around the your SSID) :
```powershell
notepad $env:USERPROFILE\wifi-auto-login.conf
```
## Running the Script ( Confirmation for the whole setup )
To automatically log in when connected to the specified Wi-Fi, run:
```powershell
powershell -ExecutionPolicy Bypass -File C:\Scripts\wifi-auto-login.ps1
```
This will check the network, extract the authentication token, and submit your credentials if needed.


## Issue (If anything is missing)
Open the notepad and write your username , password and SSID manually:
```powershell
notepad $env:USERPROFILE\wifi-auto-login.conf
```

## Automating the Script (Must Recommended)
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








## WRITTEN BY:
# BILAL ARSHAD
