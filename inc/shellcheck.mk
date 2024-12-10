inc/shellcheck.mk: ;

shellcheck:  $(Flag)/shellcheck

$(Flag)/shellcheck: /usr/local/bin/shellcheck
	@
	@ #  Install bash/shell extensions:
	[[ -n "$(VSCODE_IPC_HOOK_CLI)" ]] || {
		echo "Unable to install bash+shell extensions: try again in a vscode terminal" >&2
		exit 0
	}
	$(VscodeExtInstall) mads-hartmann.bash-ide-vscode rogalmic.bash-debug timonwong.shellcheck
	touch $@

/usr/local/bin/shellcheck: 
	@
	if [[ -x /usr/local/bin/shellcheck ]]; then
		:
	else
		cd /tmp
		ver=0.10.0
		# Note: shellcheck does not distribute .tgz, we have to repack it
		# so we're not dependent on `xz-utils`:
		tar xf $(absdir)bin/shellcheck-v$${ver}.linux.x86_64.tgz
		$(Sudo) cp shellcheck-v$${ver}/shellcheck /usr/local/bin
	fi


