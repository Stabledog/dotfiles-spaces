#!/bin/bash
# install-gitbash.sh

scriptName=$(basename -- "$(realpath -- "$0")")

set -ue


if ! grep -q jumpstart ~/.bashrc; then
    curl -k --noproxy '*' https://s3.dev.bcs.bloomberg.com/shellkit-data/jumpstart-setup-latest.sh \
        -o ~/jumpstart-$UID-$$ && bash ~/jumpstart-$UID-$$ && rm -f ~/jumpstart-$UID-$$ && exec bash
fi

# TODO: Microsoft installs a python3.exe stub which tells folks to go to the store :()
if python3.exe --version 2>/dev/null; then
    true
else
    echo "WARNING; python3 not installed.  If you run python3.exe with no arguments, Windows might help you install it.  Until then certain dotfiles tools won't work.  To solve this, install python3 and then re-reun ${scriptName}" >&2
    read -p "Enter to continue..."
fi
