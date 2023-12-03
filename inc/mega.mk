inc/mega.mk: ;

mega-devxspaces: \
	makestuff \
	my-home \
	bin-pub \
	vbase \
	spaceup \
	vscodevim \
	vsweb-settings \
	vsweb-colorthemes \
	app-setup \
	vimsane

mega-codespaces: \
	makestuff \
	vbase
	echo "Ok: $@"

mega-wsl-bb: \
	app-setup \
	my-home \
	bin-pub \
	vimsane
	echo "Ok: $@"

mega-wsl: \
	vimsane
	echo "Ok: $@"

mega-gitbash:
	echo "Ok: $@"


mega-gitbash-bb:
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
				inner_target=mega-wsl-bb
			else
				inner_target=mega-wsl
			fi ;;

		gitbash)
			$(ISBB) && {
				inner_target=mega-gitbash-bb
			} || {
				inner_target=mega-gitbash
			} ;;
		*)
			echo "ERROR: Bad DOTFILES_SYS value: $(DOTFILES_SYS)" >&2; exit 19  ;;
	esac
	echo mega_target=$$inner_target
	#echo "mega target routes to target $$inner_target" >&2

mega: $(Flag)/mega
$(Flag)/mega: $(Finit)
	@# (Note: Git-bash chokes on something like "source <(output-of-command)", so we
	# have this ugly tmp file):
	tmpfile=$(VHOME)/mega-tmp-${@F}-out
	$(MAKE) -f $(Makefile) .mega-detect > $$tmpfile
	source $$tmpfile
	rm $$tmpfile
	$(MAKE) -f $(Makefile) $$mega_target
	touch $@


