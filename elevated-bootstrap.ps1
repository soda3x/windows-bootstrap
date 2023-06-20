Clear-Host
Write-Output "Running elevated bootstrap..."
# Turn off UAC
Write-Output "Turning off UAC..."
Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0
Write-Output "Done."

Write-Output "Configuring explorer (show hidden files / folders, protected OS files and file extensions)..."
# Show Hidden Files, Protected OS Files and File Extensions in Explorer
$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
Set-ItemProperty $key Hidden 1
Set-ItemProperty $key HideFileExt 0
Set-ItemProperty $key ShowSuperHidden 1
Stop-Process -processname explorer
Write-Output "Done."

# Enable Hyper-V:
Write-Output "Turning on Hyper-V..."
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All -All -NoRestart
Write-Output "Done."

# Enable WSL:
Write-Output "Turning on WSL..."
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -All -NoRestart
Write-Output "Done."

# Add C:\tools to system path, stand-alone apps will be installed to C:\tools and will need to be on path
Write-Output "Adding C:\tools to the system path..."
$oldpath = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).path
$newpath = "$oldpath;C:\tools"
Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH -Value $newPath
Write-Output "Done."

# Disable bing search results from start-menu search
Write-Output "Disabling Bing search results from the start menu..."
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search -Name BingSearchEnabled -Type DWord -Value 0
Write-Output "Done."

# Change explorer home screen back to This PC
Write-Output "Reverting Explorer Home screen back to 'This PC'..."
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -Type DWord -Value 1
Write-Output "Done."

# Uninstall OneDrive
Write-Output "Uninstalling OneDrive..."
Invoke-Expression "taskkill /f /im OneDrive.exe"
Invoke-Expression "${env:SystemRoot}\system32\OneDriveSetup.exe /uninstall"
# The following will stop it showing up in Explorer
New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT
Remove-Item -Path 'HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}' -Recurse
Remove-Item -Path 'HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}' -Recurse
Write-Output "Done."

# Customise the Taskbar
REG LOAD HKLM\Default C:\Users\Default\NTUSER.DAT

Write-Output "Customising the Taskbar..."
Write-Output "Removing Task View..."
$reg = New-ItemProperty "HKLM:\Default\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Value "0" -PropertyType Dword -Force
try { $reg.Handle.Close() } catch {}

Write-Output "Removing Chat..."
$reg = New-ItemProperty "HKLM:\Default\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarMn" -Value "0" -PropertyType Dword -Force
try { $reg.Handle.Close() } catch {}

Write-Output "Removing Search..."
$RegKey = "HKLM:\Default\Software\Microsoft\Windows\CurrentVersion\Search"
if (-not(Test-Path $RegKey)) {
  $reg = New-Item $RegKey -Force | Out-Null
  try { $reg.Handle.Close() } catch {}
}
$reg = New-ItemProperty $RegKey -Name "SearchboxTaskbarMode"  -Value "0" -PropertyType Dword -Force
try { $reg.Handle.Close() } catch {}

Write-Output "Setting Start Menu to display More Pins..."
$reg = New-ItemProperty "HKLM:\Default\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_Layout" -Value "1" -PropertyType Dword -Force
try { $reg.Handle.Close() } catch {}

REG UNLOAD HKLM\Default

# Debloat Windows
Write-Output "Removing unwanted apps and adverts..."
New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\' -Name 'CloudContent'
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'DisableWindowsConsumerFeatures' -PropertyType DWord -Value '1' -Force

Write-Output "Disabling data collection and telemetry..."
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'SmartScreenEnabled' -PropertyType String -Value 'Off' -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection' -Name 'AllowTelemetry' -PropertyType DWord -Value '0' -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection' -Name 'AllowTelemetry' -PropertyType DWord -Value '0' -Force

Write-Output "Finished running elevated bootstrap script..."
$Shell = New-Object -ComObject "WScript.Shell"
$Button = $Shell.Popup("Finished running elevated bootstrap script, you will need to restart your machine...", 0, "Windows Bootstrap script", 0)
