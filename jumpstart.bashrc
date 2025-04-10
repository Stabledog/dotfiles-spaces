#!/bin/bash
# jumpstart.bashrc
# vim: filetype=sh :
#  WARNING: Don't change this file, as your changes will be
#  overwritten during updates.  See notes below.
#
#  An Opinionated BASH startup file for Bloomberg engineers
#
#  See https://bbgithub.dev.bloomberg.com/sanekits/jumpstart.bashrc/README.md for
# instructions and help
#
#  Recommended use:
#  ----------------
#    1.  Add a line to your ~/.bashrc which loads this file from your ~/dotfiles/ dir, i.e.:
#          source ~/dotfiles/jumpstart.bashrc
#
#    2.  If you're modifying your PATH, do that ABOVE the 'source...' statement
#
#    3.  If you're adding personal aliases, functions, and variables, do those
#        BELOW the 'source...' statement
#
#  Dotfiles management:
#  --------------------
#  In general, your Unix/Linux config files ("dotfiles") should be maintained in BBGitHub,
#  cloned down to ~/dotfiles, and there should be symlinks from your home directory
#  into ~/dotfiles/.bashrc, ~/dotfiles/.profile, etc.
#
#  What if you don't like something here?
#  --------------------------------------
#  1. Don't make changes directly in this file.  Instead, go to your ~/.bashrc
#     and redefine whatever you like AFTER the "source ~/dotfiles/jumpstart.bashrc"
#     statement.  You have the last word and pretty much anything can be overridden
#     this way.
#
#  2. If you think the defaults are wrong or want to offer enhancements, you can
#     create a BBGitHub pull request at:
#
#        https://bbgithub.dev.bloomberg.com/sanekits/jumpstart.bashrc
#
#  Who maintains this thing?
#  -------------------------
#    {FON: LES MATHESON<GO>}
#

JumpstartVersion=66

# Interactive-shell test: there's no point in doing the rest of this stuff
# if the current shell is non-interactive, and it's potentially dangerous
# to proceed even...
[[ $- == *i* ]] \
    || return


umask 0022  # Turn off write permissions for group+others when creating new files
set -o ignoreeof  # Don't close the shell if we accidentally hit Ctrl+D

set +o noclobber  # We don't need Mom telling us about how redirection can
                  # overwrite a file

# The "Locale" deals with language internationalization. Best to get that set
# explicitly:
LC_JUMPSTART=${LC_JUMPSTART:-en_US.UTF-8}
export LC_ALL=$LC_JUMPSTART
export LANG=$LC_JUMPSTART
export LANGUAGE=$LC_JUMPSTART


# - - - - - - - - - - - - - - Shell History  - - - - - - - - - - - - - - -

# The shell history is a wonderful feature that's often underused because
# of poor defaults. We fix that here.
#
# (Note: "jumpstart add localhist" installs a much larger set
# of shell history tools.)

alias h=history

# Append to the history file on exit: don't overwrite it:
shopt -s histappend
PROMPT_COMMAND='history -a'

# Timestamp format for command history:
HISTTIMEFORMAT="%F %H:%M "

# Don't put duplicate command-lines in the history, and if a command-lines
# starts with space, don't add it to history:
HISTCONTROL=ignoredups:ignorespace

# When retrieving commands from history, load them into the edit buffer
# so the user can review/modify before execution:
shopt -s histverify

# How much command history should we keep?  This is mostly about
# ones' tolerance for watching-the-text-scroll if the 'history' command
# is entered on a sluggish terminal, vs. the desire to find very-old
# command lines.  It's not really about disk space or memory consumption.
HISTSIZE=10000
HISTFILESIZE=$HISTSIZE

# Assuming 'dircolors' is available, define an alias for 'ls' which colorizes
# directory listings:
which dircolors &>/dev/null && { eval "$(dircolors -b)"; alias ls='ls --color=auto'; }

# Check the window size after each command and update the values of lines
# and COLUMNS:
shopt -s checkwinsize

# Shell "aliases" are a simple first-word-substitution mechanism which save
# typing and wear-and-tear on the user's mental recall:
alias ll='ls --color=auto -l'   # The -l is "long format" in file listings
alias lr='ls --color=auto -lrt' # Sort by reverse timestamp, long format


