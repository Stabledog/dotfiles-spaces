#!/bin/bash
# dotfiles-spaces/install-inner.sh
# Here we interpret 'dotmake_opts' and command line args, and invoke
# make to suit.

scriptName="$(readlink -f "$0")"
scriptDir=$(command dirname -- "${scriptName}")

die() {
    builtin echo "ERROR($(basename "${scriptName}")): $*" >&2
    builtin exit 1
}

main() {
    PS4='\033[0;33m+$?( $( set +u; [[ -z "$BASH_SOURCE" ]] || realpath "${BASH_SOURCE[0]}"):${LINENO} ):\033[0m ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
    set -ue
    set -x
    make mega  #  todo: make this smarter using dotmake_opts and/or $@
}

if [[ -z "${sourceMe}" ]]; then
    "${scriptName} startup, PWD=$PWD"
    main "$@"
    builtin exit
fi
command true

