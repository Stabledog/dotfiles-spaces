inc/windows.mk: ;

$(Flag)/windows-env.sh:
	@# Target $@
	# $(Flag)/windows-env.sh can be sourced to get linuxified paths for
	# the main Windows environment variable
	set -x
	tmpfile=$(HOME)/.tmp-windows-env-$$$$
	which cmd.exe || exit 19
	cmd="$$(which cmd.exe)"
	cd /mnt/c
	"$$cmd" /C set | grep -E '(USERNAME|USERPROFILE|APPDATA|LOCALAPPDATA)' > $$tmpfile
	<$$tmpfile tr '\\' '/' | tr -d '\r' | sed -E -e 's,C\:,/mnt/c,' >$@

	rm $$tmpfile

Config: .cfg-windows-env
.cfg-windows-env:
	@echo '#  inc/windows.mk:'
	[[ -f $(Flag)/windows-env.sh ]] || {
		echo '#  -- not found --'
		exit 0
	}
	cat $(Flag)/windows-env.sh

