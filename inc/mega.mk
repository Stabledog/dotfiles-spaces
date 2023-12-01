inc/mega.mk: ;

mega-devxspaces: \
	makestuff \
	vbase \
	spaceup \
	vscodevim \
	vsweb-settings \
	app-setup \
	vimsane

mega-codespaces: \
	makestuff \
	vbase
	echo "Ok: $@"

mega-wsl: \
	vimsane
	echo "Ok: $@"


mega: $(Flag)/mega
$(Flag)/mega: $(Finit)
	@# Add our stuff to the metatargets.mk stuff:
	source $(absdir).env.mk
	case "$(DOTFILES_SYS)" in
		codespaces)
			$(MAKE) -f $(Makefile) mega-codespaces ;;

		devxspaces)
			$(MAKE) -f $(Makefile) mega-devxspaces ;;

		wsl)
			$(MAKE) -f $(Makefile) mega-wsl ;;

		*)
			echo "ERROR: Bad DOTFILES_SYS value: $(DOTFILES_SYS)" >&2; exit 19  ;;
	esac
	touch $@


