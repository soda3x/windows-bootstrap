Clear-Host
Write-Output "Running bootstrap script..."
$Shell = New-Object -ComObject "WScript.Shell"
$Button = $Shell.Popup("Please ensure Windows 11 is up to date before continuing.`r`nThis script must NOT be run in an elevated shell.", 0, "Windows Bootstrap script", 0)

#=========Install apps with package managers=========

# Download applist-winget.txt from the bootstrap repository and install winget apps
Write-Output "Downloading Winget App list..."
Invoke-WebRequest -Uri https://raw.githubusercontent.com/soda3x/windows-bootstrap/main/applist-winget.txt -OutFile .\applist-winget.txt
Write-Output "Done."

[string[]] $wingetApps = Get-Content -Path '.\applist-winget.txt'

Write-Output "Installing Winget Apps..."
foreach ($app in $wingetApps) {
    Write-Output "Installing $app..."
    Invoke-Expression "winget install $app --accept-package-agreements"
}
Write-Output "Done."

# Get and Install scoop package manager
Write-Output "Installing Scoop Package Manager..."
Invoke-RestMethod get.scoop.sh | Invoke-Expression

Write-Output "Installing Git..."
Invoke-Expression "scoop install git"

Invoke-Expression "scoop bucket add extras"
Write-Output "Done."

# Download applist-scoop.txt from the bootstrap repository and install scoop apps
Write-Output "Downloading Scoop App list..."
Invoke-WebRequest -Uri https://raw.githubusercontent.com/soda3x/windows-bootstrap/main/applist-scoop.txt -OutFile .\applist-scoop.txt
Write-Output "Done."

[string[]] $scoopApps = Get-Content -Path '.\applist-scoop.txt'

Write-Output "Installing Scoop Apps..."
foreach ($app in $scoopApps) {
    Write-Output "Installing $app..."
    Invoke-Expression "scoop install $app"
}
Write-Output "Done."

#=========Install stand-alone apps that can't be installed via a pkg manager=========

# Install pipx
Write-Output "Installing Pipx..."
Invoke-Expression "python3 -m pip install --user pipx"
Write-Output "Done."

# Use regex to get Python3.X path and keep this script future proof
$python3Path = Get-ChildItem | Where-Object $_.Name -match "{$env:USERPROFILE}\AppData\Roaming\Python\Python3*\Scripts"

Invoke-Expression "cd $python3Path\pipx.exe ensurepath"

# Install pls
Write-Output "Installing pls..."
Invoke-Expression "pipx install pls"
Write-Output "Done."

# Make C:\tools directory
New-Item -Path "c:\" -Name "tools" -ItemType "directory"

# Install portal and place in C:\tools
Write-Output "Installing Portal..."
Invoke-WebRequest -Uri https://github.com/SpatiumPortae/portal/releases/download/v1.0.3/portal_1.0.3_Windows_x86_64.zip -OutFile C:\tools\portal.exe
Write-Output "Done."


# Alias commands in Powershell by creating a profile
# Alias pls to ls
$plsAlias = "Set-Alias -Name ls -Value pls`r`n"
$lazygitAlias = "Set-Alias -Name lg -Value lazygit`r`n"
$pinguAlias = "Set-Alias -Name ping -Value pingu`r`n"
$neovimVimAlias = "Set-Alias -Name vim -Value nvim`r`n"
$neovimViAlias = "Set-Alias -Name vi -Value nvim`r`n"
New-Item -Path $profile -ItemType "file" -Value "$plsAlias $lazygitAlias $pinguAlias $neovimVimAlias $neovimViAlias" -Force

#=========Configure installed apps=========

# Download Neovim configuration and vim-plug
Write-Output "Installing Neovim..."
# Make nvim and autoload directories in Local AppData
New-Item -Path $env:USERPROFILE\AppData\Local -Name "nvim" -ItemType "directory"
New-Item -Path $env:USERPROFILE\AppData\Local\nvim -Name "autoload" -ItemType "directory"
Write-Output "Done."

Write-Output "Configuring Neovim..."
# Download and place nvim config into newly created nvim folder
Invoke-WebRequest -Uri https://raw.githubusercontent.com/soda3x/windows-bootstrap/main/init.vim -OutFile $env:USERPROFILE\AppData\Local\nvim\init.vim

# Download vim-plug
Invoke-WebRequest -Uri https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim  -OutFile $env:USERPROFILE\AppData\Local\nvim\autoload\plug.vim
Write-Output "Done."

# Run post-install commands
Write-Output "Running post install commands..."
Invoke-WebRequest -Uri https://raw.githubusercontent.com/soda3x/windows-bootstrap/main/post-install-commands.txt -OutFile .\post-install-commands.txt

[string[]] $postInstallCmds = Get-Content -Path '.\post-install-commands.txt'

foreach ($cmd in $postInstallCmds) {
    Invoke-Expression "$cmd"
}
Write-Output "Done."

# Finally clean up by removing files created by this script
Write-Output "Cleaning up..."
Remove-Item '.\applist-winget.txt'
Remove-Item '.\applist-scoop.txt'
Remove-Item '.\post-install-commands.txt'
Write-Output "Done."

Write-Output "Finished."
$Shell = New-Object -ComObject "WScript.Shell"
$Button = $Shell.Popup("Bootstrap script finished.", 0, "Windows Bootstrap script", 0)