# spaceup.bashrc

code() {
    which code &>/dev/null && {
        command code "$@"
    } || {
        command code-server "$@"
    }
}

which vim &>/dev/null || alias vim=vi

SPACEUP=true
set -o vi
