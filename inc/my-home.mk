inc/my-home.mk: ;



$(VHOME)/my-home/.git:
	cd $(VHOME)
	@if $(ISBB); then
		git clone bbgithub:lmatheson4/my-home -o lm4
		rm .taskrc || :
		ln -sf $(VHOME)/my-home/taskrc-spaces.d .taskrc
	else
		git clone git@github.com:Stabledog/my-home
	fi
	touch $@

my-home: | $(VHOME)/my-home/.git
