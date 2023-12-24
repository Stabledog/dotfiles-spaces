inc/github.mk: ;

github: $(Flag)/github-keys

SshDir=$(HOME)/.ssh


$(Flag)/github-keys: $(SshDir)/dotfile-setup | $(SshDir)/config
	touch $@

$(SshDir)/dotfile-setup $(sshDir)/dotfile-setup.pub: $(absdir)dot/dotfile-setup.tgz.gpg | $(SshDir)/config
	@# $@ 
	cd $(@D)
	gpg --ignore-mdc-error -d $< | tar xv
	touch dotfile-setup*

$(SshDir)/config:
	@# $@
	cat <<-EOF > $@
	# Added by $(absdir)inc/github.mk
	Host github.com
		User git
		IdentityFile $(SshDir)/dotfile-setup 
		IdentitiesOnly True
	EOF
