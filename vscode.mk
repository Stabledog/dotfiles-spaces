vscode.mk: ;

# Note the distinction between 'vscode' and 'vsweb' scripts:
#  1.  'vscode.mk' -->  Common to all, loads first
#  2.  'inc/vsweb-settings.mk --> Only used on Spaces, github Spaces
#  3.  'inc/vscode-settings.mk --> Only used for locally installed vscode (windows, wsl, etc)


#  The location of the VScode user settings dir is tricky: it's differerent between DevX Spaces, native WSL, and Github Codespaces.
#  This logic is carefully tuned to yield a reasonable result.
VscodeUserDir = $(shell command ls -d  $(VHOME)/.local/share/code-server/User  $(VHOME)/win-profile/AppData/Roaming/Code/User 2>/dev/null || echo $(HOME)/.vscode | head -n 1 )

ifeq ($(ISBB),true)
VscodeSettingsOrg = bbgithub:$(User)
else
VscodeSettingsOrg = git@github.com:Stabledog
endif


Config: .cfg-vscode

.cfg-vscode: | $(VscodeUserDir)
	@[[ -n "$(VscodeUserDir)" ]] || exit 0
	echo '#  vscode.mk:'
	echo 'VscodeUserDir=$(VscodeUserDir)'
	echo 'VscodeSettingsOrg=$(VscodeSettingsOrg)'

$(VscodeUserDir):
	@echo "vscode.mk: VscodeUserDir was missing so I added $(VscodeUserDir)" >&2
	@mkdir -p  $@