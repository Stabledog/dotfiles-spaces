inc/vimsane.mk: ;

vimsane: $(Flag)/vimsane
$(Flag)/vimsane: $(Finit)
	@ # Install vimsane config for vim
	mkdir -p $(VHOME)/tmp
	cd $(VHOME)/tmp
	[[ -d vimsane.tmp ]] && rm -rf ./vimsane.tmp
	clone_url=https://github.com/sanekits/vimsane
	$(ISBB) && clone_url=bbgithub:sanekits/vimsane
	git clone $$clone_url ./vimsane.tmp

	cd ./vimsane.tmp
	make setup
	cd ..
	rm -rf vimsane.tmp
	touch $@
