#!/bin/bash

###
### Definitions
###

PYTHON_VERSION="3.14.5"
RUBY_VERSION="3.4.1"

# SDKMAN versions to install
declare -a SDKMAN_JAVA_VERSIONS=(
    "24.0.2-amzn"
    "21.0.11-amzn"
    "17.0.16-amzn"
)

declare -a SDKMAN_GRADLE_VERSIONS=(
    "8.14.5"
    "7.6.6"
)

# default SDKMAN versions to set
SDKMAN_DEFAULT_JAVA="21.0.11-amzn"
SDKMAN_DEFAULT_GRADLE="7.6.6"

# JetBrains
JETBRAINS_CHANNELS=(
    ["clion"]="2026.1/stable"
    ["datagrip"]="2026.1/stable"
    ["dataspell"]="2026.1/stable"
    ["goland"]="2026.1/stable"
    ["intellij-idea"]="2026.1/stable"
    ["phpstorm"]="2026.1/stable"
    ["pycharm"]="2026.1/stable"
    ["rider"]="2026.1/stable"
    ["rubymine"]="2026.1/stable"
    ["rustrover"]="2026.1/stable"
    ["webstorm"]="2026.1/stable"
)

###
### Start
###

# update sudo timestamp
sudo -v

# get dpkg architecture, i.e. "amd64"
ARCHITECTURE=$(dpkg --print-architecture)

display_menu() {
    PS3='Please enter your choice: '
    options=("Install" "Quit")
    select opt in "${options[@]}"
    do
        case $opt in
            "Install")
                echo "Installing..."
                break
                ;;
            "Quit")
                echo "Exiting..."
                exit 0
                ;;
            *) echo "invalid option $REPLY";;
        esac
    done
}

install_apt_repos() {
    sudo mkdir -p --mode=0755 /usr/share/keyrings

    # Cloudflare
    # cloudflared
    curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | sudo gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-main.gpg
    sudo tee /etc/apt/sources.list.d/cloudflared.sources >/dev/null <<EOF
Types: deb
URIs: https://pkg.cloudflare.com/cloudflared/
Suites: noble
Components: main
Signed-By: /usr/share/keyrings/cloudflare-main.gpg
Architectures: $ARCHITECTURE
EOF

    # cloudflare-warp
    curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg | sudo gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg
    sudo tee /etc/apt/sources.list.d/cloudflare-client.sources >/dev/null <<EOF
Types: deb
URIs: https://pkg.cloudflareclient.com/
Suites: noble
Components: main
Signed-By: /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg
Architectures: $ARCHITECTURE
EOF

    # HashiCorp
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --yes --dearmor --output /usr/share/keyrings/hashicorp-archive-keyring.gpg
    sudo tee /etc/apt/sources.list.d/hashicorp.sources >/dev/null <<EOF
Types: deb
URIs: https://apt.releases.hashicorp.com/
Suites: resolute
Components: main
Signed-By: /usr/share/keyrings/hashicorp-archive-keyring.gpg
EOF

    # Google Chrome
    curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --yes --dearmor --output /usr/share/keyrings/google-chrome.gpg
    sudo tee /etc/apt/sources.list.d/google-chrome-custom.sources >/dev/null <<EOF
Types: deb
URIs: https://dl.google.com/linux/chrome/deb/
Suites: stable
Components: main
Signed-By: /usr/share/keyrings/google-chrome.gpg
Architectures: $ARCHITECTURE
EOF

    # Speedtest CLI
    curl -fsSL https://packagecloud.io/ookla/speedtest-cli/gpgkey | sudo gpg --yes --dearmor --output /usr/share/keyrings/ookla_speedtest-cli-archive-keyring.gpg
    sudo tee /etc/apt/sources.list.d/ookla_speedtest-cli.sources >/dev/null <<EOF
Types: deb
URIs: https://packagecloud.io/ookla/speedtest-cli/ubuntu/
Suites: jammy
Components: main
Signed-By: /usr/share/keyrings/ookla_speedtest-cli-archive-keyring.gpg
EOF
}

