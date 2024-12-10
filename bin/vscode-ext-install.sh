#!/bin/bash
# vscode-ext-install.sh

# We don't trust the result code of 'code --install-extension'.  So we scrape and
# parse the output to determine success or failure.

# VSCode install response samples:
#  Success:
# Installing extensions on spaces-docker-ob-156.dxspda.ob1.bcc.bloomberg.com:8549...
# Installing extension 'mhutchie.git-graph'...
# Extension 'mhutchie.git-graph' v1.30.0 was successfully installed.

# Failure (no such extension)
# Installing extensions on spaces-docker-ob-156.dxspda.ob1.bcc.bloomberg.com:8549...
# Extension 'mhutchie.git-graph9' not found.
# Make sure you use the full extension ID, including the publisher, e.g.: ms-dotnettools.csharp
# Failed Installing Extensions: mhutchie.git-graph9

# Success (already installed)
# Installing extensions on spaces-docker-ob-156.dxspda.ob1.bcc.bloomberg.com:8549...
# Extension 'mhutchie.git-graph' v1.30.0 is already installed. Use '--force' option to update to latest version or provide '@<version>' to install a specific version, for example: 'mhutchie.git-graph@1.2.3'.


scriptName="$(readlink -f "$0")"
scriptDir=$(command dirname -- "${scriptName}")


die() {
    builtin echo "ERROR($(basename "${scriptName}")): $*" >&2
    builtin exit 1
}

install_ext() {
    local ext="$1"
    local output
    #shellcheck disable=SC2154
    output="$("${Code}" --install-extension "${ext}" 2>&1)"
    echo "${output}"
    if [[ ${output} =~ "successfully installed" ]]; then
        return 0
    elif [[ ${output} =~ "is already installed" ]]; then
        return 0
    fi
    return 1
}

main() {
    [[ $# -eq 0 ]] && die "No extensions specified"
    declare -i failures=0
    #shellcheck disable=SC1090
    source <("${scriptDir}/env-detect") # Initialize the Code variable
    touch ~/.vscode-ext-install.log
    set -o pipefail
    {

        echo "Start: $(date -Iseconds): $*" 
        for ext in "$@"; do
            if install_ext "${ext}"; then
                builtin echo "Extension '${ext}' installed successfully"
            else
                builtin echo "Extension '${ext}' failed"
                ((failures++))
            fi
        done
        if ((failures > 0)); then
            die "Failed to install ${failures} of $# extensions"
        fi
    } 2>&1 | tee -a ~/.vscode-ext-install.log
}

[[ -z ${sourceMe} ]] && {
    main "$@"
    builtin exit
}
command true
