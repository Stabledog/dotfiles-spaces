inc/vsweb-colorthemes.mk: ;

vsweb-colorthemes: $(Flag)/vsweb-colorthemes
$(Flag)/vsweb-colorthemes: $(Finit) $(Flag)/vsweb-settings
	@ #  Install our favorite color themes
	$(Code) $(CodeOpts) --force --install-extension ahmadawais.shades-of-purple
	$(Code) $(CodeOpts) --force --install-extension catppuccin.catppuccin-vsc-pack
	touch $@
