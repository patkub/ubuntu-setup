# ubuntu-setup

## Description

These scripts setup my linux development environment.

### List of Apps

Installs the following applications and configurations.

- [Cloudflare DNS over TLS](https://developers.cloudflare.com/1.1.1.1/setup/linux/#systemd-resolved)
- CLI apps
  - [fastfetch](https://github.com/fastfetch-cli/fastfetch) - neofetch like system information tool.
  - [git](https://git-scm.com/) - version control system
  - [htop](https://htop.dev/) - interactive process viewer
  - podman
  - speedtest
- GUI apps
  - [Google Chrome](https://www.google.com/chrome/) - Web browser
  - [Kdenlive](https://kdenlive.org/en/) - Free and Open Source Video Editor
  - [OBS Studio](https://obsproject.com/) - Free and open source software for video recording and live streaming
  - [psensor](https://github.com/chinf/psensor) - A graphical sensor monitoring and logging utility
  - [solaar](https://github.com/pwr-Solaar/Solaar) - Logitech device manager
- IDEs
  - [JetBrains](https://www.jetbrains.com/)
  - [Visual Studio Code](https://code.visualstudio.com/)
- SDKs
  - [Go](https://go.dev/)
  - Java: [SDKMan](https://sdkman.io/)
  - Node.JS: [nvm](https://github.com/nvm-sh/nvm)
  - Python: [pyenv](https://github.com/pyenv/pyenv), [pipx](https://pipx.pypa.io/stable/)
  - Ruby: [rbenv](https://rbenv.org/)

## Environment

Tested on the following distributions
  - Ubuntu 24.04.2 LTS (Noble Numbat)
  - Kubuntu 24.04.2 LTS (Noble Numbat)

Pick the script corresponding to your distribution.

## Automated Install

Requires curl
```
sudo apt install -y curl
```

### Ubuntu

Run the script and select 1 to install.
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/patkub/ubuntu-setup/refs/heads/main/ubuntu_install.sh)
```

### Kubuntu

Run the script and select 1 to install.
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/patkub/ubuntu-setup/refs/heads/main/kubuntu_install.sh)
```

## Manual Install

Clone the repo and run the script for your distribution.

### Ubuntu

Make the script executable.
```bash
chmod +x ./ubuntu_install.sh
```

Run the script and select 1 to install.
```bash
./ubuntu_install.sh
```

### Kubuntu

Make the script executable
```bash
chmod +x ./kubuntu_install.sh
```

Run the script and select 1 to install.
```bash
./kubuntu_install.sh
```
