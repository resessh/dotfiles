#!/bin/bash

CRNTDIR=$(cd $(dirname $0) && pwd)

ln -s $CRNTDIR/.zshrc ~/.
ln -s $CRNTDIR/.personal.zsh ~/.

ln -s $CRNTDIR/.vimrc ~/.vimrc

ln -s $CRNTDIR/.gitconfig ~/.

mkdir -p ~/.peco 2>/dev/null
ln -s $CRNTDIR/.peco/config.json ~/.peco/config.json