install_apt() {
    # add repositories
    
    # Fastfetch
    sudo add-apt-repository -ys ppa:zhangsongcui3371/fastfetch
    # OBS Studio
    sudo add-apt-repository -ys ppa:obsproject/obs-studio
    # Solaar
    sudo add-apt-repository -ys ppa:solaar-unifying/stable

    # update system
    sudo apt update -y
    sudo apt upgrade -y
    sudo apt dist-upgrade -y

    # install curl
    sudo apt install -y curl

    # install apt repositories
    install_apt_repos
    
    # update list of available packages
    sudo apt update -y

    # install build dependencies
    # python dependencies from https://github.com/pyenv/pyenv/wiki#suggested-build-environment
    sudo apt install -y \
        build-essential \
        libbz2-dev \
        libffi-dev \
        liblzma-dev \
        libncursesw5-dev \
        libreadline-dev \
        libsqlite3-dev \
        libssl-dev \
        libyaml-dev \
        libxml2-dev \
        libxmlsec1-dev \
        python3-venv \
        tk-dev \
        xz-utils \
        zlib1g-dev
    
    # install apps
    sudo apt install -y \
        cloudflared \
        cloudflare-warp \
        fastfetch \
        git \
        google-chrome-stable \
        htop \
        obs-studio \
        podman \
        podman-compose \
        psensor \
        pipx \
        smartmontools \
        solaar \
        speedtest \
        terraform
}

install_snaps() {
    # install snap packages
    # Programming
    sudo snap install --classic code
    sudo snap install --classic go

    # JetBrains
    sudo snap install --classic clion --channel="${JETBRAINS_CHANNELS["clion"]}"
    sudo snap install --classic datagrip --channel="${JETBRAINS_CHANNELS["datagrip"]}"
    sudo snap install --classic dataspell --channel="${JETBRAINS_CHANNELS["dataspell"]}"
    sudo snap install --classic goland --channel="${JETBRAINS_CHANNELS["goland"]}"
    sudo snap install --classic intellij-idea --channel="${JETBRAINS_CHANNELS["intellij-idea"]}"
    sudo snap install --classic phpstorm --channel="${JETBRAINS_CHANNELS["phpstorm"]}"
    sudo snap install --classic pycharm --channel="${JETBRAINS_CHANNELS["pycharm"]}"
    sudo snap install --classic rider --channel="${JETBRAINS_CHANNELS["rider"]}"
    sudo snap install --classic rubymine --channel="${JETBRAINS_CHANNELS["rubymine"]}"
    sudo snap install --classic rustrover --channel="${JETBRAINS_CHANNELS["rustrover"]}"
    sudo snap install --classic webstorm --channel="${JETBRAINS_CHANNELS["webstorm"]}"

    # Apps
    sudo snap install gimp
    sudo snap install kdenlive
    sudo snap install mediainfo
    
    # Remove thunderbird
    sudo snap remove --purge thunderbird
}

install_pyenv() {
    # install pyvenv
    if [[ -d ~/.pyenv ]]; then
        echo "pyenv is already installed for current user"
    else
        curl -fsSL https://pyenv.run | bash
    fi

    # add pyvenv to .bashrc
    if grep -q "PYENV_ROOT" ~/.bashrc ; then
        echo "pyenv has already been added to ~/.bashrc"
    else
        echo "Adding pyenv to ~/.bashrc"
        cat <<'EOF' >>~/.bashrc
# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"
eval "$(pyenv virtualenv-init -)"
EOF
    fi
}

load_pyenv() {
    # load pyenv for this script
    export PYENV_ROOT="$HOME/.pyenv"
    [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init - bash)"
    eval "$(pyenv virtualenv-init -)"
}

configure_pipx() {
    # configure pipx
    pipx ensurepath

    # add pipx completions to bashrc
    # shellcheck disable=2016
    if grep -q 'eval "$(register-python-argcomplete pipx)"' ~/.bashrc ; then
        echo "pipx completions have already been added to ~/.bashrc"
    else
        cat <<'EOF' >>~/.bashrc
# pipx
eval "$(register-python-argcomplete pipx)"
EOF
    fi
}

