# ubuntu-setup

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
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/patkub/ubuntu-setup/refs/heads/main/ubuntu_install.sh)
```

### Kubuntu
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
