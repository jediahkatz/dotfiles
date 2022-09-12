#!/usr/bin/zsh
# NOTE: THIS SCRIPT IS NOT CURRENTLY RUNNABLE

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Add symlinks
ln -s $(pwd)/.alacritty.yml ~/.alacritty.yml
ln -s $(pwd)/.p10k.zsh ~/.p10k.zsh
rm ~/.zshrc
ln -s $(pwd)/.zshrc ~/.zshrc

# TODO: os-specific symlinks

# Ubuntu only
sudo apt update

sudo add-apt-repository ppa:deadsnakes/ppa
packages=(
    tmux zip unzip fd-find
    python3 python3-pip python3.6 libpython3.6-dev python3.7 libpython3.7-dev python3.9 libpython3.9-dev
    yarn
    build-essential zlib1g-dev llvm-dev libclang-dev clang
    bat lsd diff-so-fancy ripgrep fzf
    hub
)

sudo apt install "$packages"

# OSX only
packages=(
    tmux fd
    yarn
    bat lsd diff-so-fancy ripgrep fzf
    hub
)

brew install $packages

# TODO: add all non-apt stuff:
# - cargo, nvm, 

# Install tldr
git clone https://github.com/tldr-pages/tldr-c-client.git
cd tldr-c-client

./deps.sh           # install dependencies
make                # build tldr
make install        # install tldr
cd ../
rm -rf tldr-c-client

git clone https://github.com/Aloxaf/fzf-tab ~ZSH_CUSTOM/plugins/fzf-tab

# Install zsh plugins
git clone https://github.com/agkozak/zsh-z $ZSH_CUSTOM/plugins/zsh-z
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# brew install zsh-syntax-highlighting
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
