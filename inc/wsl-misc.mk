inc/wsl-misc.mk: ;
SHELL=/bin/bash
.ONESHELL:
.SUFFIXES:
.SHELLFLAGS = -uec
MAKEFLAGS += --no-builtin-rules --no-print-directory

absdir := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

wsl-localefix: $(Flag)/wsl-localefix
$(Flag)/wsl-localefix:
	@grep -Eq '^en_US.UTF-8' /etc/locale.gen && : || {
		echo "Need sudo password to fix locale:"
		sudo locale-gen en_US.UTF-8
	}
	touch $@
