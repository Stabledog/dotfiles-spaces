# Makefile for dotfiles-spaces
#
    #  Using ~/.dotmake:
    #  ----------------
    #    Both Devx Spaces and github Codespaces will symlink our ~/.dotmake launcher into
    #    the HOME tree.  It invokes our Makefile after first capturing the cwd to ORGDIR,
    #    and then changing to the ~/dotfiles-spaces dir.
    #
    #
	#  About app-specific init hooks:
	#  (using target 'app-setup')
	#  -----------------------------
	#
	#    The "app" is "whatever primary repos(s) were cloned by DevX Spaces/codespaces"
	#    For any git WC off the root (e.g. /*/.git exists), find the list of
	#    makefiles that we recognize as environment setup and run them.
	#
	#    We recognize all of the following:
	#       /.dotfiles.mk
	#       /dotfiles.mk
	#       /spaces-dotfiles.mk
	#       /me/.dotfiles.mk
	#       /me/dotfiles.mk
	#       /me/spaces-dotfiles.mk
	#
	#    For all such files:
	#     - we 'cd' to the dir containing the makefile first
	#     - we invoke the default target
	#     - the ordering within a dir is always [.dotfiles.mk, dotfiles.mk,spaces-dotfiles.mk]
	#     - any error in any hook aborts the entire hook sequence remaining
	#
SHELL=/bin/bash
.ONESHELL:
.SUFFIXES:
MAKEFLAGS += --no-builtin-rules --no-print-directory
absdir := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
Remake = make $(MAKEFLAGS) -f $(absdir)Makefile

# Create+include .env.mk and .metatargets.mk:
include $(absdir).env.mk
include $(absdir).metatargets.mk

VscodeUserDir = $(HOME)/.local/share/code-server/User
VscodeSettingsOrg = bbgithub:$(User)
GhPubOrg = https://github.com/Stabledog

Flag := $(HOME)/.flag-dotfiles


