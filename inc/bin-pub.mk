inc/bin-pub.mk: ;

$(HOME)/bin/.git/.init:
	git clone https://github.com/Stabledog/bin-pub $(HOME)/bin -o ghmine
	touch $@


bin-pub: $(HOME)/bin/.git/.init
