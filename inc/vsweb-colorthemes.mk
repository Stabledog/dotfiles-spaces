inc/vsweb-colorthemes.mk: ;

vsweb-colorthemes: $(Flag)/vsweb-colorthemes
$(Flag)/vsweb-colorthemes: $(Finit) $(Flag)/vsweb-settings
	@ #  Install our favorite color themes
	$(Code) --install-extension ahmadawais.shades-of-purple
	$(Code) --install-extension catppuccin.catppuccin-vsc
	touch $@
