#!/bin/bash

###
### Definitions
###

PYTHON_VERSION="3.13.5"
RUBY_VERSION="3.4.1"

# SDKMAN versions to install
declare -a SDKMAN_JAVA_VERSIONS=(
    "24.0.2-amzn"
    "21.0.8-amzn"
    "17.0.16-amzn"
)

declare -a SDKMAN_GRADLE_VERSIONS=(
    "8.14.3"
    "7.6.6"
)

# default SDKMAN versions to set
SDKMAN_DEFAULT_JAVA="21.0.8-amzn"
SDKMAN_DEFAULT_GRADLE="7.6.6"

# JetBrains
JETBRAINS_CLION_CHANNEL="2024.3/stable"
JETBRAINS_DATAGRIP_CHANNEL="2024.3/stable"
JETBRAINS_DATASPELL_CHANNEL="2024.3/stable"
JETBRAINS_GOLAND_CHANNEL="2024.3/stable"
JETBRAINS_INTELLIJ_IDEA_ULTIMATE_CHANNEL="2024.3/stable"
JETBRAINS_PHPSTORM_CHANNEL="2024.3/stable"
JETBRAINS_PYCHARM_PROFESSIONAL_CHANNEL="2024.3/stable"
JETBRAINS_RIDER_CHANNEL="2024.3/stable"
JETBRAINS_RUBYMINE_CHANNEL="2024.3/stable"
JETBRAINS_WEBSTORM_CHANNEL="2024.3/stable"

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
    echo "deb [arch=$ARCHITECTURE signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/cloudflared.list > /dev/null
    # cloudflare-warp
    curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg | sudo gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg
    echo "deb [arch=$ARCHITECTURE signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/cloudflare-client.list > /dev/null

    # HashiCorp
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --yes --dearmor --output /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [arch=$ARCHITECTURE signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list > /dev/null

    # Google Chrome
    curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --yes --dearmor --output /usr/share/keyrings/google-chrome.gpg
    echo "deb [arch=$ARCHITECTURE signed-by=/usr/share/keyrings/google-chrome.gpg] https://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list > /dev/null

    # Speedtest CLI
    curl -fsSL https://packagecloud.io/ookla/speedtest-cli/gpgkey | sudo gpg --yes --dearmor --output /usr/share/keyrings/ookla_speedtest-cli-archive-keyring.gpg
    echo "deb [arch=$ARCHITECTURE signed-by=/usr/share/keyrings/ookla_speedtest-cli-archive-keyring.gpg] https://packagecloud.io/ookla/speedtest-cli/ubuntu/ jammy main" | sudo tee /etc/apt/sources.list.d/ookla_speedtest-cli.list > /dev/null
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
    sudo snap install --classic intellij-idea-community
    sudo snap install --classic pycharm-community

    # JetBrains
    sudo snap install --classic clion --channel="$JETBRAINS_CLION_CHANNEL"
    sudo snap install --classic datagrip --channel="$JETBRAINS_DATAGRIP_CHANNEL"
    sudo snap install --classic dataspell --channel="$JETBRAINS_DATASPELL_CHANNEL"
    sudo snap install --classic goland --channel="$JETBRAINS_GOLAND_CHANNEL"
    sudo snap install --classic intellij-idea-ultimate --channel="$JETBRAINS_INTELLIJ_IDEA_ULTIMATE_CHANNEL"
    sudo snap install --classic phpstorm --channel="$JETBRAINS_PHPSTORM_CHANNEL"
    sudo snap install --classic pycharm-professional --channel="$JETBRAINS_PYCHARM_PROFESSIONAL_CHANNEL"
    sudo snap install --classic rider --channel="$JETBRAINS_RIDER_CHANNEL"
    sudo snap install --classic rubymine --channel="$JETBRAINS_RUBYMINE_CHANNEL"
    sudo snap install --classic webstorm --channel="$JETBRAINS_WEBSTORM_CHANNEL"

    # Apps
    sudo snap install gimp
    sudo snap install kdenlive
    
    # Remove thunderbird
    sudo snap remove --purge thunderbird
}

