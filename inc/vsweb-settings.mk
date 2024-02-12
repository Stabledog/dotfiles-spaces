inc/vsweb-settings.mk: ;

vsweb-settings: $(Flag)/vsweb-settings
$(Flag)/vsweb-settings: \
	$(Finit) \
	$(Flag)/vscode-repo 
	@# Target $@:
	touch $@
