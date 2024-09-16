inc/docktools.mk:  ;

docktools: $(Flag)/docktools
.PHONY: docktools
$(Flag)/docktools: $(Finit)
	@# Spaces-specific helper
	echo Making $@:
	curl -L https://github.com/sanekits/docktools/releases/download/0.5.6/docktools-setup-0.5.6.sh \
		-o ~/tmp\$\$\$\$.sh && bash ~/tmp\$\$\$\$.sh && rm ~/tmp\$\$\$\$.sh
	touch $@
