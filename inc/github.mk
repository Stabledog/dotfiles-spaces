inc/github.mk: ;

github: $(Flag)/git-username $(Flag)/github-keys $(absdir).git/.ssh-remote-flag git-config

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

$(Flag)/gpg-nosign: $(Flag)/git-username
	@# $@
	@# Turn off commit signing default
	git config --global commit.gpgsign false
	git config --local commit.gpgsign false
	touch $@

$(Flag)/github-keys: $(SshDir)/dotfile-setup | $(SshDir)/config
	touch $@

$(SshDir)/dotfile-setup $(SshDir)/dotfile-setup.pub $(SshDir)/git-credentials: $(absdir)dot/dotfile-setup.tgz.gpg | $(SshDir)/config
	@# $@
	cd $(@D)
	gpg --ignore-mdc-error -d $< | tar xv
	touch $(SshDir)/dotfile-setup* $(SshDir)/git-credentials
	cd && ln -sf $(SshDir)/git-credentials .git-credentials

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
	git remote -v | grep -E 'ghmine ' || {
		# Add a ghmine which uses the ssh mode.  This depends on ssh having
		# the key and config that were setup in the $(SshDir)/config target
		git remote add ghmine  $(VscodeSettingsOrg)/dotfiles-spaces || :
		git fetch ghmine

		# Reset the remote binding to use ssh instead of the https that codespaces
		# created:
		current_branch_name=$$( git branch | awk '/^\* / {print $$2}' )
		git branch -u ghmine/$$current_branch_name
	}
	echo > $@
