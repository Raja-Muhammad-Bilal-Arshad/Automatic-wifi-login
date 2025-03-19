# Windows Auto WiFi Login Script (Cleaned & Stable)

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
    Write-Host "Starting Auto-Login..."

    if (!(Test-Path $configPath)) {
        Write-Host "Configuration not found! Run the setup first."
        exit 1
    }

    # Load config
    $config = @{ }
    Get-Content $configPath | ForEach-Object {
        if ($_ -match "^(.*?)=(.*)$") {
            $config[$matches[1].Trim()] = $matches[2].Trim()
        }
    }

    # Get SSID list from config
    $ssidList = $config["SSID_LIST"].Split(",")
    Write-Host "SSID list from config: $ssidList"

    # Get current connected SSID (cleaned)
    $currentSSID = (netsh wlan show interfaces | Select-String "SSID\s+:\s+" | Select-Object -First 1).ToString()
    $currentSSID = $currentSSID -replace '^\s*SSID\s+:\s+', ''
    $currentSSID = $currentSSID.Trim()

    Write-Host "Current connected SSID: $currentSSID"

    # Check if current SSID is in the list
    if ($ssidList -contains $currentSSID) {
        Write-Host "Connected to $currentSSID. Checking login..."

        # Test connection (trigger redirect if unauthenticated)
        $loginPage = Invoke-WebRequest -Uri "http://www.google.com" -UseBasicParsing -ErrorAction SilentlyContinue
        if ($loginPage -eq $null) {
            Write-Host "Unable to reach Google. Are you connected to the internet?"
            return
        }

        if ($loginPage.Content -match 'fgtauth\?([0-9a-f]+)') {
            $token = $matches[1]
            Write-Host "Found login token: $token"

            # Request the auth page with token
            $loginResponse = Invoke-WebRequest -Uri "http://10.54.0.1:1000/fgtauth?$token" -UseBasicParsing
            if ($loginResponse.Content -match 'name="magic" value="([^\"]+)"') {
                $magic = $matches[1]
                Write-Host "Found magic token: $magic"

                $postData = [System.Web.HttpUtility]::ParseQueryString("")
                $postData.Add("username", $config["USERNAME"])
                $postData.Add("password", $config["PASSWORD"])
                $postData.Add("magic", $magic)
                $postData.Add("4Tredir", "http://www.google.com/")

                Invoke-WebRequest -Uri "http://10.54.0.1:1000/" -Method Post -Body $postData.ToString() -ContentType "application/x-www-form-urlencoded"

                Write-Host "Auto-login successful!"
            }
            else {
                Write-Host "Magic token not found on auth page."
            }
        }
        else {
            Write-Host "No login portal detected. You may already be logged in!"
        }
    }
    else {
        Write-Host "Not connected to a configured SSID."
    }
}

# Main execution
if ($args.Count -gt 0 -and $args[0] -eq "setup") {
    Setup-Credentials
}
else {
    Auto-Login
}