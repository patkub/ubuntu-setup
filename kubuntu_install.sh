#!/bin/bash

###
### Definitions
###

PYTHON_VERSION="3.13.2"
RUBY_VERSION="3.4.2"
NVM_VERSION="0.40.2"

# SDKMAN versions to install
declare -a SDKMAN_JAVA_VERSIONS=(
    "24-amzn"
    "21.0.6-amzn"
    "17.0.14-amzn"
)

declare -a SDKMAN_GRADLE_VERSIONS=(
    "8.13"
    "7.6.4"
)

# default SDKMAN versions to set
SDKMAN_DEFAULT_JAVA="21.0.6-amzn"
SDKMAN_DEFAULT_GRADLE="7.6.4"

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

setup_cloudflare_dns() {
    # setup cloudflare dns
    # https://developers.cloudflare.com/1.1.1.1/setup/linux/#systemd-resolved
    sudo mkdir -p /etc/systemd/resolved.conf.d/
    sudo touch /etc/systemd/resolved.conf.d/resolved.conf
    sudo bash -c 'cat << EOF > /etc/systemd/resolved.conf.d/resolved.conf
[Resolve]
DNS=1.1.1.1#one.one.one.one
DNSOverTLS=yes
EOF'
    # reload systemd-resolvd
    sudo systemctl daemon-reload
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

    # Google Chrome
    curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg
    echo "deb [arch=$ARCHITECTURE signed-by=/usr/share/keyrings/google-chrome.gpg] https://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list > /dev/null
    # update list of available packages
    sudo apt update -y

    # Speedtest CLI
    # override os detection
    export os="ubuntu"
    export dist="jammy"
    # Setup Speedtest CLI repository
    # download Speedtest CLI script and pass os detection variables to bash shell
    curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo -E bash

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
        fastfetch \
        git \
        google-chrome-stable \
        htop \
        obs-studio \
        podman \
        psensor \
        pipx \
        solaar \
        speedtest
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
    pipx ensurepath
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
    # reload bashrc
    reload_bashrc
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

load_nvm() {
    # load nvm for this script
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
}

install_node() {
    # install nvm
    # https://github.com/nvm-sh/nvm?tab=readme-ov-file#install--update-script
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v$NVM_VERSION/install.sh | bash

    # add nvm to bashrc
    if grep -q "NVM_DIR" ~/.bashrc ; then
        echo "nvm has already been added to ~/.bashrc"
    else
        cat <<'EOF' >>~/.bashrc
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
EOF
    fi

    # load nvm for this script
    load_nvm

    nvm install --lts
    nvm use --lts
}

setup_look() {
    # dark theme
    lookandfeeltool -a org.kde.breezedark.desktop
}

setup_all() {
    # cloudflare dns
    setup_cloudflare_dns

    # install apt packages
    install_apt
    
    # install snaps
    install_snaps

    # python and ruby
    install_python
    install_ruby
    
    # sdkman
    install_sdkman

    # node
    install_node
    
    # theming
    setup_look
}

# display menu to install everything
display_menu
setup_all

