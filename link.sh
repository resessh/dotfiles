#!/bin/bash

CRNTDIR=$(cd $(dirname $0) && pwd)

ln -s $CRNTDIR/.zshrc ~/.
ln -s $CRNTDIR/.zshrc_prompt ~/.
ln -s $CRNTDIR/.zshrc_path ~/.
ln -s $CRNTDIR/.zshrc_alias ~/.
cp -i $CRNTDIR/.zshrc_local ~/.

ln -s $CRNTDIR/.vimrc ~/.vimrc

ln -s $CRNTDIR/.tmux.conf ~/.
cp -i $CRNTDIR/.tmux.local.conf ~/.

ln -s $CRNTDIR/.gitconfig ~/.

mkdir -p ~/.peco 2>/dev/null
ln -s $CRNTDIR/.peco/config.json ~/.peco/config.json
