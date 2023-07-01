#!/bin/sh
set -x 
original_dir=$(pwd)
# This script is for deploying my dotfiles to a new system.
# neovim, git, curl, and zsh are required for this script to work.

# neovim config
NVIM_URL=https://github.com/JPDucky/nvim.git
NVIM_DIR=$HOME/.config/nvim

# zsh config
ZSH_URL=https://github.com/JPDucky/.zsh.git
ZSH_DIR=$HOME/.zsh

# packages to install
PACKAGES=(
    "neovim"
    "git"
    "curl"
    "zsh"
)
# package managers to check for, which will be used to figure out distro/installl packages
PKG_MGR=(
    "dnf"
    "apt"
    "yum"
    "zypper"
    "pamac"
    "pacman"
    "nixos-rebuild"
)

# check for system distro
for command in $PKG_MGR; do
    if command -v $command &> /dev/null
    then 
        PKG_MGR=$command
        break
    else
        echo "The script cannot determine your package manager"
        echo "Please install neovim, git, curl, and zsh, \nand create an issue or a PR to add your package manager"
        echo "You can do so here: https://github.com/JPDucky/scripts"
        exit 1
    fi
done


# depending on which package manager is found, install packages
echo "Package manager $PKG_MGR found!"
echo "Installing packages now..."
for package in ${PACKAGES[@]}; do 
    case $PKG_MGR in
        dnf)
            if dnf list installed $package &> /dev/null; then
                echo "$package already installed"
            else
                sudo dnf install -y $package
                echo "installing $package"
            fi
            ;;
        apt)
            if dpkg -s $package &> /dev/null; then
                echo "$package already installed"
            else
                sudo apt install -y $package
                echo "installing $package"
            fi
            fi
            ;;
        yum)
            if yum list installed $package &> /dev/null; then
                echo "$package already installed"
            else
                sudo yum install -y $package
                echo "installing $package"
            fi
            fi
            ;;
        zypper)
            if zypper if $package &> /dev/null; then
                echo "$package already installed"
            else
                sudo zypper install -y $package
                echo "installing $package"
            fi
            fi
            ;;
        pamac)
            if pamac list installed $package &> /dev/null; then
                echo "$package already installed"
            else
                sudo pamac install -y $package
                echo "installing $package"
            fi
            fi
            ;;
        pacman)
            if pacman -Qs $package &> /dev/null; then
                echo "$package already installed"
            else
                sudo pacman -S --noconfirm $package
                echo "installing $package"
            fi
            fi
            ;;
        nixos-rebuild)
            config_file=/etc/nixos/configuration.nix
            if ! grep -q $package $config_file; then
                echo "Installing $package"
                sudo sed -i "/environment.systemPackages = with pkgs; \[/a \  $package" $config_file
            fi
            sudo nixos-rebuild switch 
            ;;
        *)
            echo "No package manager found!"
            echo "Please install neovim, git, curl, and zsh"
            ;;
    esac
done
echo "Packages installed!"


# install dotfiles
echo "Installing dotfiles:"
echo "Installing zsh config"
while [ ! -f .jpducky_zsh ]; do
    git clone $ZSH_URL $ZSH_DIR
    if [ $? -ne 0 ]; then
        echo "Failed to clone zsh config"
        exit 1
    fi
    cd $ZSH_DIR
    ./init.sh
    cd $original_dir
done

echo "Installing neovim config"
while [ ! -f .jpducky_nvim ]; do
    git clone $NVIM_URL $NVIM_DIR
    if [ $? -ne 0 ]; then
        echo "Failed to clone neovim config"
        exit 1
    fi
    cd $NVIM_DIR
    ./init.sh
    cd $original_dir
done

echo "dotfiles installed!"


echo "Checking shell"
if [[ $SHELL == "/usr/bin/zsh" ]]; then
    echo "Shell is already zsh"
else
    echo "Changing shell to zsh"
    chsh -s /usr/bin/zsh
fi

echo "Checking editor"
if [[ $EDITOR == "nvim" ]]; then
    echo "Editor is already nvim"
else
    echo "Changing editor to nvim"
    export EDITOR=nvim
fi

echo "Done!"
exit 0
