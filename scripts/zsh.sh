#!/usr/bin/zsh
sudo apt update

sudo add-apt-repository ppa:deadsnakes/ppa
packages=(
    tmux zip unzip fd-find
    python3 python3-pip python3.6 libpython3.6-dev python3.7 libpython3.7-dev python3.9 libpython3.9-dev
    yarn
    build-essential zlib1g-dev llvm-dev libclang-dev clang
    bat lsd ripgrep fzf
)

sudo apt install "$packages"

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

