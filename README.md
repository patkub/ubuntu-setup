# ubuntu-setup

## Description

These scripts setup my linux development environment.

### List of Apps

Installs the following applications and configurations.

- DNS
  - [Cloudflare DNS over TLS](https://developers.cloudflare.com/1.1.1.1/setup/linux/#systemd-resolved)
  - [Quad9](https://quad9.net/) DNS
- CLI apps
  - [fastfetch](https://github.com/fastfetch-cli/fastfetch) - neofetch like system information tool
  - [git](https://git-scm.com/) - version control system
  - [htop](https://htop.dev/) - interactive process viewer
  - [podman](https://podman.io/) - container tools
  - [Speedtest](https://www.speedtest.net/apps/cli) - internet speedtest for the command line
- GUI apps
  - [Google Chrome](https://www.google.com/chrome/) - web browser
  - [Kdenlive](https://kdenlive.org/en/) - free and open source video editor
  - [OBS Studio](https://obsproject.com/) - free and open source software for video recording and live streaming
  - [GIMP](https://www.gimp.org/) - GNU Image Manipulation Program
  - [psensor](https://github.com/chinf/psensor) - a graphical sensor monitoring and logging utility
  - [solaar](https://github.com/pwr-Solaar/Solaar) - Logitech device manager
- IDEs
  - [JetBrains](https://www.jetbrains.com/)
  - [Visual Studio Code](https://code.visualstudio.com/)
- SDKs
  - [Go](https://go.dev/)
  - Java: [SDKMan](https://sdkman.io/)
  - Node.JS:
    - [pnpm](https://pnpm.io/) - Node version and package manager
    - [Nx](https://nx.dev/) - Build platform
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
bash <(curl -fsSL https://raw.githubusercontent.com/patkub/ubuntu-setup/refs/heads/noble/ubuntu_install.sh)
```

### Kubuntu

Run the script and select 1 to install.
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/patkub/ubuntu-setup/refs/heads/noble/kubuntu_install.sh)
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
