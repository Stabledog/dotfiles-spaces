inc/vscode-settings.mk: ;


$(Flag)/vscode-settings-branchselect: | $(VscodeUserDir)
	@# Target $@
	# Priority 1: if there's a branch that matches our machine name?
	set -x
	cd $(VscodeUserDir)
	host=$$(hostname 2>/dev/null | tr 'A-Z' 'a-z')
	[[ -n "$$host" ]] && {
		git checkout "$$host" && {
			touch $@
			exit 0
		} || :
	} || {
		case "$(DOTFILES_SYS)" in
			devxspaces) targetbranch=devxspaces ;;
			*) targetbranch=_reference_ ;;
		esac
		[[ -n "$$targetbranch" ]] && {
			git stash || :
			git checkout "origin/$$targetbranch"
		}
	}
	touch $@


$(Flag)/vscode-repo: | $(VscodeUserDir)
	@# Target $@
	# clone or update the Roaming/Code/User dir from github
	cd $(VscodeUserDir) || exit 21
	[[ -d ./.git ]] && {
		git pull
	} || {
		git clone $(VscodeSettingsOrg)/vscode.settings tmp$$$$
		mv tmp$$$$/.git ./
		rm -rf tmp$$$$
		git remote add ghmine $(GhPubOrg)/vscode.settings.git
	}
	# Let's do ./snippets also:
	mkdir -p ./snippets
	cd ./snippets
	[[ -d ./.git ]] && {
		git pull
	} || {
		git clone $(VscodeSettingsOrg)/vscode.snippets tmp$$$$
		mv tmp$$$$/.git ./
		rm -rf tmp$$$$
		git remote add ghmine $(GhPubOrg)/vscode.snippets.git
		git reset --hard HEAD
	}
	echo "$$PWD 1" >> $(VHOME)/.tox-index

	touch $@

$(Flag)/vscode-settings:  \
	$(Finit) \
	$(Flag)/vscode-repo \
	$(Flag)/vscode-settings-branchselect

	touch $@


vscode-settings: $(Flag)/vscode-settings
	@# Target $@
	# Setup vscode settings in local-mode (e.g. git bash, wsl, native linux, etc)
	echo Ok: $@

x:
	@set -x
	rm $(Flag)/vscode-{settings,basic} || :
	rm $(Flag)/windows-env.sh || :
	$(MAKE) -sf Makefile vscode-settings
