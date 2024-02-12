inc/vscode-settings.mk: ;




$(Flag)/vscode-repo: | $(VscodeUserDir)
	@# Target $@
	# clone or update the Roaming/Code/User dir from github
	cd $(VscodeUserDir) || exit 21
	[[ -d ./.git ]] && {
		git pull
	} || {
		git clone $(VscodeSettingsOrg)/vscode.settings ~/tmp$$$$
		mv ~/tmp$$$$/.git ./
		git remote add ghmine $(GhPubOrg)/vscode.settings.git
		git checkout .
		rm -rf ~/tmp$$$$
	}
	# Let's do ./snippets also:
	mkdir -p ./snippets
	cd ./snippets
	[[ -d ./.git ]] && {
		git pull
	} || {
		git clone $(VscodeSettingsOrg)/vscode.snippets tmp$$$$
		mv tmp$$$$/.git ./
		git remote add ghmine $(GhPubOrg)/vscode.snippets.git
		git checkout .
		rm -rf tmp$$$$
	}
	echo "$$PWD 1" >> $(VHOME)/.tox-index

	touch $@

$(Flag)/vscode-settings:  \
	$(Finit) \
	$(Flag)/vscode-repo 

	touch $@


vscode-settings: $(Flag)/vscode-settings
	@# Target $@
	# Setup vscode settings in local-mode (e.g. git bash, wsl, native linux, etc)
	echo Ok: $@

