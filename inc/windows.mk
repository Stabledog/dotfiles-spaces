inc/windows.mk: ;

$(Flag)/windows-env.sh:
	@# Target $@
	# $(Flag)/windows-env.sh can be sourced to get linuxified paths for
	# the main Windows environment variables
	set -x
	tmpfile=$(VHOME)/.tmp-windows-env-$$$$
	which cmd.exe || exit 19
	cmd="$$(which cmd.exe)"
	cd /mnt/c
	"$$cmd" /C set | grep -E '(USERNAME|USERPROFILE|APPDATA|LOCALAPPDATA)' > $$tmpfile
	<$$tmpfile tr '\\' '/' | tr -d '\r' | sed -E -e 's,C\:,/mnt/c,' >$@

	rm $$tmpfile

$(Flag)/windows-wsl-integration:
	@# Stuff to help with hooking up shell to Windows
	[[ $(DOTFILES_SYS) == wsl ]] && {
		$(MAKE) -s $(Flag)/windows-env.sh
		source $(Flag)/windows-env.sh
		# ^^ That provides values like USERPROFILE APPDATA etc
		cd && ln -sf $${USERPROFILE} win-profile
		cd && ln -sf $${USERPROFILE}/AppData appdata
		cd && ln -sf $${USERPROFILE}/Downloads downloads

		[[ -d /mnt/d ]] || {
			echo "Provide sudo password to create /mnt/d mountpoint:"
			sudo mkdir -p /mnt/d
			echo "/mnt/d created: Ok"
		}
	}
	touch $@

Config: .cfg-windows-env
.cfg-windows-env:
	@echo '#  inc/windows.mk:'
	[[ -f $(Flag)/windows-env.sh ]] || {
		echo '#  -- not found --'
		exit 0
	}
	cat $(Flag)/windows-env.sh

