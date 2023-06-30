#!/bin/bash

# This script is for deploying my dotfiles to a new system.
NVIM_URL=https://github.com/JPDucky/nvim.git
NVIM_DIR=$HOME/.config/nvim

ZSH_URL=https://github.com/JPDucky/.zsh.git
ZSH_DIR=$HOME/.zsh


PKG_MGR=""

PACKAGES=[
    "neovim"
    "git"
    "curl"
    "zsh"
]


if ! command -v nvim &> /dev/null
then
    echo "neovim could not be found"
    echo "installing neovim"
    # check for system distro
    for command in dnf apt yum zypper pamac pacman emerge nixos-rebuild; do
        if command -v $command &> /dev/null
        then 
            PKG_MGR=$command
            break
        fi
    done
fi


echo "Package manager $PKG_MGR found!"
echo "Installing packages now..."
case $PKG_MGR in
    dnf)
        sudo dnf install -y neovim git curl zsh
        ;;
    apt)
        sudo apt install -y neovim git curl zsh
        ;;
    yum)
        sudo yum install -y neovim git curl zsh
        ;;
    zypper)
        sudo zypper install -y neovim git curl zsh
        ;;
    pamac)
        sudo pamac install -y neovim git curl zsh
        ;;
    pacman)
        sudo pacman install -y neovim git curl zsh
        ;;
    emerge)
        sudo emerge -y neovim git curl zsh
        ;;
    nixos-rebuild)
        config_file=/etc/nixos/configuration.nix
        for package in $PACKAGES; do
            if ! grep -q $package $config_file; then
                echo "Installing $package"
                sudo sed -i "/environment.systemPackages = with pkgs; \[/a \  $package" $config_file
            fi
        done
        sudo nixos-rebuild switch 
        ;;
    *)
        echo "No package manager found!"
        echo "Please install neovim, git, curl, and zsh"
        exit 1
        ;;
esac
echo "Packages installed!"
echo "Installing dotfiles now..."

echo "Installing neovim config"
git clone $NVIM_URL $NVIM_DIR

echo "Installing zsh config"
git clone $ZSH_URL $ZSH_DIR

echo "dotfiles installed!"
echo "Done!"
exit 0
