inc/vsweb-settings.mk: ;

vsweb-settings: $(Flag)/vsweb-settings
$(Flag)/vsweb-settings: $(Finit)
	@# Clone user settings for working with the web edition
	# (re)-build the vscode settings dir for user in ~/.local/share/...
	# We set up 2 remotes so Spaces can be used to manage settings reconciliation
	orgDir=$$(dirname $(VscodeUserDir))
	cd $$orgDir
	git clone -o lm4 -b devx-spaces $(VscodeSettingsOrg)/vscode.settings ./User-tmp-$$$$
	cd ./User-tmp-$$$$
	git remote add ghmine $(GhPubOrg)/vscode.settings.git

	# Also: snippets, again with 2 remotes
	[[ -d ./snippets ]] && exit 19
	git clone -o lm4 -b main $(VscodeSettingsOrg)/vscode.snippets ./snippets
	cd ./snippets
	git remote add ghmine $(GhPubOrg)/vscode.snippets.git
	cd $$orgDir
	[[ -e ./User ]] && {
		mv ./User ./User-old-$$$$
	}
	mv ./User-tmp-$$$$ ./User
	cd ./User/snippets && {
		echo "$$PWD 1" >> $(HOME)/.tox-index
	}
	cd $(absdir)
	$(MAKE) -f $(Makefile) $(Flag)/vsweb-colorthemes

	touch $@
