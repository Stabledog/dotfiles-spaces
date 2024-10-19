inc/spaceup.mk:  ;

spaceup: $(Flag)/spaceup
.PHONY: spaceup
$(Flag)/spaceup: $(Finit)
	@# Spaces-specific helper
	echo Making $@:
	bash -lic 'test -n "$$SPACEUP"' || {
		echo 'source $(absdir)dot/spaceup.bashrc # Added by inc/spaceup.mk' >> $(VHOME)/.bashrc
	}
	 curl -k --noproxy '*' https://s3.dev.bcs.bloomberg.com/shellkit-data/spaceup-setup-latest.sh \
		-o ~/bbprox-$$UID-$$$$ && bash ~/bbprox-$$UID-$$$$ && rm -f ~/bbprox-$$UID-$$$$
	touch $@