install_python() {
    # install pyenv
    install_pyenv
    # load pyenv for this script
    load_pyenv
    
    # install python
    pyenv install "$PYTHON_VERSION"
    pyenv global "$PYTHON_VERSION"

    # upgrade pip
    pip3 install --upgrade pip

    # configure pipx
    configure_pipx
}

install_rbenv() {
    # install rbenv
    if [[ -d ~/.rbenv ]]; then
        echo "rbenv is already installed for current user"
    else
        git clone https://github.com/rbenv/rbenv.git ~/.rbenv
    fi

    # add rbenv to bashrc
    # shellcheck disable=2088
    if grep -q "~/.rbenv/bin/rbenv" ~/.bashrc ; then
        echo "rbenv has already been added to ~/.bashrc"
    else
        cat <<'EOF' >>~/.bashrc
# rbenv
eval "$(~/.rbenv/bin/rbenv init - --no-rehash bash)"
EOF
    fi
}

load_rbenv() {
    # load rbenv for this script
    eval "$(~/.rbenv/bin/rbenv init - --no-rehash bash)"
}

install_ruby() {
    # install rbenv
    install_rbenv
    
    # load rbenv for this script
    load_rbenv
    
    # install ruby-build
    git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
    
    # install ruby
    rbenv install "$RUBY_VERSION"
    rbenv global "$RUBY_VERSION"
}

install_go() {
    # add go to bashrc
    # shellcheck disable=2016
    if grep -q 'export GOPATH="$HOME/go"' ~/.bashrc ; then
        echo "go has already been added to ~/.bashrc"
    else
        cat <<'EOF' >>~/.bashrc
# go
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"
EOF
    fi
}

install_rust() {
    curl -fsS https://sh.rustup.rs | sh -s -- -y

    # add rust to bashrc
    # shellcheck disable=2016
    if grep -q 'source "$HOME/.cargo/env"' ~/.bashrc ; then
        echo "rust has already been added to ~/.bashrc"
    else
        cat <<'EOF' >>~/.bashrc
# rust
source "$HOME/.cargo/env"
EOF
    fi
}

load_sdkman() {
    # load sdkman for this script
    # shellcheck disable=1091
    source "$HOME/.sdkman/bin/sdkman-init.sh"
}

install_sdkman() {
    # install sdkman
    if [[ -d ~/.sdkman ]]; then
        echo "sdkman is already installed for current user"
        return
    fi

    curl -s "https://get.sdkman.io" | bash
    # make sdkman auto answer
    sed -i -e 's/sdkman_auto_answer=false/sdkman_auto_answer=true/g' ~/.sdkman/etc/config
    # load sdkman for this script
    load_sdkman
    
    # install java versions
    for version in "${SDKMAN_JAVA_VERSIONS[@]}"; do
        sdk install java "$version"
    done
    # install gradle versions
    for version in "${SDKMAN_GRADLE_VERSIONS[@]}"; do
        sdk install gradle "$version"
    done
    
    # set default sdkman versions
    sdk default java "$SDKMAN_DEFAULT_JAVA"
    sdk default gradle "$SDKMAN_DEFAULT_GRADLE"
    
    # reset sdkman auto answer
    sed -i -e 's/sdkman_auto_answer=true/sdkman_auto_answer=false/g' ~/.sdkman/etc/config
}

load_pnpm() {
    # load pnpm for this script
    # pnpm
    export PNPM_HOME="$HOME/.local/share/pnpm"
    case ":$PATH:" in
    *":$PNPM_HOME:"*) ;;
    *) export PATH="$PNPM_HOME:$PATH" ;;
    esac
    # pnpm end
}

install_pnpm() {
    # install pnpm
    if command -v pnpm &> /dev/null; then
        echo "pnpm is already installed"
    else
        curl -fsSL https://get.pnpm.io/install.sh | sh -
    fi

    # load pnpm for this script
    load_pnpm

    # use pnpm to install node lts globally
    pnpm runtime set node lts -g
    # update npm to latest
    pnpm add -g npm

    # install Nx globally
    pnpm add --global nx --allow-build=nx
}

