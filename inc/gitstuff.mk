inc/gitstuff.mk: ;

tig-setup: $(Flag)/tig-setup
$(Flag)/tig-setup: 
	@
	which tig &>/dev/null || {
		$(Sudo) apt-get install -y tig
	}
	touch $@
