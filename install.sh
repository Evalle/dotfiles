#!/bin/sh
# this script will help you to install usful dotfiles

KDE4DIRECTORY=$HOME/.kde/share/apps/konsole
KDE5DIRECTORY=$HOME/.local/share/konsole

cp .bashrc $HOME/
cp .dir_colors $HOME/
cp -r .git $HOME/
cp .gitconfig $HOME/
cp i3/i3/config $HOME/.config/i3/
cp i3/i3status/config $HOME/.config/i3status/

if [ -d "$DIRECTORY" ]; then
    cp Monokai.colorscheme $KDE4DIRECTORY
else
    cp Monokai.colorscheme $KDE5DIRECTORY
fi

cp .tmux.conf $HOME/
cp -r .vim $HOME/
cp .vimrc $HOME/
exec aliases.sh
