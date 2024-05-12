#!/bin/bash
set -e

function main(){
    sudo apt install -y git curl zsh tmux stow xclip npm gcc pip

    echo -e "\nInstalling starship"
    if ! command -v starship ; then
        curl -sS https://starship.rs/install.sh | sh
    fi

    stow --dir files --target $HOME . --adopt

    echo -e "\nInstalling tpm"
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm || true

    tmux start-server
    tmux new-session -d
    ~/.tmux/plugins/tpm/scripts/install_plugins.sh
    tmux kill-server

    echo -e "\nInstalling Vundle"
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim || true
    vim +PluginInstall +qall

    echo -e "\nInstalling fonts"
    mkdir -p ~/.fonts
    cp -r fonts/UbuntuMono ~/.fonts
    fc-cache -fv

    echo -e "\nInstalling Go"
    GO_VERSION=1.22.3
    curl -OL "go.dev/dl/go$GO_VERSION.linux-amd64.tar.gz"
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf go*.tar.gz
    rm -f "go$GO_VERSION.linux-amd64.tar.gz" 

    echo -e "\nInstalling nvim"
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
    sudo rm -rf /opt/nvim*
    sudo tar -C /opt -xzf nvim-linux64.tar.gz
    rm -f nvim-linux64.tar.gz

}

main
