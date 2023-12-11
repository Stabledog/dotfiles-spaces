inc/vscode-settings.mk: ;

vscode-settings: $(Flag)/vscode-settings
	@# Target $@
	# Setup vscode settings in local-mode (e.g. git bash, wsl, native linux, etc)