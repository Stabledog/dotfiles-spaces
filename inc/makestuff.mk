inc/makestuff.mk: ;

makestuff: $(Flag)/makestuff
$(Flag)/makestuff: $(Finit)
	@# Support autocompletion for make
	bash -lic 'complete -p | grep -q _make &>/dev/null' && {
		touch $@
		exit 0
	}  || :
	CompletionSource=
	for cf_file in /opt/bb/share/bash-completion/bash_completion /usr/share/bash-completion/bash_completion ; do
		[[ -f  $$cf_file ]] && {
			CompletionSource=$$cf_file
			break
		} || :
	done
	[[ -f "$$CompletionSource" ]] || {
		apt-get install -y bash-completion
	}
	bash -lic '[[ -n "$$BASH_COMPLETION_VERSINFO" ]]' || {
		echo 'source /opt/bb/share/bash-completion/bash_completion # Added by dotfiles/Makefile:makestuff' >> $(HOME)/.bashrc
	}
	touch $@
