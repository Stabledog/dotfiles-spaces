inc/my-home.mk: ;



$(HOME)/my-home/.git:
	cd $(HOME)
	@if $(ISBB); then
		git clone bbgithub:lmatheson4/my-home -o lm4
		rm .taskrc || :
		ln -sf $(HOME)/my-home/taskrc-spaces.d .taskrc
	else
		git clone git@github.com:Stabledog/my-home
	fi
	touch $@
	
my-home: | $(HOME)/my-home/.git
