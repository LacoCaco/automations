param(
    [ValidateSet("Gaming")]
    [string]$Scenario
)

# Define app operations with action: Install or Uninstall
$apps = @(
    # UNINSTALLATION
    @{ Name = "*WindowsFeedbackHub*"; Action = "uninstall"; Type = "Appx" },
    @{ Name = "*GetHelp*"; Action = "uninstall"; Type = "Appx" },
    @{ Name = "*ZuneMusic*"; Action = "uninstall"; Type = "Appx" },
    @{ Name = "*Microsoft.MicrosoftOfficeHub*"; Action = "uninstall"; Type = "Appx" },
    @{ Name = "*BingNews*"; Action = "uninstall"; Type = "Appx" },
    @{ Name = "*Teams*"; Action = "uninstall"; Type = "Appx" },
    @{ Name = "*Microsoft.Todos*"; Action = "uninstall"; Type = "Appx" },
    @{ Name = "*OneDriveSync*"; Action = "uninstall"; Type = "Appx" },
    @{ Name = "Microsoft.OneDrive"; Action = "uninstall"; Type = "Winget" },
    @{ Name = "*MicrosoftStickyNotes*"; Action = "uninstall"; Type = "Appx" },
    @{ Name = "*BingWeather*"; Action = "uninstall"; Type = "Appx" },
    @{ Name = "*MicrosoftCorporationII.QuickAssist*"; Action = "uninstall"; Type = "Appx" },
    @{ Name = "*Microsoft.MicrosoftSolitaireCollection*"; Action = "uninstall"; Type = "Appx" },
    # INSTALLATION
    @{ Name = "9WZDNCRFJ3TJ"; Action = "install"; Type = "Winget" }, # Netflix
    @{ Name = "Prime Video for Windows"; Action = "install"; Type = "Winget" },
    @{ Name = "Enpass Password Manager"; Action = "install"; Type = "Winget" },
    @{ Name = "iCloud "; Action = "install"; Type = "Winget" },
    @{ Name = "Mozilla Thunderbird"; Action = "install"; Type = "Winget" },
    @{ Name = "SpotifyAB.SpotifyMusic"; Action = "install"; Type = "Winget" },
    @{ Name = "Brave"; Action = "install"; Type = "Winget" },
    @{ Name = "Visual Studio Code"; Action = "install"; Type = "Winget" },
    @{ Name = "WhatsApp"; Action = "install"; Type = "Winget" },
    @{ Name = "ShiftCryptoAG.BitBoxApp"; Action = "install"; Type = "Winget" },
    @{ Name = "LedgerHQ.LedgerLive"; Action = "install"; Type = "Winget" },
    @{ Name = "Logitech.OptionsPlus"; Action = "install"; Type = "Winget" },
    @{ Name = "Malwarebytes.Malwarebytes"; Action = "install"; Type = "Winget" },
    @{ Name = "Notepad\+\+.Notepad\+\+"; Action = "install"; Type = "Winget" },
    @{ Name = "Proton Mail Bridge"; Action = "install"; Type = "Winget" },
    @{ Name = "VideoLAN.VLC"; Action = "install"; Type = "Winget" }
)

# Conditional installs for Gaming scenario
if ($Scenario -eq "Gaming") {
    $apps += @(
        @{ Name = "Discord"; Action = "install"; Type = "Winget" },
        @{ Name = "Logitech.GHUB"; Action = "install"; Type = "Winget" },
        @{ Name = "Nvidia.GeForceExperience"; Action = "install"; Type = "Winget" },
        @{ Name = "NZXT.CAM"; Action = "install"; Type = "Winget" },
        @{ Name = "Valve.Steam"; Action = "install"; Type = "Winget" }
    )
}

$failed = @()

# Main operation loop
foreach ($app in $apps) {
    $name = $app.Name
    $action = $app.Action
    $type = $app.Type

    Write-Host "`n▶️ ${action}: ${name}"

    try {
        if ($type -eq "Appx") {
            if ($action -eq "uninstall") {
                $pkg = Get-AppxPackage $name
                if ($pkg) {
                    $pkg | Remove-AppxPackage
                }
                if (Get-AppxPackage $name) {
                    $failed += "$name (Appx uninstall failed)"
                }
            } else {
                throw "Install not supported for Appx packages"
            }
        } elseif ($type -eq "Winget") {
            if ($action -eq "install") {
                winget install "$name" --source msstore --accept-source-agreements --accept-package-agreements --silent *> $null 2>&1
                if (-not (winget list | Select-String "$name")) {
                    $failed += "$name (Winget install failed)"
                }
            } elseif ($action -eq "uninstall") {
                winget uninstall "$name" --accept-source-agreements --silent *> $null 2>&1
                if (winget list | Select-String "$name") {
                    $failed += "$name (Winget uninstall failed)"
                }
            }
        }
    } catch {
        Write-Warning "❗ $name error: $_"
        $failed += "$name (error)"
    }
}

# 🧾 Final report
Write-Host "`n--- 🔍 FINAL STATUS ---"
if ($failed.Count -eq 0) {
    Write-Host "✅ All operations succeeded."
} else {
    Write-Host "❌ Failed operations:"
    $failed | ForEach-Object { Write-Host "- $_" }
}
