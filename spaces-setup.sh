#!/bin/bash
# spaces-setup.sh for dotfiles-spaces

initPrimary() {

    # Identify the "spaces primary repo":
    mapfile primaryCandidates < <(cd /; git ls -d /.git)
}

if [[ -z "$sourceMe" ]]; then
    curl http://s3.dev.obdc.bcs.bloomberg.com/shellkit-data/bb-shellkit-bootstrap.sh | bash -

    ${HOME}/.local/bin/shpm install vbase
    ${HOME}/.local/bin/vi-mode.sh on
fi