# You can set the terminal title (on the title bar) with this command, which
# is handy if you have many terminals open, e.g. for one terminal you might
# add the title "Code editing" and another might be "Compile + Test".
function title {
    printf '\E]2;%s\E'\\ "$*"
}

# Enable command completion (i.e. with the TAB key) for bash commands:
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    # shellcheck disable=SC1091
    source /etc/bash_completion
fi

# Disable flow control for the terminal.  Back in the day, Ctrl-S and Ctrl-Q
# were used to start and stop long-running streams of text from applications,
# but the need for that has been gone for years:
stty -ixon -ixoff 2>/dev/null

[[ -n $EDITOR ]] \
    || export EDITOR=vi

# Magic space expands !! and !-{n} when you hit spacebar after.  You can also do
# {cmd-frag}!<space> to expand the last command that started with that frag.
bind Space:magic-space

# Expand dir names in the edit buffer for path completion:
shopt -s direxpand 2>/dev/null || true

# Some system or user-default bashrc's like to create confirmation-forcing
# aliases for 'rm', 'cp', etc.  We don't like this: rather than trying to
# protect the user from normal file operations, it's better to develop
# practices which don't turn your environment into a precious little pet
# that needs uber-protection from mistakes -- i.e. everything important
# should be in source control 99.93% of the time.
unalias rm cp mv  2>/dev/null

function parse_host_suffix {
    # What sort of unix variant/flavor are we?
    #  (manually sync with shellkit/ps1-foo/parse_ps1_host_suffix.sh)
    [[ -n $PS1_HOST_SUFFIX ]] && { echo "$PS1_HOST_SUFFIX"; return; }
    [[ -n $PS1_SUPPRESS_HOST_SUFFIX ]] && return
    grep -sq code-server-init /proc/1/cmdline 2>/dev/null && { PS1_HOST_SUFFIX='Spaces'; echo "$PS1_HOST_SUFFIX"; return; }
    [[ -f /.dockerenv ]] && { PS1_HOST_SUFFIX='Docker'; echo $PS1_HOST_SUFFIX; return; }
    grep -sq docker /proc/1/cgroup && { PS1_HOST_SUFFIX='Docker'; echo $PS1_HOST_SUFFIX; return; }

    case $(uname -a) in
        Darwin*)
            PS1_HOST_SUFFIX='Mac'; echo $PS1_HOST_SUFFIX; return
            ;;
        Linux*-WSL2*)
            PS1_HOST_SUFFIX='Wsl2'; echo $PS1_HOST_SUFFIX ; return
            ;;
        Linux*-Microsoft*)
            PS1_HOST_SUFFIX='Wsl1'; echo $PS1_HOST_SUFFIX ; return
            ;;
        CYGWIN*)
            PS1_HOST_SUFFIX='Cyg'; echo $PS1_HOST_SUFFIX ; return
            ;;
        MINGW*)
            PS1_HOST_SUFFIX='Gitb'; echo $PS1_HOST_SUFFIX ; return
            ;;
    esac
    if which lsb_release &>/dev/null; then
        if lsb_release -a 2>/dev/null | grep -Eq 'RedHat'; then
            PS1_HOST_SUFFIX='rhat'; echo $PS1_HOST_SUFFIX; return
        fi
    fi
    PS1_HOST_SUFFIX='Generic'  # undetected
    echo $PS1_HOST_SUFFIX
}

parse_host_suffix &>/dev/null

function parse_git_branch() {
    # Parse the current git branch name and print it
    which git &>/dev/null || return
    local branch
    branch=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
    [[ -n $branch ]] && echo " [${branch}]"
}

