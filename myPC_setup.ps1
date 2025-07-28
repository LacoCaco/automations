param(
    [ValidateSet("Gaming")]
    [string]$Scenario
)

# 🧃 Always remove unnecessary apps
Get-AppxPackage *WindowsFeedbackHub* | Remove-AppxPackage
Get-AppxPackage *GetHelp* | Remove-AppxPackage
Get-AppxPackage *ZuneMusic* | Remove-AppxPackage
Get-AppxPackage *Microsoft.MicrosoftOfficeHub* | Remove-AppxPackage
Get-AppxPackage *BingNews* | Remove-AppxPackage
Get-AppxPackage *Teams* | Remove-AppxPackage
Get-AppxPackage *Microsoft.Todos* | Remove-AppxPackage
Get-AppxPackage *OneDriveSync* | Remove-AppxPackage
winget uninstall Microsoft.OneDrive --accept-source-agreements
Get-AppxPackage *MicrosoftStickyNotes* | Remove-AppxPackage
Get-AppxPackage *BingWeather* | Remove-AppxPackage
Get-AppxPackage *MicrosoftCorporationII.QuickAssist* | Remove-AppxPackage
Get-AppxPackage *Microsoft.MicrosoftSolitaireCollection* | Remove-AppxPackage

# 🧃 Always install Basic apps
winget install "*Netflix" --source msstore --accept-source-agreements --accept-package-agreements
winget install "AmazonVideo.PrimeVideo" --source msstore --accept-source-agreements --accept-package-agreements
winget install "SinewSoftwareSystems.EnpassPasswordManager" --source msstore --accept-source-agreements --accept-package-agreements
winget install "AppleInc.iCloud " --source msstore --accept-source-agreements --accept-package-agreements
winget install "MozillaThunderbird.MZLA" --source msstore --accept-source-agreements --accept-package-agreements
winget install "SpotifyAB.SpotifyMusic" --source msstore --accept-source-agreements --accept-package-agreements
winget install --id XP8C9QZMS2PC1T --source msstore --accept-source-agreements --accept-package-agreements	#Brave Browser
winget install --id XP89DCGQ3K6VLD --source msstore --accept-source-agreements --accept-package-agreements	#Powertoys
winget install "Visual Studio Code" --source msstore --accept-source-agreements --accept-package-agreements
winget install "*WhatsAppDesktop" --source msstore --accept-source-agreements --accept-package-agreements
winget install -e --id ShiftCryptoAG.BitBoxApp;
winget install -e --id LedgerHQ.LedgerLive;
winget install -e --id Logitech.OptionsPlus;
winget install -e --id Malwarebytes.Malwarebytes;
winget install -e --id Notepad++.Notepad++;
winget install -e --id ProtonTechnologies.ProtonMailBridge;
winget install -e --id VideoLAN.VLC;

# 🔐 Conditionally install Advanced apps
if ($Scenario -eq "Gaming") {
    winget install "Discord" --source msstore --accept-source-agreements --accept-package-agreements
    winget install -e --id Logitech.GHUB;
    winget install -e --id Nvidia.GeForceExperience;
    winget install -e --id NZXT.CAM;
    winget install -e --id Valve.Steam;
}
