#!/bin/bash
# spaces-setup.sh for dotfiles-spaces

initPrimary() {

    # Identify the "spaces primary repo":
    mapfile primaryCandidates < <(cd /; git ls -d /.git)
}

if [[ -z "$sourceMe" ]]; then
    # Install jumpstart fresh:
    curl --noproxy '*' http://s3.dev.obdc.bcs.bloomberg.com/shellkit-data/jumpstart-setup-latest.sh -o ~/jumpstart-$UID-$$ && bash ~/jumpstart-$UID-$$ && rm -f ~/jumpstart-$UID-$$
    source ~/dotfiles/jumpstart.bashrc
    jumpstart add bb-shellkit vbase
fi