# The built-in PS1 variable defines the format of the user's shell
# prompt. This version displays:
#   - date/time (\D{})
#   - current directory (\w)
#   - current git branch (parse_git_branch)
#   - user name (\u)
#   - host machine (\h)
# See also: `man bash`.
function set_PS1 {
    [ $? -eq 0 ] && local prevResult=true || prevResult=false
    local prevResultInd
    if $prevResult; then
        prevResultInd=$(printf "\[\033[01;32m\]""\xE2\x9C\x93""\[\033[;0m\]")
    else
        prevResultInd=$(printf "\[\033[01;31m\]""\xE2\x9C\x95""\[\033[;0m\]")
    fi
    PROMPT_DIRTRIM=3
    #shellcheck disable=2154
    PS1="
\[\e[1;33m\]\D{%b-%d %H:%M:%S}\[\e[0m\] \[\e[1;35m\]\w\[\e[0m\]$(parse_git_branch)
\[\e[1;36m\][\u $PS1_HOST_SUFFIX \h]\[\e[0m\]${Ps1Tail}${prevResultInd}> "
    $prevResult;  # Important to reset the prevResult in case of chained prompt commands
}

set_PS1  # Set the prompt to something more useful than the default

function set_PS4() {
    # When you use 'bash -x <scriptname>' or 'set -x' to enable tracing, it is very helpful see source+line+function info
    # in the trace output
    #shellcheck disable=SC2154
    PS4='$( _0=$?; exec 2>/dev/null; realpath -- "${BASH_SOURCE[0]:-?}:${LINENO} ^$_0 ${FUNCNAME[0]:-?}()=>" ) '
}

set_PS4 

case "$PROMPT_COMMAND" in
    set_PS1*) : ;;  # We already hooked in?
    *) PROMPT_COMMAND="set_PS1;${PROMPT_COMMAND}"
        #               ^^ Update PS1 before any other command can change result code.
esac


# cdx is an alternative to 'cd' which maintains a cache of recently used
# directories, presenting them as a selectable list if the user provides no args.
cdx ()
{
    [[ $# == 0 ]] && {
        _cdselect
        return
    };
    case "$@" in
        -h|--help)
            builtin help cd
            echo "cdx: [dir]"
            echo "  Present selection of cached dirs for dir change"
            echo "  [dir]: change to dir and add it to cache"
            return ;;
    esac
    _cdview -k | command grep -Eq "^${PWD}\$" || {
        builtin pushd -n "$PWD" > /dev/null
    }
    builtin cd "$@" || return
    _cdview -k | command grep -Eq "^${PWD}\$" || {
        builtin pushd -n "$PWD" > /dev/null
    }
    true
}

[[ $(type -t _cd) == function ]] && {
    complete -o nospace -F _cd cdx
}

_cdview() {
    builtin printf "%s\n" "${DIRSTACK[@]}" | (
        case $1 in
            -u) cat | command sort -u ;;
            -k) cat |  command tail -n +2 | command sort -u ;;
            *) cat
        esac
    )
}

_cdselect() {
    select xdir in $(_cdview -k); do
        # shellcheck disable=SC2164
        builtin cd "$xdir"
        return
    done
}

# You can change to parent director(ies) with "cd ../../..", but typing
# all of those dots is exactly the sort of meaningless work that you hate:
alias .1='builtin cd ..'
alias .2='builtin pushd ../.. &>/dev/null'
alias .3='builtin pushd ../../.. &>/dev/null'
alias .4='builtin pushd ../../../.. &>/dev/null'
alias .5='builtin pushd ../../../../.. &>/dev/null'
alias .6='builtin pushd ../../../../../.. &>/dev/null'


vi_mode_on() {
    # Vi users typically want vi keybindings in their shell, and this sets that
    # up in ~/.bashrc and ~/.inputrc
    cat <<-"EOF" > ~/.inputrc-$$
    set editing-mode vi
    set bell-style none
    set expand-tilde off
    set show-mode-in-prompt on
    set vi-ins-mode-string \1\e[;32m\2I:\1\e[;0m\2
    set vi-cmd-mode-string \1\e[;31m\2C:\1\e[;0m\2
    set colored-stats on
    set mark-symlinked-directories on
    set colored-completion-prefix on
    set show-all-if-ambiguous on
    set visible-stats on
    set match-hidden-files on
    $if mode=vi
        set keymap vi-command
        "s": nop
        set keymap vi-insert
        "jk": vi-movement-mode
        "\e.": yank-last-arg    
    $endif
EOF
    [[ -f ~/.inputrc ]] && cat ~/.inputrc >> ~/.inputrc-bak$$
    cat ~/.inputrc-$$ > ~/.inputrc

    echo "${HOME}/.inputrc updated"
    grep -Eq '^set -o vi' ~/.bashrc || {
        echo "set -o vi" >> ~/.bashrc
        echo "${HOME}/.bashrc updated"
        exec bash
    }
}


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# - - - - - Jumpstart help, maintenance etc: best not to touch the rest unless you know what you're doing:
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


JumpBaseHelpUrl=https://bbgithub.dev.bloomberg.com/sanekits/jumpstart.bashrc#readme

__jmpstart_help_links() {
    #shellcheck disable=SC2154
    local caption="Jumpstart (v${JumpstartVersion}):"
    local unl
    unl=$( printf '=%.0s' $(seq 1 ${#caption}) )

    cat <<-EOF | fold -w 80
$caption
$unl
    o  install:    Install to docker container or ssh host
        - jumpstart install docker my-container-name
            Install in running docker container by name or ID
        - jumpstart install ssh [user@]my-remote-server-name
            Install in remote ssh host
    o  update:     Self-update to latest version
    o  add [component ...]: Add component(s)
    o  list:       List available components
    o  version:    version + location
    o  -s:         print install command for clipboard copy
    o  --vi:       Enable vi keybindings in bash

See also:
---------
    $JumpBaseHelpUrl

Copy+paste (to install jumpstart elsewhere, from the clipboard):
----------------------------------------------------------------
EOF
    __jmpstart_scriptgen
}

__jmpstart_scriptgen() {
    echo curl "-k" "--noproxy '*'" "https://s3.dev.bcs.bloomberg.com/shellkit-data/jumpstart-setup-latest.sh \\"
    # shellcheck disable=SC2016
    echo '-o ~/jumpstart-$UID-$$ && bash ~/jumpstart-$UID-$$ && rm -f ~/jumpstart-$UID-$$; exec bash;'
}

__jmpstart_bootstrapper_url() {
    echo 'https://s3.dev.bcs.bloomberg.com/shellkit-data/jumpstart-setup-latest.sh'
}

__jmpstart_self_install() {
    local insmode="$1"  # Must be 'update' or 'install'
    shift

    if [[ "$insmode" == install ]]; then
        if [[ -n $1 ]]; then
            case "$1" in
                docker)
                    __jmpstart_docker_clone "$2"
                    return
                    ;;
                ssh)
                    __jmpstart_ssh_clone "$2"
                    return
                    ;;
                *)
                    echo "ERROR: unknown arg(s) to install [$*]" >&2
                    return 1
                    ;;
            esac
        fi
    fi

    # Fallthrough if we have eliminated docker and ssh as targets:
    bash - <<-EOF
    which curl &>/dev/null && {
        http_proxy= https_proxy= curl -k -s -L $(__jmpstart_bootstrapper_url) -o ~/tmp-__jmpstart-\$\$.sh
        [[ \$? -eq -0 ]] || {
            echo "ERROR: failed downloading $(__jmpstart_bootstrapper_url)" >&2
            echo "  (try pasting that URL into the browser?  Is the vpn connected?)" >&2
            exit 19
        }
        bash ~/tmp-__jmpstart-\$\$.sh || exit 23
        rm -f ~/tmp-__jmpstart-\$\$.sh &>/dev/null
        exit 0
    }
    # fail-handling:
    echo "ERROR: No curl on the PATH.  You should install 'curl' or manually download and run this script: " >&2
    echo $(__jmpstart_bootstrapper_url)
    exit 21
EOF
    # shellcheck disable=SC2181 # yes we want $? test here.
    [[ $? -eq 0 ]] || return 1
}

__jmpstart_component_table() {
    cat <<-EOF
href_1|bbproxy|https://bbgithub.dev.bloomberg.com/sanekits/bbproxy-setup|BB proxy setup|Detect and configure Bloomberg proxy settings for bash.|jumpstart add bbproxy|
href_1|bashics|https://github.com/sanekits/bashics#installation|bashics|Basic shell init sanity|jumpstart add bashics|
href_1|cdpp|https://github.com/sanekits/cdpp#installation|cd++|Smarter change-directory (replaces 'cd' builtin).|jumpstart add cdpp|
href_1|localhist|https://github.com/sanekits/localhist#setup|localhist|Smart bash history with automatic cleanup/condense|jumpstart add localhist|
href_1|gitsmart|https://github.com/sanekits/gitsmart#setup|gitsmart|Aliases, functions, and helpers for using git more efficiently|jumpstart add gitsmart|
href_1|vbase||vbase|Collection of generally-useful shellkit components|jumpstart add vbase|
href_1|bbshellkit|https://bbgithub.dev.bloomberg.com/sanekits/bb-shellkit/blob/main/README.md|BB shellkit|Package manager (shpm) for shellkit tools|jumpstart add bbshellkit|
EOF
}


__jmpstart_prequal_shpm() {
    PATH=$(bash -lc 'echo $PATH' 2>/dev/null)
    which shpm &>/dev/null \
        && return
    [[ -n "${JUMPSTART_FORCE_YES}" ]] || {
        echo "Component \"$1\" depends on bb-shellkit.  Would you like to add that first now?" >&2
        read -rn 1 -p "  Enter [y] to accept, [i] to ignore. Anything else will cancel: "
        case "$REPLY" in
            y|Y|yes|YES) ;;
            i|I) true; return ;;
            *) false; return ;;
        esac
    }
    __jmpstart_add_single bbshellkit || { false; return; }
    # shellcheck disable=SC1090
    source ~/.bashrc
    true
}


__jmpstart_add_single() {
    local kid="$1"
    case "$kid" in
        bbproxy)
            curl -k --noproxy '*' https://s3.dev.bcs.bloomberg.com/shellkit-data/bbproxy-setup-setup-latest.sh -o ~/bbprox-$UID-$$ && bash ~/bbprox-$UID-$$ && rm -f ~/bbprox-$UID-$$ ;;
        bbshellkit)
            curl -k --noproxy '*' https://s3.dev.bcs.bloomberg.com/shellkit-data/bb-shellkit-bootstrap.sh | bash - ;;
        cdpp)
            __jmpstart_prequal_shpm "cd++" && {
                bash -lc '${HOME}/.local/bin/shpm install cdpp';
            };;
        bashics)
            __jmpstart_prequal_shpm "bashics" && {
                bash -lc '${HOME}/.local/bin/shpm install bashics';
            };;
        localhist)
            __jmpstart_prequal_shpm "localhist" && {
                bash -lc '${HOME}/.local/bin/shpm install localhist';
            };;
        gitsmart)
            __jmpstart_prequal_shpm "gitsmart" && {
                bash -lc '${HOME}/.local/bin/shpm install gitsmart';
            };;
        vbase)
            __jmpstart_prequal_shpm "vbase" && {
                bash -lc '${HOME}/.local/bin/shpm install vbase';
            };;

        *)
            echo "ERROR: unknown component id in __jmpstart_add_single: $kid" >&2
            false; return ;;
    esac
}

