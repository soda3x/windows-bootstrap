# Windows 11 Bootstrapping Script

> This script is built with Windows 11 in mind. As such, things like winget are utilised and are not installed as part of the script as it's assumed these dependencies are already there.

To configure Windows settings, run the following commands in an elevated Powershell:

## Windows Configuration (Prerequisite steps)

1. Allow the running of Powershell scripts:

```Set-ExecutionPolicy Bypass```

2. Turn off User Account Control:

```Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0```

3. Show Hidden Files, Protected OS Files and File Extensions in Explorer:

```Set-WindowsExplorerOptions -EnableShowProtectedOSFiles -EnableShowFileExtensions -EnableShowFullPathInTitleBar -EnableShowHiddenFilesFoldersDrives```

4. Enable Hyper-V (requires Restart):

```Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All -All```

5. Enable WSL (requires Restart):

```Enable-WindowsOptionalFeature -Online Microsoft-Windows-Subsystem-Linux -All```

6. Finally update Windows to the latest version and restart, the initial version of Windows 11 (build 22000) does not include winget.exe which is required.

## Run the Bootstrap script

Run the following command in a non-elevated Powershell session:

```Invoke-WebRequest -Uri https://raw.githubusercontent.com/soda3x/windows-bootstrap/main/bootstrap.ps1 -OutFile .\bootstrap.ps1; Invoke-Expression .\bootstrap.ps1```
