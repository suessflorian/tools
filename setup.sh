ln -s -f $(pwd)/gitconfig     ~/.gitconfig
ln -s -f $(pwd)/zshrc         ~/.zshrc

mkdir -p ~/.config/nvim
mkdir -p ~/.config/lazygit
mkdir -p ~/.config/kitty

ln -s -f $(pwd)/init.lua      ~/.config/nvim/init.lua
ln -s -f $(pwd)/lazygit.yml   ~/.config/lazygit/config.yml
ln -s -f $(pwd)/kitty.conf    ~/.config/kitty/kitty.conf

# https://notrab.dev/posts/friendly-mac-os-defaults/
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# increase the Dock show/hide speed
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-time-modifier -float 0.5
killall Dock
