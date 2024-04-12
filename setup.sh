ln -s -f $(pwd)/gitconfig     ~/.gitconfig
ln -s -f $(pwd)/zshrc         ~/.zshrc

mkdir -p ~/.config/nvim
mkdir -p ~/.config/lazygit
mkdir -p ~/.config/kitty

ln -s -f $(pwd)/init.lua      ~/.config/nvim/init.lua
ln -s -f $(pwd)/lazygit.yml   ~/.config/lazygit/config.yml
ln -s -f $(pwd)/kitty.conf    ~/.config/kitty/kitty.conf

# https://github.com/VSCodeVim/Vim?tab=readme-ov-file#-installation
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
