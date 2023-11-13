# Makefile for dotfiles-spaces
SHELL=/bin/bash
.ONESHELL:
.SUFFIXES:
MAKEFLAGS += --no-builtin-rules --no-print-directory

absdir := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

Code = $(shell which code code-server 2>/dev/null | head -n 1)
User := $(shell whoami)

VscodeUserDir = $(HOME)/.local/share/code-server/User
VscodeSettingsOrg = bbgithub:$(User)

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

$(Flag)/jumpstart: $(Flag)/.init
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


$(Flag)/vsweb-settings: Makefile
	@set -ue # Clone user settings for working with the web edition
	set -x
	orgDir=$$(dirname $(VscodeUserDir))
	cd $$orgDir
	git clone -b devx-spaces $(VscodeSettingsOrg)/vscode.settings ./User-tmp-$$$$
	cd ./User-tmp-$$$$
	[[ -d ./snippets ]] && exit 19
	git clone -b main $(VscodeSettingsOrg)/vscode.snippets ./snippets
	cd $$orgDir
	[[ -e ./User ]] && {
		mv ./User ./User-old-$$$$
	}
	mv ./User-tmp-$$$$ ./User
	
	touch $@


clean:
	@set -ue
	[[ -d $(Flag) ]] && rm $(Flag)/* &>/dev/null || :


