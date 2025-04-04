# Makefile for dotfiles-spaces
#
    #  Using ~/.dotmake:
    #  ----------------
    #    Both Devx Spaces and github Codespaces will symlink our ~/.dotmake launcher into
    #    the HOME tree.  (The launcher invokes our Makefile after first capturing the cwd to ORGDIR,
    #    and then changing to the ~/dotfiles-spaces dir.)
    #
    #

SHELL=/bin/bash
.ONESHELL:
.SUFFIXES:
MAKEFLAGS += --no-builtin-rules --no-print-directory
.SHELLFLAGS= -uec
absdir := $(abspath $(dir $(realpath $(lastword $(MAKEFILE_LIST)))))/
Makefile = $(abspath $(absdir)Makefile)
Incdir := $(absdir)inc
.DEFAULT_GOAL := Config
Makefile: ;

VHOME := $(shell $(absdir)bin/get-vhome)
# ^^ Warning: don't use HOME in makefiles, as it expands badly on Windows/git-bash

Flag := $(VHOME)/.flag-dotfiles

$(absdir).env.mk $(absdir).env.sh: $(absdir)bin/env-detect $(absdir)Makefile $(Flag)/env-dirty
	@set -ue # Environment detection comes before any conditional stuff
	touch $(Flag)/env-dirty  # Any recipe can touch env-dirty to force rebuild of .env.mk
	$< > $(absdir).env.sh    # This output keeps double-quotes for use in shell recipes
	$< | tr -d '"' > $(absdir).env.mk  # This removes double-quotes for use in makefiles

# Create+include .env.mk and .metatargets.mk:
include $(absdir).env.mk          # Autogenerated on every run
PS4=$(PS4x)
# Folks who need to get in early before all parsing is done must define a pre-hook/*.mk script:
include $(shell ls pre-hook/*.mk)

VscodeExtInstall = $(absdir)bin/vscode-ext-install.sh

GhPubOrg = https://github.com/Stabledog


# Targets which touch a flag in $(Flag) should depend on $(Finit)
Finit=$(Flag)/.init
$(Flag)/.init $(Flag)/env-dirty:
	@mkdir -p $(Flag)
	echo "$(Flag) 1" >> $(VHOME)/.tox-index
	echo "$(VHOME)/dotfiles" >> $(VHOME)/.tox-index
	touch $(@D)/env-dirty
	touch $@

Config: .cfg.top

# Special handling to generalize vscode:
include $(absdir)vscode.mk


# Individual feature targets have their own makefiles:
include $(shell ls inc/*.mk)


# Top-level config:
#  (Other config targets should cite this as a dependency to get nice output ordering)
.PHONY: Config
.cfg.top: $(Finit)
	@set -ue

	cat <<-EOF
	#  $(absdir)Makefile:
	Makefile=$(Makefile)
	Code=$(Code)
	CodeOpts=$(CodeOpts)
	absdir=$(absdir)
	User=$(User)
	VHOME=$(VHOME)
	DOTFILES_SYS=$(DOTFILES_SYS)
	GITHUB_USER=$(GITHUB_USER)
	ISBB=$(ISBB)
	ISDOCKER=$(ISDOCKER)
	Flag=$(Flag)
	Flags="$(shell ls $(Flag))"
	GhPubOrg=$(GhPubOrg)
	ORGDIR="$(ORGDIR)"
	EOF

.cfg-export:
	@# Add export decl to all config values:
	$(MAKE) -f $(Makefile) Config | awk '/^[^#]+/ {print "export " $$0}'

pull:
	@cd $(absdir)
	git pull

clean: .top-clean
.top-clean:
	@ # Remove stuff to try again:
	rm $(absdir).env.{mk,sh} || :
	[[ -d $(Flag) ]] && rm $(Flag)/* &>/dev/null || :
	true


.PHONY: none
none:
	@
