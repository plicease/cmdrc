# plicease's shell customization for Windows 11+

## Steps:

1. `winget install Git.Git`
2. `git clone git@github.com:plicease/cmdrc.git`
3. `cd cmdrc`
4. `bootstrap.cmd`
5. ... wait a while ...
6. `irm https://get.activated.win | iex`

## KVM:

1. download and install: [spice guest tools](https://www.spice-space.org/download/windows/spice-guest-tools/spice-guest-tools-latest.exe)
2. should immediately be able to change the resolution.

## WSL

powershell as admin

1. `dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart`
2. `wsl --install`
3. reboot
4. `wsl --install Ubuntu`
5. `apt update && apt install openssh-server` (inside linux)
6. `netsh interface portproxy add v4tov4 listenport=22 listenaddress=0.0.0.0 connectport=22 connectaddress=<WSL_IP>`
7. `New-NetFirewallRule -DisplayName "Allow SSH on port 22" -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22`
