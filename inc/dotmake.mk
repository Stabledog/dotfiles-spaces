inc/dotmake.mk: ;

dotmake: $(Flag)/dotmake
$(Flag)/dotmake: $(Finit) $(Flag)/makestuff
	@# Setup autocomplete for ~/.dotmake
	set -x
	bash -lic 'complete -p' | grep -qE "\.dotmake"  && {
		touch $@;
		exit 0
	}
	echo 'complete -F _make $(HOME)/.dotmake # Added by inc/dotmake.mk' >> $(HOME)/.bashrc
