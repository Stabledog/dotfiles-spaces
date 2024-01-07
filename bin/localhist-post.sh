#!/bin/bash
# localhist-post.sh
# Hook up ~/.localhist-archive to github/bbgh/other so that
# sync works.
#   --infer-hostname << Setup ~/.localhist-hostname automatically
#   --gh-url [url]  << Git-clone this in $LH_ARCHIVE so lh sync works

#  Either of these (or both) can be provided.

# Either or both can be provided--infer-hostname

scriptName="$(readlink -f "$0")"
scriptDir=$(command dirname -- "${scriptName}")



die() {
    builtin echo "ERROR($(basename ${scriptName})): $*" >&2
    builtin exit 1
}

infer_hostname() {
    xname=$(ls -d /*/.git 2>/dev/null | head -n 1)
    [[ -n $xname ]] || return
    ( IFS='/'; echo ${xname} | awk '{print $1}' )
}

setup_gitsync() {
    set -ue
    local gh_url="$1"
    source ${HOME}/.localhistrc
    [[ -n "${LH_HOSTNAME}" ]] || exit 23
    [[ -d ${HOME}/.localhist-archive ]] || exit 25
    [[ -n "$gh_url" ]] || exit 27
    cd ${HOME}/.localhist-archive
    [[ -d .git ]] && exit 29
    git clone "$gh_url" tmp-$$ || exit 31
    mv tmp-$$/.git ./ || exit 33
    git reset --hard HEAD
    rm -rf tmp-$$ || :
    git add . || :
    set +ue
}


[[ -z ${sourceMe} ]] && {
    while [[ -n $1 ]]; do
        case $1 in
            --gh-url)
                setup_gitsync "$2"; shift
                ;;
            --infer-hostname)
                infer_hostname > ${HOME}/.localhist-hostname
                ;;
            *)
                echo "Bad arg: $1"; exit 21
                ;;
        esac
        shift
    done

    builtin exit
}

command true
