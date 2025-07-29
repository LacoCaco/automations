param(
    [ValidateSet("Gaming")]
    [string]$Scenario
)

# --- Appx Packages to Uninstall ---
$appxToRemove = @(
    "*WindowsFeedbackHub*",
    "*GetHelp*",
    "*ZuneMusic*",
    "*Microsoft.MicrosoftOfficeHub*",
    "*BingNews*",
    "*Teams*",
    "*Microsoft.Todos*",
    "*OneDriveSync*",
    "*MicrosoftStickyNotes*",
    "*BingWeather*",
    "*MicrosoftCorporationII.QuickAssist*",
    "*Microsoft.MicrosoftSolitaireCollection*"
)

# --- Winget Packages to Uninstall ---
$wingetToUninstall = @(
    "Microsoft.OneDrive"
)

# --- Install Targets ---
$installTargets = @(
    @{ Name = "Netflix"; Source = "msstore" ; DisplayName = "Netflix" },
    @{ Name = "Prime Video for Windows"; Source = "msstore" ; DisplayName = "Amazon Prime Video" },
    @{ Name = "Enpass Password Manager"; Source = "msstore" ; DisplayName = "Enpass" },
    @{ Name = "iCloud"; Source = "msstore" ; DisplayName = "iCloud" },
    @{ Name = "9PM5VM1S3VMQ"; Source = "msstore" ; DisplayName = "Thunderbird" },
    @{ Name = "Spotify - Music and Podcasts"; Source = "msstore" ; DisplayName = "Spotify" },
    @{ Name = "Brave"; Source = "msstore" ; DisplayName = "Brave" },
    @{ Name = "XP9KHM4BK9FZ7Q"; Source = "msstore" ; DisplayName = "MS VS Code" },
    @{ Name = "9NKSQGP7F2NH"; Source = "msstore" ; DisplayName = "WhatsApp" }, 
    @{ Name = "XPDM1ZW6815MQM"; Source = "msstore" ; DisplayName = "VLC" }, 
    @{ Name = "ShiftCryptoAG.BitBoxApp"; Source = "winget" ; DisplayName = "BitBoxApp" },
    @{ Name = "LedgerHQ.LedgerLive"; Source = "winget" ; DisplayName = "LedgerLive" },
    @{ Name = "Logitech.OptionsPlus"; Source = "winget" ; DisplayName = "Logitech Options+" },
    @{ Name = "Malwarebytes.Malwarebytes"; Source = "winget" ; DisplayName = "Malwarebytes" },
    @{ Name = "Notepad++"; Source = "winget" ; DisplayName = "Notepad++" },
    @{ Name = "Proton Mail Bridge"; Source = "winget" ; DisplayName = "Proton Mail Bridge" }
)

# --- Conditionally Add Gaming Apps ---
if ($Scenario -eq "Gaming") {
    $installTargets += @(
        @{ Name = "Discord"; Source = "msstore" ; DisplayName = "Discord" },
        @{ Name = "Logitech.GHUB"; Source = "winget" ; DisplayName = "Logitech GHUB" },
        @{ Name = "Valve.Steam"; Source = "winget" ; DisplayName = "Steam" }
    )
}

# --- Remove Appx Packages ---
Write-Host "`n🧹 Removing Appx Packages..."
foreach ($app in $appxToRemove) {
    if (Get-AppxPackage -Name $app) {
        Write-Host " - Uninstalling Appx: $app"
        Get-AppxPackage -Name $app | Remove-AppxPackage
    } else {
        Write-Host " - ✅ Already removed: $app"
    }
}

# --- Uninstall Winget Packages ---
Write-Host "`n🧹 Uninstalling Winget Packages..."
foreach ($app in $wingetToUninstall) {
    if (winget list --name $app | Select-String -SimpleMatch $app) {
        Write-Host " - Uninstalling: $app"
        winget uninstall "$app" --accept-source-agreements | Out-Null
    } else {
        Write-Host " - ✅ Already uninstalled: $app"
    }
}

# --- Install Packages With Pre-check ---
Write-Host "`n📦 Installing Packages..."
foreach ($pkg in $installTargets) {
    if (winget list $pkg.Name | Select-String -SimpleMatch $pkg.Name) {
        Write-Host " - ✅ Already installed: $($pkg.DisplayName)"
    } else {
        Write-Host " - ⬇ Installing: $($pkg.DisplayName)"
        winget install "$($pkg.Name)" --source $($pkg.Source) --accept-source-agreements --accept-package-agreements | Out-Null

    }
}

# --- Final Validation ---
Write-Host "`n🔍 Validating Final State..."
$missing = @()

foreach ($pkg in $installTargets) {
    if (-not (winget list $pkg.Name | Select-String -SimpleMatch $pkg.Name)) {
        $missing += $pkg.Name
    }
}

if ($missing.Count -eq 0) {
    Write-Host "✅ All apps are in the desired state." -ForegroundColor White -BackgroundColor DarkGreen
} else {
    Write-Host "❌ The following apps are missing or failed to install:" -ForegroundColor White -BackgroundColor Red
    $missing | ForEach-Object { Write-Host " - $_" }
}
