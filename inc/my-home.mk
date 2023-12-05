inc/my-home.mk: ;



$(HOME)/my-home/.git/.init:
	@if $(ISBB); then
		cd $(HOME)
		git clone bbgithub:lmatheson4/my-home -o lm4
		rm .taskrc || :
		ln -sf $(HOME)/my-home/taskrc-spaces.d .taskrc
		touch $@
	else
		exit 29
	fi

my-home: $(HOME)/my-home/.git/.init
