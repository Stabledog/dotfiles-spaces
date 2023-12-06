inc/dotmake.mk: ;

dotmake: $(HOME)/.dotmake $(Flag)/dotmake-autocomplete $(Flag)/dotmake-homelink

$(Flag)/dotmake-autocomplete: $(Finit) $(Flag)/makestuff
	@# Setup autocomplete for ~/.dotmake
	set -x
	bash -lic 'complete -p' | grep -qE "\.dotmake"  && {
		touch $@;
		exit 0
	}
	echo 'complete -F _make $(HOME)/.dotmake # Added by inc/dotmake.mk' >> $(HOME)/.bashrc
	touch $@

$(Flag)/dotmake-homelink:
	@# We want a symlink in VHOME which points to our dir for maintenance convenience.
	# But only if that doesn't create conflicts...
	cd $(absdir)
	[[ -e $(VHOME)/dotfiles-spaces ]] || {
		ln -sf $(abspath $(absdir)) $(VHOME)/dotfiles-spaces
	}
	touch $@

$(HOME)/.dotmake:
	@set -x
	cd $(absdir)
	ln -sf "$(absdir).dotmake"  $(abspath $@)
