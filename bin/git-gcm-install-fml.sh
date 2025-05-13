#!/bin/bash
# git-gcm-install-fml.sh
# Install Git Credential Manager in FML $HOME

#shellcheck disable=2154
PS4='\033[0;33m$( _0=$?;set +e;exec 2>/dev/null;realpath -- "${BASH_SOURCE[0]:-?}:${LINENO} \033[0;35m^$_0\033[32m ${FUNCNAME[0]:-?}()=>" )\033[;0m '
scriptName="${scriptName:-"$(command readlink -f -- "$0")"}"

# (if needed) scriptDir="$(command dirname -- "${scriptName}")"
[[ -n "$DEBUGSH" ]] && set -x

die() {
    builtin echo "ERROR($(basename "${scriptName}")): $*" >&2
    builtin exit 1
}

main() {
    set -ue
    set -x
    # Grab the self-contained tarball (no dependencies) and drop it in $HOME/usr
    mkdir -p $HOME/usr/{bin,lib} $HOME/tmp
    mkdir -p  $HOME/tmp/gcm
    [[ -f gcm-linux_amd64.tar.gz ]] || {
        curl -L -o gcm-linux_amd64.tar.gz https://github.com/git-ecosystem/git-credential-manager/releases/download/v2.6.1/gcm-linux_amd64.2.6.1.tar.gz
    }
    tar xzf gcm-linux_amd64.tar.gz 
    mv ./git-credential-manager $HOME/usr/bin 
    mv ./libHarfBuzzSharp.so ./libSkiaSharp.so $HOME/usr/lib      # :contentReference[oaicite:3]{index=3}

    echo 'export PATH=$PATH:$HOME/usr/bin # Added by git-gcm-install-fml.sh' >> ~/.bashrc 
    PATH=$PATH:$HOME/usr/bin
    git-credential-manager configure        # rest is identical (pick a credential store, auth once)

    echo "GCM installed OK"
}

if [[ -z "${sourceMe}" ]]; then
    main "$@"
    builtin exit
fi
command true
