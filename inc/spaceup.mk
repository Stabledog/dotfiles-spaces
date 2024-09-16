inc/spaceup.mk:  ;

spaceup: $(Flag)/spaceup
.PHONY: spaceup
$(Flag)/spaceup: $(Finit)
	@# Spaces-specific helper
	echo Making $@:
	bash -lic 'test -n "$$SPACEUP"' || {
		echo 'source $(absdir)dot/spaceup.bashrc # Added by inc/spaceup.mk' >> $(VHOME)/.bashrc
	}
	shpm install spaceup
	touch $@
