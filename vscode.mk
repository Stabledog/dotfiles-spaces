
# Note the distinction between 'vscode' and 'vsweb' scripts:
#  1.  'vscode.mk' -->  Common to all, loads first
#  2.  'inc/vsweb-settings.mk --> Only used on Spaces, github Spaces
#  3.  'inc/vscode-settings.mk --> Only used for locally installed vscode (windows, wsl, etc)


#  The location of the VScode user settings dir is tricky: it's differerent between DevX Spaces, native WSL/Windows, and Github Codespaces.
VscodeUserDir = $(shell command ls -d  $(VHOME)/.local/share/code-server/User  $(VHOME)/win-profile/AppData/Roaming/Code/User 2>/dev/null | head -n 1 )

VscodeSettingsOrg = git@github.com:Stabledog


Config: .cfg-vscode

.cfg-vscode: | $(VscodeUserDir)
	cat <<-"EOF"
	#  vscode.mk:
	VscodeUserDir="$(VscodeUserDir)"
	VscodeSettingsOrg="$(VscodeSettingsOrg)"
	EOF


vscode.mk: ;
