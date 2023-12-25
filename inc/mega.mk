inc/mega.mk: ;

XspacesCommonDeps = \
	makestuff \
	my-home \
	bin-pub \
	vbase \
	spaceup  \
	vscodevim 
	
mega-devxspaces: \
	bb-npmrc \
	$(XspacesCommonDeps) \
	vsweb-settings \
	vsweb-colorthemes \
	app-setup \
	vimsane

mega-codespaces: \
	$(XspacesCommonDeps) 
	echo "Ok: $@"

mega-wsl-bb: \
	app-setup \
	my-home \
	bin-pub \
	vimsane
	echo "Ok: $@"

mega-wsl-bb-docker:  \
	app-setup \
	vbase
	echo "Ok: $@"

mega-wsl: \
	vimsane \
	vscode-sttings
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
			fi
			$(ISDOCKER) && {
				inner_target=$${inner_target}-docker
			}
			;;


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


mega: $(Flag)/mega
$(Flag)/mega: $(Finit)
	@# Note: Git-bash chokes on something like "source <(output-of-command)", so we
	# have this ugly hack instead:
	tmpfile=$(HOME)/.tmp-mega-env
	MAKEFLAGS= make -s -f $(Makefile) .mega-detect > $$tmpfile
	echo "sourcing $$tmpfile:" >&2
	source $$tmpfile
	$(MAKE) -f $(Makefile) $$mega_target
	rm $$tmpfile
	touch $@
