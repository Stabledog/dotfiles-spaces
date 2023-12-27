inc/bin-pub.mk: ;

$(VHOME)/bin/.git:
	git clone https://github.com/Stabledog/bin-pub $(VHOME)/bin -o ghmine
	touch $@


bin-pub: | $(VHOME)/bin/.git
