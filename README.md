# :fire: 

So, it's been around 2 month since I transitioned from a GUI focused development environment. I've had the ability to check out many different plugins that vim has to offer moreover had a good chance to get familiar with a more powerful terminal emulator, tmux for multi-window/multi-session support and a new approach to git management.

- [alacittry](https://github.com/jwilm/alacritty)
- [neovim](https://github.com/neovim/neovim)
- [tmux](https://github.com/tmux/tmux/wiki)
- [tig](https://github.com/jonas/tig)

My current overall big ticket to-do list is;

- Learn how to most effectively use tig in a standard work flow
- Continue building favoured tmux/nvim key bindings
- ~~Language Servers (Go, Flow are priorities)~~
- *Buffers* vs ~~Tabs~~? Quickfix:question:LocList:question:

Feel free to join the journey and watch it grow!

## v0.3.1
Lots of minor tweaks have come out to this release. My appearance preferences are beginning to finally mature. I've tweaked how I search content and files via [fzf-vim](https://github.com/junegunn/fzf.vim) heavily utulising `ripgrep` specific commands under the hood. I've decided to completely abondon the intiative of making `flow lsp` work well with `ale`. Italics for comments. Ripped out all vim focused `git`  clients in favour of `tig` and made `vim-move` simply **work** by appending my own version of the plugin to the end of my `init.vim` file. 

## v0.2.0
As I started playing around with more and more CLI based tools to subsitute productivity tasks that I used to do on a full blown IDE. I noticed that the performance on iTerm2 and Terminal simply wasn't good enough. More frequently than not, lag spikes occured on upward and downward scrolling, `vim-fugitive` more often than got bulked down on large commits... these lag spikes made me explore [Alacittry](https://github.com/jwilm/alacritty). It is insanely fast.

## v0.1.0
At this point, I'm getting a little more familiar with the navigation styles vim has to offer while making heavy use of vim plugins. I decided to also move over to a new shell, namely iTerm2. Colours just seem to pop more. Plus there are some very useful extensions available. Currently making use of `oh-my-zsh`.

## v0.0.1
Getting things started, simply incorporating vim into a bash environment, making use of the good ol' terminal setup Mac has to offer.
