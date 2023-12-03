inc/bin-pubmk: ;

$(HOME)/bin/.git/.init:
	$(ISBB) || exit 29
	git clone https://github.com/Stabledog/bin-pub $(HOME)/bin -o ghmine
	touch $@


bin-pub: $(HOME)/bin/.git/.init
