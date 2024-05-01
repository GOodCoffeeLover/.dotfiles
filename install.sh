# sudo apt install tmux stow
# curl -sS https://starship.rs/install.sh | sh

echo "Installing tpm"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/scripts/install_plugins.sh

echo "Installing Vundle"
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

echo "stow --target=$HOME --dir ./files/ ."
stow --target=$HOME --dir ./files/ .
