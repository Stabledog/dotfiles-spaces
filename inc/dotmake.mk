inc/dotmake.mk: ;

dotmake: $(HOME)/.dotmake $(Flag)/dotmake-autocomplete

$(Flag)/dotmake-autocomplete: $(Finit) $(Flag)/makestuff
	@# Setup autocomplete for ~/.dotmake
	set -x
	bash -lic 'complete -p' | grep -qE "\.dotmake"  && {
		touch $@;
		exit 0
	}
	echo 'complete -F _make $(HOME)/.dotmake # Added by inc/dotmake.mk' >> $(HOME)/.bashrc
	touch $@

$(HOME)/.dotmake:
	@set -x
	cd $(absdir)
	ln -sf "$(absdir).dotmake"  $(abspath $@)