setup_theme() {
    # dark theme
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-purple-dark'
    gsettings set org.gnome.desktop.interface icon-theme 'Yaru-purple'
    gsettings set org.gnome.desktop.sound theme-name 'Yaru'
    
    # desktop background for light and dark mode
    gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/warty-final-ubuntu.png'
    gsettings set org.gnome.desktop.background picture-uri-dark 'file:///usr/share/backgrounds/ubuntu-wallpaper-d.png'
    
    # pinned apps
    gsettings set org.gnome.shell favorite-apps "['google-chrome.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Ptyxis.desktop', 'net.nokyan.Resources.desktop', 'org.remmina.Remmina.desktop']"
    
    # app folders
    gsettings set org.gnome.desktop.app-folders folder-children "['Programming', 'Office', 'SoundVideo', 'Accessories', 'Utilities']"
    gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Programming/ name "Programming"
    gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Programming/ apps "['code_code.desktop', 'intellij-idea_intellij-idea.desktop', 'pycharm_pycharm.desktop', 'clion_clion.desktop', 'datagrip_datagrip.desktop', 'dataspell_dataspell.desktop', 'goland_goland.desktop', 'phpstorm_phpstorm.desktop', 'rider_rider.desktop', 'rubymine_rubymine.desktop', 'rustrover_rustrover.desktop', 'webstorm_webstorm.desktop']"
    gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Office/ name "Office"
    gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Office/ apps "['libreoffice-startcenter.desktop', 'libreoffice-writer.desktop', 'libreoffice-calc.desktop', 'libreoffice-draw.desktop', 'libreoffice-math.desktop', 'libreoffice-impress.desktop']"
    gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/SoundVideo/ name "Sound & Video"
    gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/SoundVideo/ apps "['com.obsproject.Studio.desktop', 'kdenlive_kdenlive.desktop', 'org.gnome.Rhythmbox3.desktop', 'org.gnome.Showtime.desktop', 'org.gnome.Shotwell.desktop', 'gimp_gimp.desktop']"
    gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Accessories/ name "Accessories"
    gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Accessories/ apps "['org.gnome.Calendar.desktop', 'org.gnome.Calculator.desktop', 'org.gnome.eog.desktop', 'org.gnome.TextEditor.desktop', 'org.gnome.clocks.desktop', 'org.gnome.Snapshot.desktop', 'org.gnome.Papers.desktop', 'org.gnome.Loupe.desktop']"
    gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Utilities/ name "Utilities"
    gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Utilities/ apps "['com.cloudflare.WarpTaskbar.desktop', 'firefox_firefox.desktop', 'yelp.desktop', 'snap-store_snap-store.desktop', 'desktop-security-center_desktop-security-center.desktop', 'org.gnome.Settings.desktop', 'transmission-gtk.desktop', 'simple-scan.desktop', 'nm-connection-editor.desktop', 'org.gnome.baobab.desktop', 'org.gnome.DejaDup.desktop', 'org.gnome.DiskUtility.desktop', 'org.gnome.Evince.desktop', 'org.gnome.FileRoller.desktop', 'org.gnome.seahorse.Application.desktop', 'org.gnome.Logs.desktop', 'org.gnome.Characters.desktop', 'org.gnome.font-viewer.desktop', 'gnome-language-selector.desktop', 'update-manager.desktop', 'software-properties-gtk.desktop', 'software-properties-drivers.desktop', 'firmware-updater_firmware-updater.desktop', 'org.gnome.PowerStats.desktop', 'gnome-session-properties.desktop', 'usb-creator-gtk.desktop', 'org.gnome.Sysprof.desktop', 'org.gnome.Yelp.desktop', 'htop.desktop', 'psensor.desktop', 'solaar.desktop']"
    
    # app picker order
    gsettings set org.gnome.shell app-picker-layout "[{'Programming': <{'position': <0>}>, 'Office': <{'position': <1>}>, 'SoundVideo': <{'position': <2>}>, 'Accessories': <{'position': <3>}>, 'Utilities': <{'position': <4>}>}]"
}

setup_all() {
    # install apt packages
    install_apt
    
    # install snaps
    install_snaps

    # sdks
    install_python
    install_ruby
    install_go
    install_rust
    
    # sdkman
    install_sdkman

    # install pnpm
    install_pnpm
    
    # theming
    setup_theme
}

# display menu to install everything
display_menu
setup_all

