#!/bin/bash
set -e

function main(){
    sudo apt install -y git curl zsh tmux stow xclip npm gcc pip ripgrep vim python3-venv

    echo -e "\nInstalling starship"
    if ! command -v starship ; then
        curl -sS https://starship.rs/install.sh | sh
    fi
    if [ ! -d ~/.oh-my-zsh ] ; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
        rm ~/.zshrc
    fi
    stow --dir files --target "$HOME" . --adopt
    mkdir "$HOME/.git_template/hooks"
    ln -s "./prepare-commit-msg"  "$HOME/.git_template/hooks/prepare-commit-msg"

    grep "default_zshrc" ~/.zshrc  || echo "source $HOME/.default_zshrc" >> ~/.zshrc
    grep "kube_aliases" ~/.zshrc  || echo "source $HOME/.kube_aliases" >> ~/.zshrc

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

    if ! command -v go ; then
        echo -e "\nInstalling Go"
        GO_VERSION=1.22.3
        curl -OL "go.dev/dl/go$GO_VERSION.linux-amd64.tar.gz"
        sudo rm -rf /usr/local/go
        sudo tar -C /usr/local -xzf go*.tar.gz
        rm -f "go$GO_VERSION.linux-amd64.tar.gz" 
    fi

    echo -e "\nInstalling nvim"
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
    sudo rm -rf /opt/nvim*
    sudo tar -C /opt -xzf nvim-linux64.tar.gz
    rm -f nvim-linux64.tar.gz


}

main
