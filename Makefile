# Makefile for dotfiles-spaces
SHELL=/bin/bash
.ONESHELL:
.SUFFIXES:
MAKEFLAGS += --no-builtin-rules --no-print-directory

absdir := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

Code = $(shell which code code-server 2>/dev/null | head -n 1)

Flag := $(HOME)/.flag-dotfiles

$(Flag)/.init:
	mkdir -p $(Flag)
	touch $@

jumpstart: $(Flag)/jumpstart
vbase: $(Flag)/vbase
makestuff: $(Flag)/makestuff
vscodevim: $(Flag)/vscodevim

$(Flag)/jumpstart:
	@set -ue
	curl -k --noproxy '*' https://s3.dev.bcs.bloomberg.com/shellkit-data/jumpstart-setup-latest.sh \
		-o ~/jumpstart-$UID-$$ && bash ~/jumpstart-$UID-$$ && rm -f ~/jumpstart-$UID-$$

$(Flag)/vscodevim:
	@set -ue
	$(Code) --install-extension vscodevim.vim

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


clean:
	@set -ue
	[[ -d $(Flag) ]] && rm $(Flag)/* &>/dev/null || :