__jmpstart_add() {
    while [[ -n "$1" ]]; do
        __jmpstart_add_single "$1" || return;
        PATH="$(bash -lc 'echo $PATH' 2>/dev/null)"
        # shellcheck disable=SC1090
        source ~/.bashrc 2>/dev/null
        shift
    done
}

__jmpstart_href_1_cmp_print() {
    IFS=$'|\n' read -r kid kurl klabel kdesc kcmd <<< "$1"
    echo "${klabel}:"
    echo "   o  $kdesc"
    [[ -n "$kurl" ]] && \
        echo "   o  $kurl"
    [[ -n $kcmd ]] && {
        echo "   o  Install command:"
        echo "       $kcmd"
    }
    echo
}

__jmpstart_add_list() {
    while IFS=$'| \n' read -r ctype kargs; do
        case "$ctype" in
            href_1) __jmpstart_href_1_cmp_print "$kargs";;
            *) [[ -n ${ctype} ]] && echo "ERROR: unknown ctype=${ctype}" >&2 ;;
        esac
    done < <(__jmpstart_component_table)
}


__jmpstart_verinfo() {
    local location
    location=$(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null)
    if [[ -z "$location" ]]; then
        location=$(awk '/^source .*jumpstart.bashrc/ {print $2}' ~/.bashrc 2>/dev/null | tr -d '"')
    fi
    sed 's/^[[:space:]]*//' <<EOF
        version=$JumpstartVersion
        location=$location
        url=${JumpBaseHelpUrl}
EOF
}

