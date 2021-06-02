# Install WSL2
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
wsl --set-default-version 2

# Now you will need to follow steps 4 and 6 here:
# https://docs.microsoft.com/en-us/windows/wsl/install-win10#step-1---enable-the-windows-subsystem-for-linux

# Installing BurntToast for notifications
Install-Module -Name BurntToast

# TODO: git for windows (for the credential mgr)
