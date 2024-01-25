inc/github.mk: ;

github: $(Flag)/git-username $(Flag)/github-keys $(absdir).git/.ssh-remote-flag

SshDir=$(VHOME)/.ssh

$(Flag)/git-username:
	@
	set -x
	if git config --global user.email >/dev/null; then
		:
	else
		if $(ISBB); then
			git config --global user.email lmatheson4@bloomberg.net
		else
			git config --global user.email les.matheson@gmail.com
		fi
		git config --global user.name "Les Matheson"
	fi
	touch $@

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
