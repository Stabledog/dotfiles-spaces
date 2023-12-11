inc/vsweb-settings.mk: ;

vsweb-settings: $(Flag)/vsweb-settings
$(Flag)/vsweb-settings: \
	$(Finit) \
	$(Flag)/vscode-repo \
	$(Flag)/vscode-settings-branchselect
	@# Target $@:
	touch $@
