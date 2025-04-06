# spaceup.bashrc

code() {
    [[ -e $VSCODE_IPC_HOOK_CLI ]] && {
        local remoteCli_1=$(command ls ${HOME}/.vscode-remote/bin/*/bin/remote-cli/code 2>/dev/null | head -n 1 )
        readonly remoteCli_1
        [[ -x "${remoteCli_1}" ]] && {
            "${remoteCli_1}" "$@"
            return
        }
        local remoteCli_2="$(command which code 2>/dev/null)"
        readonly remoteCli_2
        if [[ "${remoteCli_2}" == *server/cli*code ]]; then
            ${remoteCli_2} "$@"
            return
        fi
        command which code-server &>/dev/null && {
            command code-server "$@"
            return
        }
    }
    which code &>/dev/null && {
        command code "$@"
        return
    }
    echo "ERROR: [dotfiles]/dot/spaceup.bashrc#code() -- can't find suitable CLI for vscode invocation" >&2
    false
}

which vim &>/dev/null || alias vim=vi

SPACEUP=true
set -o vi
