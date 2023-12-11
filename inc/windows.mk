inc/windows.mk: ;

$(Flag)/windows-env.sh:
	@# Target $@
	set -x
	tmpfile=$(HOME)/.tmp-windows-env-$$$$
	which cmd.exe || exit 19
	cmd="$$(which cmd.exe)"
	cd /mnt/c
	"$$cmd" /C set | grep -E '(USERNAME|USERPROFILE|APPDATA|LOCALAPPDATA)' > $$tmpfile
	<$$tmpfile tr '\\' '/' | sed -E -e 's,C\:,/mnt/c,' >$@

	rm $$tmpfile


x: $(Flag)/windows-env.sh
