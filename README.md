# windows-bootstrap

Run this command in an admin Powershell to run the script, no cloning required.

`Set-ExecutionPolicy Bypass; Invoke-WebRequest -Uri https://raw.githubusercontent.com/soda3x/windows-bootstrap/main/bootstrap.ps1 -OutFile .\bootstrap.ps1; Invoke-Expression .\bootstrap.ps1`

This script is built with Windows 11 in mind, as such, things like winget are utilised and are not installed as part of the script as it's assumed these dependencies are already there.
