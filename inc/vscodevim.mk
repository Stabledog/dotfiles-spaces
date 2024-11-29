inc/vscodevim.mk: ;

vscodevim: $(Flag)/vscodevim
$(Flag)/vscodevim: $(Finit)
	@# Install the vscode vim extension
	$(VscodeExtInstall) vscodevim.vim
	touch $@