install_pyenv() {
    # install pyvenv
    if [ -d ~/.pyenv ]; then
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
    if grep -q "eval \"\$(register-python-argcomplete pipx)\"" ~/.bashrc ; then
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
    if [ -d ~/.rbenv ]; then
        echo "rbenv is already installed for current user"
    else
        git clone https://github.com/rbenv/rbenv.git ~/.rbenv
    fi

    # add rbenv to bashrc
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

load_sdkman() {
    # load sdkman for this script
    source "$HOME/.sdkman/bin/sdkman-init.sh"
}

install_sdkman() {
    # install sdkman
    if [ -d ~/.sdkman ]; then
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
    pnpm env use --global lts
    # update npm to latest
    npm install -g npm

    # install Nx globally
    pnpm add --global nx
}

setup_gsettings() {
    # dark theme
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-purple-dark'
    gsettings set org.gnome.desktop.interface icon-theme 'Yaru-purple'
    gsettings set org.gnome.desktop.sound theme-name 'Yaru'
    
    # desktop background for light and dark mode
    gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/warty-final-ubuntu.png'
    gsettings set org.gnome.desktop.background picture-uri-dark 'file:///usr/share/backgrounds/ubuntu-wallpaper-d.png'
    
    # pinned apps
    gsettings set org.gnome.shell favorite-apps "['google-chrome.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'org.gnome.SystemMonitor.desktop']"
    
    # app folders
    gsettings set org.gnome.desktop.app-folders folder-children "['Programming', 'Office', 'SoundVideo', 'Accessories', 'Utilities']"
    gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Programming/ name "Programming"
    gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Programming/ apps "['code_code.desktop', 'intellij-idea-ultimate_intellij-idea-ultimate.desktop', 'pycharm-professional_pycharm-professional.desktop', 'clion_clion.desktop', 'datagrip_datagrip.desktop', 'dataspell_dataspell.desktop', 'goland_goland.desktop', 'phpstorm_phpstorm.desktop', 'rider_rider.desktop', 'rubymine_rubymine.desktop', 'webstorm_webstorm.desktop', 'intellij-idea-community_intellij-idea-community.desktop', 'pycharm-community_pycharm-community.desktop']"
    gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Office/ name "Office"
    gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Office/ apps "['libreoffice-startcenter.desktop', 'libreoffice-writer.desktop', 'libreoffice-calc.desktop', 'libreoffice-draw.desktop', 'libreoffice-math.desktop', 'libreoffice-impress.desktop']"
    gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/SoundVideo/ name "Sound & Video"
    gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/SoundVideo/ apps "['com.obsproject.Studio.desktop', 'kdenlive_kdenlive.desktop', 'org.gnome.Rhythmbox3.desktop', 'org.gnome.Totem.desktop', 'org.gnome.Shotwell.desktop', 'gimp_gimp.desktop']"
    gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Accessories/ name "Accessories"
    gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Accessories/ apps "['org.gnome.Calendar.desktop', 'org.gnome.Calculator.desktop', 'org.gnome.eog.desktop', 'org.gnome.TextEditor.desktop', 'org.gnome.clocks.desktop', 'org.gnome.Snapshot.desktop']"
    gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Utilities/ name "Utilities"
    gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Utilities/ apps "['com.cloudflare.WarpTaskbar.desktop', 'firefox_firefox.desktop', 'yelp.desktop', 'snap-store_snap-store.desktop', 'org.gnome.Settings.desktop', 'transmission-gtk.desktop', 'org.remmina.Remmina.desktop', 'simple-scan.desktop', 'nm-connection-editor.desktop', 'org.gnome.baobab.desktop', 'org.gnome.DejaDup.desktop', 'org.gnome.DiskUtility.desktop', 'org.gnome.Evince.desktop', 'org.gnome.FileRoller.desktop', 'org.gnome.seahorse.Application.desktop', 'org.gnome.Logs.desktop', 'org.gnome.Characters.desktop', 'org.gnome.font-viewer.desktop', 'gnome-language-selector.desktop', 'update-manager.desktop', 'software-properties-gtk.desktop', 'software-properties-drivers.desktop', 'firmware-updater_firmware-updater.desktop', 'org.gnome.PowerStats.desktop', 'gnome-session-properties.desktop', 'usb-creator-gtk.desktop', 'htop.desktop', 'psensor.desktop', 'solaar.desktop']"
    
    # app picker order
    gsettings set org.gnome.shell app-picker-layout "[{'Programming': <{'position': <0>}>, 'Office': <{'position': <1>}>, 'SoundVideo': <{'position': <2>}>, 'Accessories': <{'position': <3>}>, 'Utilities': <{'position': <4>}>}]"
}

setup_all() {
    # install apt packages
    install_apt
    
    # install snaps
    install_snaps

    # python and ruby
    install_python
    install_ruby
    
    # sdkman
    install_sdkman

    # install pnpm
    install_pnpm
    
    # theming
    setup_gsettings
}

# display menu to install everything
display_menu
setup_all

