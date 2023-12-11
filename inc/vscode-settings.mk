inc/vscode-settings.mk: ;


$(Flag)/vscode-repo:
	@# Target $@
	# clone or update the Roaming/Code/User dir from github
	cd $(VscodeUserDir) || exit 21
	[[ -d ./.git ]] || {
		git pull
	} || {
		git clone $(VscodeSettingsOrg)/vscode.settings tmp$$$$
		mv tmp$$$$/.git ./
		rm -rf tmp$$$$
	}
	touch $@

$(Flag)/vscode-settings:  $(Finit) $(Flag)/vscode-repo
	exit 99 # Unfinished target


vscode-settings: $(Flag)/vscode-settings
	@# Target $@
	# Setup vscode settings in local-mode (e.g. git bash, wsl, native linux, etc)
	echo Ok: $@

x:
	@set -x
	rm $(Flag)/vscode-{settings,basic} || :
	rm $(Flag)/windows-env.sh || :
	$(MAKE) -sf Makefile vscode-settings
