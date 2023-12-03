inc/mega.mk: ;

mega-devxspaces: \
	makestuff \
	my-home \
	vbase \
	spaceup \
	vscodevim \
	vsweb-settings \
	vsweb-colorthemes \
	app-setup \
	vimsane

mega-codespaces: \
	makestuff \
	vbase \
	echo "Ok: $@"

mega-wsl-bb: \
	app-setup \
	my-home \
	vimsane
	echo "Ok: $@"

mega-wsl: \
	vimsane
	echo "Ok: $@"

.mega-detect:
	@# Add our stuff to the metatargets.mk stuff:
	source $(absdir).env.mk
	inner_target=null
	case "$(DOTFILES_SYS)" in
		codespaces)
			inner_target=mega-codespaces ;;

		devxspaces)
			inner_target=mega-devxspaces ;;

		wsl)
			if $(ISBB); then
				inner_target=mega-wslbb
			else
				inner_target=mega-wsl
			fi ;;
		*)
			echo "ERROR: Bad DOTFILES_SYS value: $(DOTFILES_SYS)" >&2; exit 19  ;;
	esac
	echo mega_target=$$inner_target
	#echo "mega target routes to target $$inner_target" >&2

mega: $(Flag)/mega
$(Flag)/mega: $(Finit)
	@# Add our stuff to the metatargets.mk stuff:
	source <( $(MAKE) -f $(Makefile) .mega-detect )
	$(MAKE) -f $(Makefile) $$mega_target
	touch $@


