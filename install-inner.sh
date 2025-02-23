#!/bin/bash
# dotfiles-spaces/install-inner.sh
# Here we interpret 'dotmake_opts' and command line args, and invoke
# make to suit.

#  About dotmake_opts:
# This environment variable is a comma-delimited string of "elements".
# - Commas are not allowed at all in the dotmake_opts value, except as element delimiter
# - Each element has the form "ccc:value", where "ccc" is one of the valid
#    element parsers.
#   
#  - Parsers:  
#     o   dmparse_repo (maps repo/branch to make target(s))
#          Element format  "repo:[reponame[/branch]]=[target list]"
#          e.g. repo:nothing/test1=jumpstart bashics
#        ... When the repo name is 'nothing' and the branch is 'test1', we want
#            the jumpstart and bashics targets to be installed.
#        - Both 'repo' and 'branch' can be '*' to match all.


scriptName="$(readlink -f "$0")"

die() {
    builtin echo "ERROR($(basename "${scriptName}")): $*" >&2
    builtin exit 1
}

stub() {
    echo "  . . . !stub!: [$*]  THIS IS NOT PRODUCTION READY" >&2
}

get_elems_by_parser() {
    # Print the list of elements for a given parser.  Strips the <parser>: prefix.
    parser="$1"
    # shellcheck disable=SC2154
    echo "$dotmake_opts" | tr ',' '\n' | grep -E "^[[:space:]]*${parser}:" | sed -e 's/.*://'
}

get_repo_name() {
    # Identifies the primary repo for the space and gets its name
    set -ue
    local workdir="$1"
    [[ -d "${workdir}" ]]  || return
    builtin cd "${workdir}"
    basename "$( git ls-remote --get-url | sed 's/\.git$//' )"
}

get_branch_name() {
    set -ue
    local workdir="$1"
    [[ -d "${workdir}" ]]  || return
    builtin cd "${workdir}"
    [[ -d .git ]] || return
    command git branch | command awk '/\*/ { print $2 }'
}

repo_parser_match() {
    # Given the Space's repo/branch, and a repo Element to match,
    # evaluate the match.  Return 0 for success.
    local space_repo="$1"
    local space_branch="$2"
    local elem="$3"
    local pattern repo_match branch_match
    # Extract pattern from targets by splitting on '='
    pattern="${elem//=*/}" 
    # Extract pattern reponame and branch:
    read -r pat_repo pat_branch < <( echo "${pattern//\// }" )
    [[ -n "$pat_repo" ]] || return 2
    [[ -n "$pat_branch" ]] || pat_branch='*'
    repo_match=false branch_match=false

    # Repo test:
    if [[  "${pat_repo}" == "*" ]]; then repo_match=true ; else :; fi
    if [[ "${pat_repo}" == "${space_repo}" ]]; then repo_match=true; else :; fi
    if ! $repo_match ; then  return 3; else : ; fi

    # Branch test:
    if [[ "$pat_branch" == '*' ]]; then branch_match=true; else :; fi
    if [[ "$pat_branch" == "$space_branch" ]]; then branch_match=true; else :; fi
    if ! $branch_match; then return 4; else :; fi
    return 0
}

resolve_make_targets() {
    # 1.  We need the current repo name and branch of the working tree
    # 2.  For each matching element, test the name/branch pattern
    # 3.  If it matches, add the target names to our growing list
    local targets=()
    local repo branch
    repo="$(get_repo_name "${SPACES__WORKAREA}")"
    branch="$(get_branch_name "${SPACES__WORKAREA}")"
    while read -r repo_def; do
        if repo_parser_match "$repo" "$branch" "$repo_def"; then
            # shellcheck disable=SC2179
            targets+="$( echo -n " ${repo_def//*=/}" )"
        fi
    done < <(get_elems_by_parser "repo")
    echo "${targets[@]}" | awk '{$1=$1; print}'  # (Remove leading/trailing space)
}

main() {
    PS4='\033[0;33m+$?( $( set +u; [[ -z "$BASH_SOURCE" ]] || realpath "${BASH_SOURCE[0]}"):${LINENO} ):\033[0m ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
    set -ue
    makeTargets="$(resolve_make_targets "$@")"
    {
        echo "dotmake target resolution completed: making [$makeTargets]" 
        echo "    (dotmake_opts=[${dotmake_opts}]) " 
        env | awk '/^SPACE/ {print "    " $0}'
        [[ -n $SPACES__WORKAREA ]] && {
            echo "    git branch: $(cd "${SPACES__WORKAREA}" && git branch | awk '/\*/ {print $2}' )"
        }
    } >&2

    if [[ -n "${makeTargets}" ]]; then
        # shellcheck disable=SC2086 
        make $makeTargets
    else
        echo "   No dotmake_opts rule matched, so default target selected: mega" >&2
        make mega
    fi
}

if [[ -z "${sourceMe}" ]]; then
    echo "${scriptName} startup, PWD=$PWD"
    main "$@"
    builtin exit
fi
command true

