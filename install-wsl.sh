#!/bin/bash

cd ~


[[ -z $sourceMe ]] && {
    for file in $(cat dotfiles/my-dotfiles); do
        ln -s dotfiles/${file} ./${file}
    done
}

