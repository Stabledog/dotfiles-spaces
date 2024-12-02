inc/vscodevim.mk: ;

vscodevim: $(Flag)/vscodevim
$(Flag)/vscodevim: $(Finit)
	@# Install the vscode vim extension
	[[ -n "$(VSCODE_IPC_HOOK_CLI)" ]] || {
		echo "Unable to install vscode extensions: try again in a vscode terminal" >&2
		exit 0
	}
	$(VscodeExtInstall) vscodevim.vim
	touch $@
