# .bashrc

# User specific aliases and functions


# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

source "${HOME}/dotfiles/jumpstart.bashrc"
source "/root/dotfiles/jumpstart.bashrc"
[[ -f ${HOME}/.local/bin/shellkit-loader.bashrc ]] && source ${HOME}/.local/bin/shellkit-loader.bashrc
