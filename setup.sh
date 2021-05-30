git clone https://github.com/savq/paq-nvim.git \
   "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/opt/paq-nvim

ln -s -f $(pwd)/gitconfig      ~/.gitconfig
ln -s -f $(pwd)/zshrc          ~/.zshrc
# ln -s -f $(pwd)/vimrc          ~/.config/nvim/init.vim
ln -s -f $(pwd)/tmux.conf      ~/.tmux.conf
ln -s -f $(pwd)/alacritty.yml  ~/.config/alacritty/alacritty.yml
ln -s -f $(pwd)/urls           ~/.newsboat/urls
ln -s -f $(pwd)/newsboat       ~/.newsboat/config
ln -s -f $(pwd)/init.lua       ~/.config/nvim/init.lua