AppSetupHooks = $(shell \
				for xroot in $$(ls -d /*/.git 2>/dev/null | sed 's|/.git||'); do \
					for makefile in $$(ls $${xroot}{/me,}/{.dotfiles,dotfiles,spaces-dotfiles}.mk 2>/dev/null); do \
						echo $$makefile; \
					done; \
				done; \
			)


Config:
	@set -ue

	cat <<-EOF
	#  $(absdir)Makefile:
	Makefile=$(lastword $(MAKEFILE_LIST))
	Code=$(Code)
	absdir=$(absdir)
	User=$(User)
	DOTFILES_SYS=$(DOTFILES_SYS)
	GITHUB_USER=$(GITHUB_USER)
	ISBB=$(ISBB)
	VscodeSettingsOrg=$(VscodeSettingsOrg)
	VscodeUserDir=$(VscodeUserDir)
	GhPubOrg=$(GhPubOrg)
	Remake=$(Remake)
	AppSetupHooks="$(AppSetupHooks)"
	Megadeps="$(Megadeps)"
	ORGDIR="$(ORGDIR)"

	EOF

none: $(Flag)/.init

$(absdir).env.mk: $(absdir)bin/env-detect $(absdir)Makefile
	@set -ue # Environment detection comes before any conditional stuff
	$< > $@

$(absdir).metatargets.mk: $(absdir)Makefile $(absdir).env.mk
	@set -ue # metatargets like 'mega' need some conditional logic
	source $(absdir).env.mk
	{
		echo "DOTFILES_SYS=$${DOTFILES_SYS}"
		case "$${DOTFILES_SYS}" in
		 	codespaces) echo 'Megadeps = mega-codespaces' ;;
		 	devxspaces) echo 'Megadeps = mega-devxspaces' ;;
		 	wsl) echo 'Megadeps = ' ;;
			*) exit 19  # Bad DOTFILES_SYS value
		 esac
	} > $@

$(Flag)/.init:
	mkdir -p $(Flag)
	echo "$(Flag) 1" >> $(HOME)/.tox-index
	echo "$(HOME)/dotfiles" >> $(HOME)/.tox-index
	touch $@

makestuff: $(Flag)/makestuff
jumpstart: $(Flag)/jumpstart
vbase: $(Flag)/vbase
vscodevim: $(Flag)/vscodevim
spaceup: $(Flag)/spaceup
vsweb-settings: $(Flag)/vsweb-settings
app-setup: $(Flag)/app-setup
shell:
mega-devxspaces: \
	makestuff \
	vbase \
	spaceup \
	vscodevim \
	vsweb-settings \
	app-setup \
	vimsane
	@set -ue
	echo "Ok: $@"

mega-codespaces: \
	makestuff \
	vbase

mega-wsl: \
	vimsane

vimsane: $(Flag)/vimsane

$(Flag)/jumpstart: $(Flag)/.init
	@set -ue
	$(ISBB) || {
		set -x
		bash -lic '[[ -n "$$JumpstartVersion" ]]' || {
			command ln -sf $(absdir)jumpstart.bashrc $(HOME)
			echo 'source ~/jumpstart.bashrc # Added by $(absdir)Makefile:$(@F)' >> ~/.bashrc
		}
		touch $@
		exit 0
	}
	curl -k --noproxy '*' https://s3.dev.bcs.bloomberg.com/shellkit-data/jumpstart-setup-latest.sh \
		-o ~/jumpstart-$$UID-$$$$ || exit 19
	bash ~/jumpstart-$$UID-$$$$ && rm -f ~/jumpstart-$$UID-$$$$
	touch $@

$(Flag)/vscodevim:
	@set -ue
	set -x
	$(Code) --install-extension vscodevim.vim
	touch $@


$(Flag)/spaceup:
	@set -ue # Spaces-specific helpers
	set -x
	echo Making $@:
	bash -lic 'test -n "$$SPACEUP" && true || false; exit' && { touch $@; exit 0; } || {
		echo 'source $${HOME}/dotfiles/dot/spaceup.bashrc # Added by dotfiles/Makefile:spaceup' >> $(HOME)/.bashrc
	}
	touch $@

$(Flag)/vbase: $(Flag)/jumpstart
	@set -ue
	set -x
	$(ISBB) && {
		bash -lic 'JUMPSTART_FORCE_YES=1 jumpstart add vbase; exit;'
	} || {
		# Fallback to public shpm:
		mkdir -p ~/tmp
		cd ~/tmp
		curl -L https://github.com/sanekits/shellkit-pm/releases/download/0.9.1/shellkit-bootstrap.sh -o ./shellkit-bootstrap.sh
		bash ./shellkit-bootstrap.sh
		bash -lic 'JUMPSTART_FORCE_YES=1 jumpstart add vbase'
	}
	bash -lic 'vi-mode.sh on'
	echo 'alias d=dirs' >> $(HOME)/.cdpprc
	touch $@

$(Flag)/makestuff: $(Flag)/.init
	@set +ue
	which make || { echo ERROR: make not found on PATH ; exit 1; }
	source $(HOME)/.bashrc
	set -ue
	complete -p make &>/dev/null && {
		touch $@
		exit
	} || :
	bash -lic 'complete -p | grep -q _make &>/dev/null' && {
		touch $@
		exit 0
	}  || :
	CompletionSource=
	for cf_file in /opt/bb/share/bash-completion/bash_completion /usr/share/bash-completion/bash_completion ; do
		[[ -f  $$cf_file ]] && {
			CompletionSource=$$cf_file
			break
		} || :
	done
	[[ -f "$$CompletionSource" ]] || {
		apt-get install -y bash-completion
	}
	bash -lic '[[ -n "$$BASH_COMPLETION_VERSINFO" ]]' || {
		echo 'source /opt/bb/share/bash-completion/bash_completion # Added by dotfiles/Makefile:makestuff' >> $(HOME)/.bashrc
	}
	touch $@

$(Flag)/vimsane:
	@set -ue
	set -x
	mkdir -p $(HOME)/tmp
	cd $(HOME)/tmp
	[[ -d vimsane ]] || {
		git clone bbgithub:sanekits/vimsane
	}
	cd vimsane
	make setup
	touch $@

$(Flag)/vsweb-settings: $(Flag)/.init Makefile
	@set -ue # Clone user settings for working with the web edition
	set -x
	# (re)-build the vscode settings dir for user in ~/.local/share/...
	# We set up 2 remotes so Spaces can be used to manage settings reconciliation
	orgDir=$$(dirname $(VscodeUserDir))
	cd $$orgDir
	git clone -o lm4 -b devx-spaces $(VscodeSettingsOrg)/vscode.settings ./User-tmp-$$$$
	cd ./User-tmp-$$$$
	git remote add ghmine $(GhPubOrg)/vscode.settings.git

	# Also: snippets, again with 2 remotes
	[[ -d ./snippets ]] && exit 19
	git clone -o lm4 -b main $(VscodeSettingsOrg)/vscode.snippets ./snippets
	cd ./snippets
	git remote add ghmine $(GhPubOrg)/vscode.snippets.git
	cd $$orgDir
	[[ -e ./User ]] && {
		mv ./User ./User-old-$$$$
	}
	mv ./User-tmp-$$$$ ./User
	cd ./User/snippets && {
		echo "$$PWD 1" >> $(HOME)/.tox-index
	}
	cd $(absdir)
	$(Remake) $(Flag)/vsweb-colorthemes

	touch $@

$(Flag)/vsweb-colorthemes:
	@set -ue
	set -x
	$(Code) --install-extension ahmadawais.shades-of-purple
	$(Code) --install-extension catppuccin.catppuccin-vsc
	touch $@

$(Flag)/app-setup:
	@set -ue
	set -x
	[[ -n "$(AppSetupHooks)" ]] && {
		for hook in $(AppSetupHooks); do
			(
				set -ue
				echo "app-setup hook start: $$hook:" >&2
				cd $$(dirname $$hook)
				make -f $$(basename $$hook) || {
					echo "ERROR 19: failed running \"make $$hook\" in $$PWD"
					exit 1
				}
			)
		done
	}
	touch $@

mega: $(Megadeps)

shell:
	@set -ue   # Helper shell for maintaining the dotfiles repo
	cd $(absdir)
	Ps1Tail=dotshell bash

clean:
	@set -ue
	rm $(absdir).env.mk $(absdir).metatargets.mk || :
	[[ -d $(Flag) ]] && rm $(Flag)/* &>/dev/null || :


