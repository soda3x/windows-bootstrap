Clear-Host
Write-Output "Running elevated bootstrap..."
# Turn off UAC
Write-Output "Turning off UAC..."
Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0

Write-Output "Configuring explorer (show hidden files / folders, protected OS files and file extensions)..."
# Show Hidden Files, Protected OS Files and File Extensions in Explorer
$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
Set-ItemProperty $key Hidden 1
Set-ItemProperty $key HideFileExt 0
Set-ItemProperty $key ShowSuperHidden 1
Stop-Process -processname explorer

# Enable Hyper-V:
Write-Output "Turning on Hyper-V..."
echo n | Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All -All

# Enable WSL:
Write-Output "Turning on WSL..."
echo n | Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -All

# Add C:\tools to system path, stand-alone apps will be installed to C:\tools and will need to be on path
Write-Output "Adding C:\tools to the system path..."
[System.Environment]::SetEnvironmentVariable('Path','$env:Path;C:\tools',[System.EnvironmentVariableTarget]::Machine)

# Disable bing search results from start-menu search
Write-Output "Disabling Bing search results from the start menu..."
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search -Name BingSearchEnabled -Type DWord -Value 0

# Change explorer home screen back to This PC
Write-Output "Reverting Explorer Home screen back to 'This PC'..."
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -Type DWord -Value 1

Write-Output "Finished running elevated bootstrap script..."
$Shell = New-Object -ComObject "WScript.Shell"
$Button = $Shell.Popup("Finished running elevated bootstrap script, you will need to restart your machine...", 0, "Windows Bootstrap script", 0)