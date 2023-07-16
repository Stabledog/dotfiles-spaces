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

JumpstartVersion=29

# Interactive-shell test: there's no point in doing the rest of this stuff
# if the current shell is non-interactive, and it's potentially dangerous
# to proceed even...
[[ $- == *i* ]] \
    || return


# Attention vim users:  un-comment the next statement when you want to switch
# the readline key map to `vi` mode instead of the default:
# set -o vi

umask 0022  # Turn off write permissions for group+others when creating new files
set -o ignoreeof  # Don't close the shell if we accidentally hit Ctrl+D

# The "Locale" deals with language internationalization. Best to get that set
# explicitly:
LC_JUMPSTART=${LC_JUMPSTART:-en_US.UTF-8}
export LC_ALL=$LC_JUMPSTART
export LANG=$LC_JUMPSTART
export LANGUAGE=$LC_JUMPSTART

# Don't put duplicate command-lines in the history, and if a command-lines
# starts with space, don't add it to history:
HISTCONTROL=ignoredups:ignorespace

# Timestamp format for command history:
HISTTIMEFORMAT="%F %T "

# Append to the history file on exit: don't overwrite it:
shopt -s histappend
PROMPT_COMMAND='history -a'

# When retrieving commands from history, load them into the edit buffer
# so the user can review/modify before execution:
shopt -s histverify

# How much command history should we keep?  This is mostly about
# ones' tolerance for watching-the-text-scroll if the 'history' command
# is entered on a sluggish terminal, vs. the desire to find very-old
# command lines.  It's not really about disk space or memory consumption.
HISTSIZE=10000

# Assuming 'dircolors' is available, define an alias for 'ls' which colorizes
# directory listings:
which dircolors &>/dev/null && { eval $(dircolors -b); alias ls='ls --color=auto'; }

# Check the window size after each command and update the values of lines
# and COLUMNS:
shopt -s checkwinsize

# Shell "aliases" are a simple first-word-substitution mechanism which save
# typing and wear-and-tear on the user's mental recall:
alias ll='ls --color=auto -l'   # The -l is "long format" in file listings
alias lr='ls --color=auto -lrt' # Sort by reverse timestamp, long format

# You can change to parent director(ies) with "cd ../../..", but typing
# all of those dots is exactly the sort of meaningless work that you hate:
alias .1='cd ..'
alias .2='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../..'

# You can set the terminal title (on the title bar) with this command, which
# is handy if you have many terminals open, e.g. for one terminal you might
# add the title "Code editing" and another might be "Compile + Test".
function title {
    printf '\E]2;%s\E\\' "$*"
}

# Enable command completion (i.e. with the TAB key) for bash commands:
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    source /etc/bash_completion
fi

# Disable flow control for the terminal.  Back in the day, Ctrl-S and Ctrl-Q
# were used to start and stop long-running streams of text from applications,
# but the need for that has been gone for years:
stty -ixon -ixoff

# Magic space expands !! and !-{n} when you hit spacebar after.  You can also do
# {cmd-frag}!<space> to expand the last command that started with that frag.
bind Space:magic-space

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
    [[ -n $PS1_HOST_SUFFIX ]] && { echo $PS1_HOST_SUFFIX; return; }
    [[ -n $PS1_SUPPRESS_HOST_SUFFIX ]] && return
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
        if lsb_release -a 2>/dev/null | egrep -q 'RedHat'; then
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
    local branch=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
    [[ -n $branch ]] && echo " [${branch}]"
}

