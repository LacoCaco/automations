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
    @{ Name = "Netflix"; Source = "msstore" },
    @{ Name = "Prime Video for Windows"; Source = "msstore" },
    @{ Name = "Enpass Password Manager"; Source = "msstore" },
    @{ Name = "iCloud"; Source = "msstore" },
    @{ Name = "Thunderbird"; Source = "msstore" },
    @{ Name = "Spotify - Music and Podcasts"; Source = "msstore" },
    @{ Name = "Brave"; Source = "msstore" },
    @{ Name = "XP9KHM4BK9FZ7Q"; Source = "msstore" },
    @{ Name = "9NKSQGP7F2NH"; Source = "msstore" },
    @{ Name = "XPDM1ZW6815MQM"; Source = "msstore" },
    @{ Name = "ShiftCryptoAG.BitBoxApp"; Source = "winget" },
    @{ Name = "LedgerHQ.LedgerLive"; Source = "winget" },
    @{ Name = "Logitech.OptionsPlus"; Source = "winget" },
    @{ Name = "Malwarebytes.Malwarebytes"; Source = "winget" },
    @{ Name = "Notepad++"; Source = "winget" },
    @{ Name = "Proton Mail Bridge"; Source = "winget" }
)

# --- Conditionally Add Gaming Apps ---
if ($Scenario -eq "Gaming") {
    $installTargets += @(
        @{ Name = "Discord"; Source = "msstore" },
        @{ Name = "Logitech.GHUB"; Source = "winget" },
        @{ Name = "Valve.Steam"; Source = "winget" }
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
        Write-Host " - ✅ Already installed: $($pkg.Name)"
    } else {
        Write-Host " - ⬇ Installing: $($pkg.Name)"
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
    Write-Host "✅ All apps are in the desired state."
} else {
    Write-Host "❌ The following apps are missing or failed to install:"
    $missing | ForEach-Object { Write-Host " - $_" }
}
