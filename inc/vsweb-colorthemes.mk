inc/vsweb-colorthemes.mk: ;

vsweb-colorthemes: $(Flag)/vsweb-colorthemes
$(Flag)/vsweb-colorthemes: $(Finit) $(Flag)/vsweb-settings
	@ #  Install our favorite color themes
	[[ -n "$(VSCODE_IPC_HOOK_CLI)" ]] || {
		echo "Unable to install vscode extensions: try again in a vscode terminal" >&2
		exit 0
	}
	$(VscodeExtInstall) ahmadawais.shades-of-purple catppuccin.catppuccin-vsc-pack
	touch $@
