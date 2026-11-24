#Requires -RunAsAdministrator

$ErrorActionPreference = 'Stop'

$backupResult = Install-WindowsFeature -Name Windows-Server-Backup -IncludeManagementTools
if (-not $backupResult.Success) {
    throw 'Windows Server Backup installation failed.'
}
if ($backupResult.RestartNeeded -eq 'Yes') {
    Write-Warning 'A restart is required to complete the Windows Server Backup installation.'
}

$ieEscKeys = @(
    'HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}'
    'HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}'
)

foreach ($key in $ieEscKeys) {
    Set-ItemProperty -Path $key -Name IsInstalled -Value 0
}

New-Item -Path 'C:\Temp' -ItemType Directory -Force | Out-Null
