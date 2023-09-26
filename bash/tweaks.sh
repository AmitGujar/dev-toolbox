starship_cli() {
    echo "Installing starship....."
    curl -sS https://starship.rs/install.sh | sh
    wait
    echo "eval \"\$(starship init bash)\"" >> ~/.bashrc
    wait
    if [ -d ~/.config ]; then
        echo "Directory exists"
    else
        echo "Creating directory....."
        mkdir ~/.config
    fi
    wait
    touch ~/.config/starship.toml
    wait
    cat ../config/starship.toml >> ~/.config/starship.toml
    cat bashrc.config >> ~/.bashrc
    wait
    exec bash
    wait
    echo "Restart the terminal....."
}
starship_cli
