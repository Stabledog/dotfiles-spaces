inc/vsweb-colorthemes.mk: ;

vsweb-colorthemes: $(Flag)/vsweb-colorthemes
$(Flag)/vsweb-colorthemes: $(Finit) $(Flag)/vsweb-settings
	@ #  Install our favorite color themes
	$(Code) $(CodeOpts) --install-extension ahmadawais.shades-of-purple
	$(Code) $(CodeOpts) --install-extension catppuccin.catppuccin-vsc
	touch $@
