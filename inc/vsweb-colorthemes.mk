inc/vsweb-colorthemes.mk: ;

vsweb-colorthemes: $(Flag)/vsweb-colorthemes
$(Flag)/vsweb-colorthemes: $(Finit) $(Flag)/vsweb-settings
	@ #  Install our favorite color themes
	$(VscodeExtInstall) ahmadawais.shades-of-purple catppuccin.catppuccin-vsc-pack
	touch $@
