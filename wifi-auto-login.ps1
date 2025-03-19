# Windows Auto WiFi Login Script
# Converts the Linux Bash script into a Windows PowerShell script

# Configuration file path
$configPath = "$env:USERPROFILE\wifi-auto-login.conf"

# Function to set up credentials
function Setup-Credentials {
    Write-Host "Setting up WiFi Auto-Login..."
    $ssidList = @()
    while ($true) {
        $ssid = Read-Host "Enter the WiFi SSID (or type 'done' to finish)"
        if ($ssid -eq "done") { break }
        $ssidList += $ssid
    }
    
    $username = Read-Host "Enter your username"
    $password = Read-Host "Enter your password" -AsSecureString
    $passwordPlain = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password)
    )
    
    $configContent = @"
USERNAME=$username
PASSWORD=$passwordPlain
SSID_LIST="$(($ssidList -join ","))"
"@
    $configContent | Out-File -Encoding UTF8 -FilePath $configPath
    Write-Host "Configuration saved at $configPath"
}

# Function to check and login if required
function Auto-Login {
    if (!(Test-Path $configPath)) {
        Write-Host "Configuration not found! Run the setup first."
        exit 1
    }
    
    $config = @{ }
    Get-Content $configPath | ForEach-Object {
        if ($_ -match "^(.*?)=(.*)$") {
            $config[$matches[1].Trim()] = $matches[2].Trim()
        }
    }
    
    $ssidList = $config["SSID_LIST"].Split(",")
    $currentSSID = (netsh wlan show interfaces | Select-String "SSID" | ForEach-Object {
        if ($_ -match "SSID\s+:\s+(.+)") { 
            return $matches[1].Trim()
        } else {
            return $null
        }
    }) | Where-Object { $_ }
    
    if ($ssidList -contains $currentSSID) {
        Write-Host "Connected to $currentSSID. Checking login..."
        $loginPage = Invoke-WebRequest -Uri "http://www.google.com" -UseBasicParsing
        if ($loginPage.Content -match 'fgtauth\?([0-9a-f]+)') {
            $token = $matches[1]
            $loginResponse = Invoke-WebRequest -Uri "http://10.54.0.1:1000/fgtauth?$token" -UseBasicParsing
            if ($loginResponse.Content -match 'name="magic" value="([^\"]+)"') {
                $magic = $matches[1]
                $postData = [System.Web.HttpUtility]::ParseQueryString("")
                $postData.Add("username", $config["USERNAME"])
                $postData.Add("password", $config["PASSWORD"])
                $postData.Add("magic", $magic)
                $postData.Add("4Tredir", "http://www.google.com/")
                
                Invoke-WebRequest -Uri "http://10.54.0.1:1000/" -Method Post -Body $postData.ToString() -ContentType "application/x-www-form-urlencoded"
                Write-Host "Auto-login successful!"
            }
        }
    }
}

# Check if script is running in setup mode
if ($args[0] -eq "setup") {
    Setup-Credentials
} else {
    Auto-Login
}
