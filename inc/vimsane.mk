inc/vimsane.mk: ;

vimsane: $(Flag)/vimsane
$(Flag)/vimsane: $(Finit)
	@ # Install vimsane config for vim
	mkdir -p $(VHOME)/tmp
	cd $(VHOME)/tmp
	[[ -d vimsane.tmp ]] && rm -rf ./vimsane.tmp
	clone_url=https://github.com/sanekits/vimsane
	git clone $$clone_url ./vimsane.tmp

	cd ./vimsane.tmp
	make setup
	cd ..
	rm -rf vimsane.tmp
	touch $@

clean-vimsane:
	@rm -rf $(Flag)/vimsane $(HOME)/.flag-vimsane $(HOME)/.{vim,viminfo,vim_mru_files,vimtmp} || :