function set_PS1 {
    # The built-in PS1 variable defines the format of the user's shell
    # prompt. This version displays:
    #   - date/time (\D{})
    #   - current directory (\w)
    #   - current git branch (parse_git_branch)
    #   - user name (\u)
    #   - host machine (\h)
    # See also: `man bash`.
    PS1='
\[\e[1;33m\]\D{%b-%d %H:%M:%S}\[\e[0m\] \[\e[1;35m\]\w\[\e[0m\]$(parse_git_branch)
\[\e[1;36m\][\u $PS1_HOST_SUFFIX \h]\[\e[0m\]$Ps1Tail> '
}

set_PS1  # Set the prompt to something more useful than the default








# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# - - - - - Jumpstart help, maintenance etc: best not to touch the rest unless you know what you're doing:
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


JumpBaseHelpUrl=https://bbgithub.dev.bloomberg.com/sanekits/jumpstart.bashrc/README.md

__jmpstart_help_links() {
    cat <<-EOF | fold -w 80
Jumpstart commands:
-------------------
    o  list: List available components
    o  add [component ...]: Add component(s)
    o  update:  Fetch and install latest version
    o  version: version + location

See also:
    $JumpBaseHelpUrl
EOF

}

__jmpstart_bootstrapper_url() {
    echo 'http://s3.dev.obdc.bcs.bloomberg.com/shellkit-data/jumpstart-setup-latest.sh'
}

__jmpstart_self_install() {
    cat <<-EOF
    which curl &>/dev/null && {
        http_proxy= https_proxy= curl -s -L $(__jmpstart_bootstrapper_url) -o ~/tmp-__jmpstart-\$\$.sh
        [[ \$? -eq -0 ]] || {
            echo "ERROR: failed downloading $(__jmpstart_bootstrapper_url)" >&2
            echo "  (try pasting that URL into the browser?  Is the vpn connected?)" >&2
            exit 19
        }
        bash ~/tmp-__jmpstart-\$\$.sh || exit 23
        exit 0
    }
    # fail-handling:
    echo "No curl on the PATH.  You should install 'curl' or manually download and run this instead: " >&2
    $(__jmpstart_bootstrapper_url)
    exit 21
EOF
}

__jmpstart_component_table() {
    cat <<-EOF
href_1|bbproxy|https://bbgithub.dev.bloomberg.com/sanekits/bbproxy-setup|BB proxy setup|Detect and configure Bloomberg proxy settings for bash.|jumpstart add bbproxy|
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
    echo "Component \"$1\" depends on bb-shellkit.  Would you like to add that first now?" >&2
    read -n 1 -p "  Enter [y] to accept, anything else will cancel: "
    case "$REPLY" in
        y|Y|yes|YES) ;;
        *) false; return ;;
    esac
    __jmpstart_add_single bbshellkit || { false; return; }
    source ~/.bashrc
    true
}


__jmpstart_add_single() {
    local kid="$1"
    case "$kid" in
        bbproxy)
            curl --noproxy '*' http://s3.dev.obdc.bcs.bloomberg.com/shellkit-data/bbproxy-setup-setup-latest.sh -o ~/bbprox-$UID-$$ && bash ~/bbprox-$UID-$$ && rm -f ~/bbprox-$UID-$$ ;;
        bbshellkit)
            curl --noproxy '*' http://s3.dev.obdc.bcs.bloomberg.com/shellkit-data/bb-shellkit-bootstrap.sh | bash - ;;
        cdpp)
            __jmpstart_prequal_shpm "cd++" && {
                bash -lc '~/.local/bin/shpm install cdpp';
            };;
        localhist)
            __jmpstart_prequal_shpm "localhist" && {
                bash -lc '~/.local/bin/shpm install localhist';
            };;
        gitsmart)
            __jmpstart_prequal_shpm "gitsmart" && {
                bash -lc '~/.local/bin/shpm install gitsmart';
            };;
        vbase)
            __jmpstart_prequal_shpm "vbase" && {
                bash -lc '~/.local/bin/shpm install vbase';
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
        source ~/.bashrc 2>/dev/null
        shift
    done
}

__jmpstart_href_1_cmp_print() {
    IFS=$'|\n' read kid kurl klabel kdesc kcmd <<< "$1"
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
    while IFS=$'| \n' read ctype kargs; do
        case "$ctype" in
            href_1) __jmpstart_href_1_cmp_print "$kargs";;
            *) [[ -n ${ctype} ]] && echo "ERROR: unknown ctype=${ctype}" >&2 ;;
        esac
    done < <(__jmpstart_component_table)
}


__jmpstart_verinfo() {
    cat <<-EOF
version=$JumpstartVersion
location=${BASH_SOURCE[0]}
url=${JumpBaseHelpUrl}
EOF
}

__jmpstart_main() {
    [[ $# -eq 0 ]] && { __jmpstart_help_links; return; }
    while true; do
        case "$1" in
            -h|--help) shift; __jmpstart_help_links "$@" ; return;;
            -u|update|--update|install|--install)
                shift;
                __jmpstart_self_install "$@" | bash - || return;
                exec bash;;
            -l|list|--list) shift; __jmpstart_add_list "$@" ; return;;
            -a|add|--add) shift; __jmpstart_add "$@"; return ;;
            -v|--version|version) shift; __jmpstart_verinfo ; return ;;
            *)  __jmpstart_help_links; echo "ERROR: unknown argument: $1"; false; return;;
        esac
        shift
    done
}

alias jumpstart=__jmpstart_main


