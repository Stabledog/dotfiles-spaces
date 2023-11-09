# Makefile for dotfiles-spaces
SHELL=/bin/bash
.ONESHELL:
.SUFFIXES:
MAKEFLAGS += --no-builtin-rules --no-print-directory

absdir := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

Code = $(shell which code code-server 2>/dev/null | head -n 1)

VscodeUserDir = $(HOME)/.local/share/code-server/User

Flag := $(HOME)/.flag-dotfiles

none: $(Flag)/.init

$(Flag)/.init:
	mkdir -p $(Flag)
	touch $@

jumpstart: $(Flag)/jumpstart
vbase: $(Flag)/vbase
makestuff: $(Flag)/makestuff
vscodevim: $(Flag)/vscodevim
spaceup: $(Flag)/spaceup
vsweb-settings: $(Flag)/vsweb-settings

$(Flag)/jumpstart:
	@set -ue
	curl -k --noproxy '*' https://s3.dev.bcs.bloomberg.com/shellkit-data/jumpstart-setup-latest.sh \
		-o ~/jumpstart-$$UID-$$$$ && bash ~/jumpstart-$$UID-$$$$ && rm -f ~/jumpstart-$$UID-$$$$
	touch $@

$(Flag)/vscodevim:
	@set -ue
	$(Code) --install-extension vscodevim.vim
	touch $@

$(Flag)/spaceup:
	@set -ue # Spaces-specific helpers
	bash -lic '[[ -n "$$SPACEUP" ]]' && { touch $@; exit 1; } || {
		echo 'source $${HOME}/dotfiles/dot/spaceup.bashrc # Added by dotfiles/Makefile:spaceup' >> $(HOME)/.bashrc
	}
	touch $@

$(Flag)/vbase: $(Flag)/jumpstart
	@set -ue
	bash -lic 'JUMPSTART_FORCE_YES=1 jumpstart add vbase'
	bash -lic 'vi-mode.sh on'
	touch $@

$(Flag)/makestuff: $(Flag)/jumpstart
	@set -ue
	which make || { echo ERROR: make not found on PATH ; exit 1; }
	bash -lic 'complete -p | grep -q _make' && {
		touch $@
		exit 0
	} || {
		[[ -f /opt/bb/share/bash-completion/bash_completion ]] || {
			apt-get install -y bash-completion
		}
		bash -lic '[[ -n "$$BASH_COMPLETION_VERSINFO" ]]' || {
			echo 'source /opt/bb/share/bash-completion/bash_completion # Added by dotfiles/Makefile:makestuff' >> $(HOME)/.bashrc
		}
	}
	touch $@

$(Flag)/vsweb-settings:
	@set -ue # Clone user settings for working with the web edition
	set -x
	cd $(VscodeUserDir)
	[[ -d .git ]] && {
		git pull
	} || {
		mkdir tmp-$$$$
		git clone https://github.com/Stabledog/vscode.settings.git tmp-$$$$
		mv tmp-$$$$/.git ./ && rm -rf tmp-$$$$
		git checkout devx-spaces
		cd snippets || { mkdir snippets && cd snippets ; }
		git clone https://github.com/Stabledog/vscode.snippets.git ./
	}
	touch $@


clean:
	@set -ue
	[[ -d $(Flag) ]] && rm $(Flag)/* &>/dev/null || :


