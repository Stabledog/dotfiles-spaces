inc/gitstuff.mk: ;

tig-setup: $(Flag)/tig-setup
$(Flag)/tig-setup: 
	@
	which tig &>/dev/null || {
		if which yum &>/dev/null; then
			# Because our yum repo is newer:
			$(Sudo) yum install -y tig	
		else	
			$(Sudo) apt-get install -y tig
		fi
	}
	touch $@
