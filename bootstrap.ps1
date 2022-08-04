#=========Configure windows settings=========

# # Firstly, turn off UAC. I hate it.
# Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0

# # Show more info for files in Explorer
# Set-WindowsExplorerOptions -EnableShowProtectedOSFiles -EnableShowFileExtensions -EnableShowFullPathInTitleBar -EnableShowHiddenFilesFoldersDrives

# # Configure Windows Hyper-V virtualisation and WSL
# Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All -All
# Enable-WindowsOptionalFeature -Online Microsoft-Windows-Subsystem-Linux -All

# # Disable bing search results from start-menu search
# Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search -Name BingSearchEnabled -Type DWord -Value 0

# # Change explorer home screen back to This PC
# Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -Type DWord -Value 1

#=========Install apps with package managers=========

# Download applist-winget.txt from the bootstrap repository and install winget apps
Invoke-WebRequest -Uri https://raw.githubusercontent.com/soda3x/windows-bootstrap/main/applist-winget.txt -OutFile .\applist-winget.txt

[string[]] $wingetApps = Get-Content -Path '.\applist-winget.txt'

foreach ($app in $wingetApps) {
    Invoke-Expression "winget install $app"
}

# Get and Install scoop package manager
Invoke-RestMethod get.scoop.sh | Invoke-Expression

Invoke-Expression "scoop bucket add extras"

# Download applist-scoop.txt from the bootstrap repository and install scoop apps
Invoke-WebRequest -Uri https://raw.githubusercontent.com/soda3x/windows-bootstrap/main/applist-scoop.txt -OutFile .\applist-scoop.txt

[string[]] $scoopApps = Get-Content -Path '.\applist-scoop.txt'

foreach ($app in $scoopApps) {
    Invoke-Expression "scoop install $app"
}

#=========Install stand-alone apps that can't be installed via a pkg manager=========

# Install pipx
Invoke-Expression "python3 -m pip install --user pipx"

# Use regex to get Python3.X path and keep this script future proof
$python3Path = Get-ChildItem | Where-Object $_.Name -match {"$env:USERPROFILE\AppData\Roaming\Python\Python3*\Scripts"}

Invoke-Expression "cd $python3Path\pipx.exe ensurepath"

# Install pls
Invoke-Expression "pipx install pls"

# Make C:\tools directory
New-Item -Path "c:\" -Name "tools" -ItemType "directory"

# Add C:\tools to system path, stand-alone apps will be installed to C:\tools and will need to be on path
[System.Environment]::SetEnvironmentVariable('Path','$Env:Path;C:\tools',[System.EnvironmentVariableTarget]::Machine)

# Install portal and place in C:\tools
Invoke-WebRequest -Uri https://github.com/SpatiumPortae/portal/releases/download/v1.0.3/portal_1.0.3_Windows_x86_64.zip -OutFile C:\tools\portal.exe


# Alias commands in Powershell by creating a profile
# Alias pls to ls
$plsAlias = "Set-Alias -Name ls -Value pls\r\n"
$lazygitAlias = "Set-Alias -Name lg -Value lazygit\r\n"
$pinguAlias = "Set-Alias -Name ping -Value pingu\r\n"
$neovimVimAlias = "Set-Alias -Name vim -Value nvim\r\n"
$neovimViAlias = "Set-Alias -Name vi -Value nvim\r\n"
New-Item -Path $profile -ItemType "file" -Value "$plsAlias $lazygitAlias $pinguAlias $neovimVimAlias $neovimViAlias" -Force

#=========Configure installed apps=========

# Download Neovim configuration and vim-plug

# Make nvim and autoload directories in Local AppData
New-Item -Path $env:USERPROFILE\AppData\Local -Name "nvim" -ItemType "directory"
New-Item -Path $env:USERPROFILE\AppData\Local\nvim -Name "autoload" -ItemType "directory"

# Download and place nvim config into newly created nvim folder
Invoke-WebRequest -Uri https://raw.githubusercontent.com/soda3x/windows-bootstrap/main/init.vim -OutFile $env:USERPROFILE\AppData\Local\nvim\init.vim

# Download vim-plug
Invoke-WebRequest -Uri https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim  -OutFile $env:USERPROFILE\AppData\Local\nvim\autoload\plug.vim