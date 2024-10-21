inc/vscode-settings.mk: ;




$(Flag)/vscode-repo: | $(VscodeUserDir)
	@# Target $@
	# clone or update the Roaming/Code/User dir from github
	PS4=$(PS4)
	cd $(VscodeUserDir) || exit 21
	if [[ -d ./.git ]]; then
		git config core.fileMode false
		git pull
	else
		git clone $(VscodeSettingsOrg)/vscode.settings ~/tmp$$$$
		git config core.fileMode false
		mv ~/tmp$$$$/.git ./
		git remote add ghmine $(GhPubOrg)/vscode.settings.git
		git checkout .
		rm -rf ~/tmp$$$$
	fi
	echo "$$PWD 1" >> $(VHOME)/.tox-index
	# Let's do ./snippets also:
	mkdir -p ./snippets
	cd ./snippets
	[[ -d ./.git ]] && {
		git config core.fileMode false
		git pull
	else
		git clone $(VscodeSettingsOrg)/vscode.snippets tmp$$$$
		git config core.fileMode false
		mv tmp$$$$/.git ./
		git remote add ghmine $(GhPubOrg)/vscode.snippets.git
		git checkout .
		rm -rf tmp$$$$
	fi
	echo "$$PWD 1" >> $(VHOME)/.tox-index

	touch $@

vscode-devx-spaces: $(Flag)/vscode-devx-spaces
$(Flag)/vscode-devx-spaces: $(Flag)/vscode-repo
	@ # After setting up the basic vscode settings working tree,
	# we want to add our devx-spaces tweaks:
	cd $(VscodeUserDir)
	$(MAKE) -f profiles/devx-spaces/Makefile setup VscodeUserDir=$(VscodeUserDir)
	touch $@

$(Flag)/vscode-settings:  \
	$(Finit) \
	$(Flag)/vscode-repo

	touch $@


vscode-settings: $(Flag)/vscode-settings
	@# Target $@
	# Setup vscode settings in local-mode (e.g. git bash, wsl, native linux, etc)
	echo Ok: $@

