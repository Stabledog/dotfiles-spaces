# .bashrc

# User specific aliases and functions


# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

source "${HOME}/dotfiles/jumpstart.bashrc"

source "/root/dotfiles/jumpstart.bashrc"
[[ -f ${HOME}/.local/bin/shellkit-loader.bashrc ]] && source ${HOME}/.local/bin/shellkit-loader.bashrc

[[ $- == *i* ]] && {
    [[ -f ${HOME}/dotfiles/setup.sh ]] && [[ ! -f ${HOME}/.dotfiles-init.flag ]] && {
        echo "I found ~/dotfiles/setup.sh.  Run it now? [y/N]" >&2
        read -n 1
        touch ${HOME}/.dotfiles-init.flag
        [[ "$REPLY" =~ [yY] ]] && {
            ${HOME}/dotfiles/setup.sh && exec bash
        }
    }
}
