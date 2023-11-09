#!/bin/bash
# spaces-setup.sh for dotfiles-spaces

initPrimary() {

    # Identify the "spaces primary repo":
    mapfile primaryCandidates < <(cd /; git ls -d /.git)
}

if [[ -z "$sourceMe" ]]; then
    for xfile in .inputrc .bashrc .vimrc; do
        [[ -f ~/dotfiles/${xfile} ]] || continue;
        ln -sf ~/dotfiles/${xfile} ~/ 
    done
    [[ $# -gt 0 ]] && {
        case "$1" in
            --minimal|-m) echo "--minimal passed to setup.sh, so we're leaving early." >&2; exit;;
            *) echo "WARNING: unknown argument(s) $@ passed to setup.sh" >&2;;
        esac
    }
    # Install jumpstart fresh:
    curl --noproxy '*' http://s3.dev.obdc.bcs.bloomberg.com/shellkit-data/jumpstart-setup-latest.sh -o ~/jumpstart-$UID-$$ && bash ~/jumpstart-$UID-$$ && rm -f ~/jumpstart-$UID-$$
    bash -ic 'source ~/dotfiles/jumpstart.bashrc; __jmpstart_add bbshellkit vbase'
fi
