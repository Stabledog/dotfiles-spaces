#!/usr/bin/env bash
# install-gitbash.sh

scriptName=$(basename -- "$(realpath -- "$0")")

PS4="+$?( $( set +u; [[ -z "$BASH_SOURCE" ]] || realpath "${BASH_SOURCE[0]}"):${LINENO} ): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }"
set -ue


if ! grep -q jumpstart ~/.bashrc; then
    curl -k --noproxy '*' https://s3.dev.bcs.bloomberg.com/shellkit-data/jumpstart-setup-latest.sh -o ~/jumpstart-$UID-$$
    bash ~/jumpstart-$UID-$$ && rm -f ~/jumpstart-$UID-$$
    echo "Jumpstart installed. Do 'exec bash' and then restart ${scriptNamer}" >&2
    exit 0
else
    echo "Jumpstart already installed: OK"
fi

# TODO: Microsoft installs a python3.exe stub which tells folks to go to the store :()
if python3.exe --version &>/dev/null; then
    if ! which cdpp-version.sh &>/dev/null; then
        set -o pipefail
        if ! curl -L https://github.com/sanekits/cdpp/releases/download/1.0.0/cdpp-setup-1.0.0.sh -o ~/tmp$$.sh && bash ~/tmp$$.sh && rm ~/tmp$$.sh; then
            echo "ERROR failed installing cdpp" >&2
        fi
    else
        echo "cdpp already installed: OK"
    fi
else
    echo "WARNING; python3 not installed.  If you run python3.exe with no arguments, Windows might help you install it.  Until then certain dotfiles tools won't work.  To solve this, install python3 and then re-reun ${scriptName}" >&2
    read -p "Enter to continue..."
fi

if ! bashics-version.sh &>/dev/null; then
    set -o pipefail
    curl -L https://github.com/sanekits/bashics/releases/download/0.8.4/bashics-setup-0.8.4.sh -o ~/tmp$$.sh
    bash ~/tmp$$.sh && rm ~/tmp$$.sh
else
    echo "bashics already installed: OK"
fi

if ! gitsmart-version.sh &>/dev/null; then
    set -o pipefail
    curl -L https://github.com/sanekits/gitsmart/releases/download/0.8.9/gitsmart-setup-0.8.9.sh -o ~/tmp$$.sh
    bash ~/tmp$$.sh && rm ~/tmp$$.sh
else
    echo "gitsmart already installed: OK"
fi

if ! makeup-version.sh &>/dev/null; then
    curl -L https://github.com/sanekits/makeup/releases/download/0.2.0/makeup-setup-0.2.0.sh \
    -o ~/tmp$$.sh && bash ~/tmp$$.sh && rm ~/tmp$$.sh
else
    echo "makeup already installed: OK"
fi

if [[ ! -e /bin/make ]]; then
    set -ue
    cd $TMPDIR
    curl -LO https://raw.githubusercontent.com/sanekits/git-bash-patch/main/make-installer.sh
    bash make-installer.sh
fi