__jmpstart_main() {
    [[ $# -eq 0 ]] && { __jmpstart_help_links; return; }
    case "$1" in
        -h|--help) shift; __jmpstart_help_links "$@" ; return;;
        -u|update|--update|install|--install)
            local insmode="${1//--/}"
            shift;
            __jmpstart_self_install "$insmode" "$@" ; return ;;
        -l|list|--list) shift; __jmpstart_add_list "$@" ; return;;
        -a|add|--add) shift; __jmpstart_add "$@"; return ;;
        --scriptgen|-s) shift; __jmpstart_scriptgen "$@"; return ;;
        --vi) shift; vi_mode_on; return ;;
        -v|--version|version) shift; __jmpstart_verinfo ; return ;;
        *)  __jmpstart_help_links; echo "ERROR: unknown argument: $1"; false; return;;
    esac
}

__jmpstart_get_canon_localpath() {
    __jmpstart_verinfo | awk -F'=' '/^location=/ {print $2}'
}


__jmpstart_choose_docker_container() {
    # List the running docker containers, numbering each one for user selection.
    # Prompt the user for the selection, and print the selected container ID 
    # All output to user should go thru stderr, because our stdout is for result.
    mapfile -t containers < <( docker ps --format '{{.ID}} {{.Names}}' )
    if [[ "${#containers[@]}" -eq 0 ]]; then
        echo "No running docker containers found" >&2
        return 1
    fi

    echo "Select a docker container:" >&2
    select container in "${containers[@]}"; do
        if [[ -n "$container" ]]; then
            echo "$container" | awk '{print $1}'
            return 0
        else
            echo "Invalid selection" >&2
        fi
    done
}

