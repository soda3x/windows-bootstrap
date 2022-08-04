# Windows 11 Bootstrapping Script

> These scripts are built with Windows 11 in mind. As such, things like winget are utilised and are not installed as part of the script as it's assumed these dependencies are already there.

## Run the Elevated Bootstrap script

The elevated bootstrap script automatically configures some Windows settings and updates the System Path in preparation for the execution of the non-elevated bootstrap script.

1. Run the following command in an elevated Powershell session:

```Set-ExecutionPolicy Bypass; Invoke-WebRequest -Uri https://raw.githubusercontent.com/soda3x/windows-bootstrap/main/elevated-bootstrap.ps1 -OutFile .\elevated-bootstrap.ps1; Invoke-Expression .\elevated-bootstrap.ps1```

2. Update Windows to the latest version and restart, the initial version of Windows 11 (build 22000) does not include winget.exe which is required for the non-elevated bootstrap.

3. Finally, open the Windows Store, navigate to Library and "Get Updates" and wait for updates to complete.

## Run the Bootstrap script

Run the following command in a non-elevated Powershell session:

```Invoke-WebRequest -Uri https://raw.githubusercontent.com/soda3x/windows-bootstrap/main/bootstrap.ps1 -OutFile .\bootstrap.ps1; Invoke-Expression .\bootstrap.ps1```
