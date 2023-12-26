inc/github.mk: ;

github: $(Flag)/github-keys

SshDir=$(VHOME)/.ssh


$(Flag)/github-keys: $(SshDir)/dotfile-setup | $(SshDir)/config
	touch $@

$(SshDir)/dotfile-setup $(sshDir)/dotfile-setup.pub: $(absdir)dot/dotfile-setup.tgz.gpg | $(SshDir)/config
	@# $@
	cd $(@D)
	gpg --ignore-mdc-error -d $< | tar xv
	touch dotfile-setup*

$(SshDir)/config: | $(SshDir)
	@# $@
	cat <<-EOF > $@
	# Added by $(absdir)inc/github.mk
	Host github.com
		User git
		IdentityFile $(SshDir)/dotfile-setup
		IdentitiesOnly True
	EOF

$(SshDir):
	@ # $@
	mkdir -p $(VHOME)/.ssh
	chmod 700 $(VHOME)/.ssh
