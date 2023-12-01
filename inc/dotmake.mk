inc/dotmake.mk: ;

dotmake: $(Flag)/dotmake
FlagTargets += dotmake
$(Flag)/dotmake: $(Flag)/makestuff
	@# Setup autocomplete for ~/.dotmake
	set -x
	bash -lic 'complete -p | grep -E "\.dotmake"' &>/dev/null && {
		touch $@;
		exit 0
	}
	echo 'complete -F _make $(HOME)/.dotmake # Added by inc/dotmake.mk' >> $(HOME)/.bashrc
