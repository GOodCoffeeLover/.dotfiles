#!/bin/bash
set -e

function main(){
    sudo apt install -y git curl zsh tmux stow
    curl -sS https://starship.rs/install.sh | sh

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

    mkdir -p ~/.fonts
    cp -r fonts/UbuntuMono ~/.fonts
    fc-cache -fv
}


function link(){
    if [[ ! -f "$PWD/$1/$2" ]]; then
        echo "$PWD/$1/$2 not exists to create link. skiping..."
        return
    fi
    if [[ -L  $HOME/$2 ]]; then
        echo "$2 is already hais soft link, skiping..."
        return
    fi 

    if [[ -f $HOME/$2 ]]; then
        echo "cp $HOME/$2 $PWD/$1/$2"
        cp $HOME/$2 $PWD/$1/$2
    fi

    echo "ln -sf $PWD/$1/$2 $HOME/$2"
    ln -sf $PWD/$1/$2 $HOME/$2 
}

main
