#!/bin/bash
# spaces-setup.sh for dotfiles-spaces

initPrimary() {

    # Identify the "spaces primary repo":
    mapfile primaryCandidates < <(cd /; git ls -d /.git)
}

if [[ -z "$sourceMe" ]]; then
    # Install jumpstart fresh:
    curl --noproxy '*' http://s3.dev.obdc.bcs.bloomberg.com/shellkit-data/jumpstart-setup-latest.sh -o ~/jumpstart-$UID-$$ && bash ~/jumpstart-$UID-$$ && rm -f ~/jumpstart-$UID-$$
    bash -ic 'source ~/dotfiles/jumpstart.bashrc; __jmpstart_add bbshellkit vbase'
fi
