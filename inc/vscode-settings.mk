inc/vscode-settings.mk: ;


$(Flag)/vscode-basic: $(Flag)/windows-env.sh
	@# Target $@
	# clone or update the Roaming/Code/User dir from github
	source $(Flag)/windows-env.sh
	cd $${APPDATA} || exit 21
	cd ./Code/User || exit 23
	[[ -d ./.git ]] || {
		git pull
	} || {

		git clone
	}

$(Flag)/vscode-settings:  $(Finit) $(Flag)/vscode-basic


vscode-settings: $(Flag)/vscode-settings
	@# Target $@
	# Setup vscode settings in local-mode (e.g. git bash, wsl, native linux, etc)
	echo Ok: $@

x:
	@set -x
	rm $(Flag)/vscode-{settings,basic} || :
	rm $(Flag)/windows-env.sh || :
	$(MAKE) -sf Makefile vscode-settings
