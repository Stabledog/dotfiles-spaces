inc/dotmake.mk: ;

dotmake: $(VHOME)/.dotmake $(Flag)/dotmake-autocomplete $(VHOME)/.dotfiles-spaces.d

$(Flag)/dotmake-autocomplete: $(Finit) $(Flag)/makestuff
	@# $@ Setup autocomplete for ~/.dotmake
	bash -lic 'complete -p' | grep -qE "\.dotmake"  && {
		touch $@;
		exit 0
	}
	echo 'complete -F _make $(VHOME)/.dotmake # Added by inc/dotmake.mk' >> $(VHOME)/.bashrc
	touch $@

$(VHOME)/.dotfiles-spaces.d:
	@# We want a symlink in VHOME which points to our dir for maintenance convenience.
	ln -sf $(abspath $(absdir)) $(@)

$(VHOME)/.dotmake:
	@# $@
	cd $(absdir)
	ln -sf "$(absdir).dotmake"  $(abspath $@)
