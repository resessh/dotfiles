#!/bin/bash

CRNTDIR=$(cd $(dirname $0) && pwd)

ln -s $CRNTDIR/.zshrc ~/.
ln -s $CRNTDIR/.zshrc_prompt ~/.
ln -s $CRNTDIR/.zshrc_path ~/.
ln -s $CRNTDIR/.zshrc_alias ~/.
cp $CRNTDIR/.zshrc_local ~/.

ln -s $CRNTDIR/.vimrc ~/.vimrc

ln -s $CRNTDIR/.tmux.conf ~/.
cp $CRNTDIR/.tmux.local.conf ~/.

ln -s $CRNTDIR/.gitconfig ~/.
