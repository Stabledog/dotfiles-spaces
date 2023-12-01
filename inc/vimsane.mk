inc/vimsane.mk: ;

vimsane: $(Flag)/vimsane
$(Flag)/vimsane: $(Finit)
	@ # Install vimsane config for vim
	mkdir -p $(HOME)/tmp
	cd $(HOME)/tmp
	[[ -d vimsane ]] || {
		git clone bbgithub:sanekits/vimsane
	}
	cd vimsane
	make setup
	cd ..
	rm -rf vimsane
	touch $@
