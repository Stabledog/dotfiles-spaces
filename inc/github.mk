inc/github.mk: ;

github: $(Flag)/github-keys $(absdir).git/.ssh-remote-flag

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
	mkdir -p $(HOME)/.ssh
	chmod 700 $(HOME)/.ssh

$(absdir).git/.ssh-remote-flag: | $(absdir).git
	@# $@ We add a remote for ssh to aid maintenance on dotfiles itself
	cd $(@D)
	git remote -v | grep -E '^ghmine ' || {
		git remote add ghmine  $(VscodeSettingsOrg)/dotfiles-spaces
	}
	touch $@
