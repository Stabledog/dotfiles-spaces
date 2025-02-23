inc/my-home.mk: ;


-include $(VHOME)/my-home/dotfiles-spaces.mk
$(VHOME)/my-home/dotfiles-spaces.mk: | $(SshDir)/dotfile-setup .env.mk
	@
	pushd $(VHOME) >/dev/null
	if $(ISBB); then
		git clone bbgithub:lmatheson4/my-home -o lm4
	else
		git clone git@github.com:Stabledog/my-home
	fi
	popd >/dev/null
	# my-home/dotfiles-spaces.mk takes it further:
	[[ -f $@ ]] || exit 29
	$(MAKE)  -s my-home-setup
	touch $@

my-home: | $(VHOME)/my-home/.git
