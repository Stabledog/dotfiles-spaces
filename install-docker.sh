#!/bin/bash
#install-docker.sh

scriptName="$(readlink -f "$0")"
scriptDir=$(command dirname -- "${scriptName}")

die() {
    builtin echo "ERROR($(basename ${scriptName})): $*" >&2
    builtin exit 1
}

stub() {
   builtin echo "  <<< STUB[$*] >>> " >&2
}
main() {
    [[ -f /.dockerenv ]] || die "This script expects to run in a Docker container marked by /.dockerenv"
    cd ~ && {
        mkdir -p ~/dotfile-backups
        for file in bashrc inputrc vimrc; do
            command mv .${file} dotfile-backups 2>/dev/null || :
            ln -sf ${scriptDir}/${file} ./.${file}
        done
        echo "dotfiles install done, restart your shell." >&2
    }
}

[[ -z ${sourceMe} ]] && {
    main "$@"
    builtin exit
}
command true


