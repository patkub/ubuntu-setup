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

###
### Start
###

# update sudo timestamp
sudo -v

reload_bashrc() {
    # reload bashrc
    PS1='$ '
    source ~/.bashrc
}

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

    # Google Chrome
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
    sudo sh -c 'echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list'

    # update system
    sudo apt update -y
    sudo apt upgrade -y
    sudo apt dist-upgrade -y

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
        curl \
        fastfetch \
        git \
        google-chrome-stable \
        htop \
        obs-studio \
        psensor \
        solaar
}

install_snaps() {
    # install snap packages
    # Programming
    sudo snap install --classic code
    sudo snap install --classic go
    sudo snap install --classic intellij-idea-community
    sudo snap install --classic pycharm-community
    sudo snap install --classic ruby

    # JetBrains
    sudo snap install --classic clion --channel=2024.3/stable
    sudo snap install --classic datagrip --channel=2024.3/stable
    sudo snap install --classic dataspell --channel=2024.3/stable
    sudo snap install --classic goland --channel=2024.3/stable
    sudo snap install --classic intellij-idea-ultimate --channel=2024.3/stable
    sudo snap install --classic phpstorm --channel=2024.3/stable
    sudo snap install --classic pycharm-professional --channel=2024.3/stable
    sudo snap install --classic rider --channel=2024.3/stable
    sudo snap install --classic rubymine --channel=2024.3/stable
    sudo snap install --classic webstorm --channel=2024.3/stable
    
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

install_python() {
    # install pyenv
    install_pyenv
    
    # reload bashrc
    reload_bashrc
    
    # install python
    pyenv install $PYTHON_VERSION
    pyenv global $PYTHON_VERSION

    # upgrade pip
    pip3 install --upgrade pip
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

install_ruby_build() {
    git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
}

install_ruby() {
    # install rbenv
    install_rbenv
    
    # reload bashrc
    reload_bashrc
    
    # install ruby-build
    install_ruby_build
    
    # install ruby
    rbenv install $RUBY_VERSION
    rbenv global $RUBY_VERSION
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
    # load sdkman
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    
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

    # load nvm
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

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

