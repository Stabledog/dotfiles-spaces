# spaceup.bashrc

code() {
    [[ -e $VSCODE_IPC_HOOK_CLI ]] && {
        remoteCli=$(ls ${HOME}/.vscode-remote/bin/*/bin/remote-cli/code 2>/dev/null | head -n 1 )
        [[ -x "${remoteCli}" ]] && {
            "${remoteCli}" "$@"
            return
        }
        which code-server &>/dev/null && {
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