__jmpstart_docker_clone() {
    command which docker &>/dev/null || { echo "docker is not installed" >&2; return 1; }
    local srcPath x_cid="$1"    # Container name or ID
    if [[ -z "$x_cid" ]]; then
        x_cid=$(__jmpstart_choose_docker_container)
        [[ -z "$x_cid" ]] && return 1
    else
        command docker inspect -f '{{.State.Running}}' "$1" &>/dev/null \
            || { echo "Container $1 not found" >&2; return 1; }
    fi
    srcPath="$(__jmpstart_get_canon_localpath)"
    (
        set -ue
        command docker cp "${srcPath}" "${x_cid}:/" >/dev/null
        echo "Copied host:${srcPath} to ${x_cid}:/jumpstart.bashrc"
        command docker exec -i -e "x_cid=${x_cid}" "${x_cid}" bash <<'EOF'
            set -ue
            grep -qE '^source [^#]*jumpstart\.bashrc' ${HOME}/.bashrc 2>/dev/null && { echo "Jumpstart is already sourced in ${x_cid}:~/.bashrc"; exit 0; } || :
            echo 'source /jumpstart.bashrc # added by __jmpstart_docker_clone ' >> ${HOME}/.bashrc
            echo "/jumpstart.bashrc added to ${HOME}/.bashrc in container ${x_cid}.  If you have existing shells open on this container you must do 'exec bash' to refresh them."
EOF
    ) || { echo "ERROR: failed install to ${x_cid}" >&2; return 1; }
    
}

__jmpstart_ssh_clone() {
    command which ssh &>/dev/null || { echo "Error: ssh is not installed" >&2; return 1; }
    local srcpath x_server="$1"
    [[ -z "$x_server" ]] && { echo "Error: no server name provided"; return 2; }
    srcpath="$(__jmpstart_get_canon_localpath)"
    (
        set -ue
        ssh "${x_server}" \
            bash -c ' \
            cat > ${HOME}/jumpstart.bashrc; \
            set -ue; \
            grep -Eq "^source .*jumpstart.bashrc" ${HOME}/.bashrc \
                || echo source \"${HOME}/jumpstart.bashrc\" >> ${HOME}/.bashrc\
            ' \
            < "${srcpath}"
    ) || { echo "ERROR: failed install to ${x_server}" >&2; return 3; }
    echo "Install to ${x_server} succeeded. If you have shell(s) open on the remote host, run 'exec bash' to refresh them."
}

alias jumpstart=__jmpstart_main
