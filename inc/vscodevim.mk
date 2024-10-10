inc/vscodevim.mk: ;

vscodevim: $(Flag)/vscodevim
$(Flag)/vscodevim: $(Finit)
	@# Install the vscode vim extension
	$(Code) $(CodeOpts) --install-extension vscodevim.vim
	touch $@
