#!/bin/bash

check_curl() {
    if command -v curl &> /dev/null; then
        echo "curl is already installed..."
    else
        echo "Installing curl....."
        apt install curl -y
    fi
}

starship_cli() {
    echo "Installing starship....."
    # Try non-interactive install first; fall back to default if unsupported
    if ! curl -fsSL https://starship.rs/install.sh | sh -s -- -y; then
        curl -fsSL https://starship.rs/install.sh | sh
    fi
    echo "eval \"\$(starship init bash)\"" >> ~/.bashrc
    wait
    if [ -d ~/.config ]; then
        echo "Directory exists"
    else
        echo "Creating directory....."
        mkdir -p ~/.config
    fi
    wait
    touch ~/.config/starship.toml
    wait
    cat ../config/starship.toml >> ~/.config/starship.toml
    if [ $? -ne 0 ]; then
        cd /tmp
        git clone https://github.com/AmitGujar/dev-toolbox
        cd /tmp/dev-toolbox/bash
        cat ../config/starship.toml >> ~/.config/starship.toml
    fi
    cat bashrc.config >> ~/.bashrc
    if [ -t 0 ]; then
        exec bash
    else
        echo "Open a new shell to load changes."
    fi
}

check_curl
starship_cli
