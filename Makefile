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
.DEFAULT_GOAL := Config
Makefile: ;

VHOME := $(abspath $(absdir)..)
# ^^ Warning: don't use HOME in makefiles, as it expands badly on Windows/git-bash


# Create+include .env.mk and .metatargets.mk:
include $(absdir).env.mk          # Autogenerated on every run

# Folks who need to get in early before all parsing is done must define a pre-hook/*.mk script:
include $(shell ls pre-hook/*.mk)

VscodeUserDir = $(VHOME)/.local/share/code-server/User
VscodeSettingsOrg = bbgithub:$(User)
GhPubOrg = https://github.com/Stabledog

Flag := $(VHOME)/.flag-dotfiles

# Targets which touch a flag in $(Flag) should depend on $(Finit)
Finit=$(Flag)/.init
$(Flag)/.init:
	mkdir -p $(Flag)
	echo "$(Flag) 1" >> $(VHOME)/.tox-index
	echo "$(VHOME)/dotfiles" >> $(VHOME)/.tox-index
	touch $@


# Individual feature targets have their own makefiles:
include $(shell ls inc/*.mk)


# Top-level config:
#  (Other config targets should cite this as a dependency to get nice output ordering)
Config: .cfg.top
.PHONY: Config
.cfg.top: $(Finit)
	@set -ue

	cat <<-EOF
	#  $(absdir)Makefile:
	Makefile=$(Makefile)
	Code=$(Code)
	absdir=$(absdir)
	User=$(User)
	DOTFILES_SYS=$(DOTFILES_SYS)
	GITHUB_USER=$(GITHUB_USER)
	ISBB=$(ISBB)
	Flag=$(Flag)
	Flags="$(shell ls $(Flag))"
	VscodeSettingsOrg=$(VscodeSettingsOrg)
	VscodeUserDir=$(VscodeUserDir)
	GhPubOrg=$(GhPubOrg)
	ORGDIR="$(ORGDIR)"

	EOF
.cfg-export:
	@# Add export decl to all config values:
	$(MAKE) -f $(Makefile) Config | awk '/^[^#]+/ {print "export " $$0}'


$(absdir).env.mk: $(absdir)bin/env-detect $(absdir)Makefile
	@set -ue # Environment detection comes before any conditional stuff
	$< > $@



clean: .top-clean
.top-clean:
	@ # Remove stuff to try again:
	rm $(absdir).env.mk || :
	[[ -d $(Flag) ]] && rm $(Flag)/* &>/dev/null || :
	true


