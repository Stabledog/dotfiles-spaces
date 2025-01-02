inc/vscode-extensions-general.mk: ;


vscode-extensions-general:  $(Flag)/vscode-extensions-general

$(Flag)/vscode-extensions-general: 
	@ # A general grab-bag of favorite extensions
	$(VscodeExtInstall) cnshenj.vscode-task-manager
	touch $@
