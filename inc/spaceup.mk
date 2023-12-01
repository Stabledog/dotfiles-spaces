inc/spaceup.mk:  ;

spaceup: $(Flag)/spaceup
.PHONY: spaceup
$(Flag)/spaceup: $(Finit)
	@# Spaces-specific helper
	echo Making $@:
	bash -lic 'test -n "$$SPACEUP" && true || false; exit' && { touch $@; exit 0; } || {
		echo 'source $${HOME}/dotfiles/dot/spaceup.bashrc # Added by inc/spaceup.mk' >> $(HOME)/.bashrc
	}
	touch $@
