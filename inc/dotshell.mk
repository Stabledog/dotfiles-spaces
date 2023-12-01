inc/dotshell.mk: ;

shell:
	@ # Helper shell for maintaining the dotfiles repo
	cd $(absdir)
	source <( $(MAKE) -f $(Makefile) .cfg-export )
	echo "Launching dotfiles maintenance shell:" >&2
	export Ps1Tail=dotshell
	exec /bin/bash
