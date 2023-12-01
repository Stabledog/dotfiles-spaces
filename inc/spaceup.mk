inc/spaceup.mk:  ;

spaceup: $(Flag)/spaceup
.PHONY: spaceup
FlagTargets += spaceup
$(Flag)/spaceup:
	@set -ue # Spaces-specific helpers
	echo Making $@:
	bash -lic 'test -n "$$SPACEUP" && true || false; exit' && { touch $@; exit 0; } || {
		echo 'source $${HOME}/dotfiles/dot/spaceup.bashrc # Added by dotfiles/Makefile:spaceup' >> $(HOME)/.bashrc
	}
	touch $@
