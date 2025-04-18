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
	{
		[[ -n $DOTFILE_SETUP_PASS ]] && \
			gpg --ignore-mdc-error --batch --passphrase "${DOTFILE_SETUP_PASS}" --decrypt $< \
		||  gpg --ignore-mdc-error --decrypt $<
	} | tar xv
	touch $(SshDir)/dotfile-setup* $(SshDir)/git-credentials
	cd && ln -sf $(SshDir)/git-credentials .git-credentials

$(SshDir)/config: | $(SshDir)
	@# $@
	if grep -q dotfile-setup $@ &>/dev/null; then
		exit 0
	else
		:
	fi
	cat <<-EOF | cut -c 2- > $@
	|# Added by $(absdir)inc/github.mk
	|Host github.com
	|	User git
	|	IdentityFile $(SshDir)/dotfile-setup
	|	IdentitiesOnly True
	EOF

$(SshDir):
	@ # $@
	[[ -d $(VHOME)/.ssh ]] && exit 0
	mkdir -p $(VHOME)/.ssh
	chmod 700 $(VHOME)/.ssh

$(absdir).git/.ssh-remote-flag: | $(absdir).git
	@# $@ We add a remote for ssh to aid maintenance on dotfiles itself
	cd $(@D)
	set -x
	if git remote -v | grep -E 'ghmine'; then 
		:
	else 
		# Add a ghmine which uses the ssh mode.  This depends on ssh having
		# the key and config that were setup in the $(SshDir)/config target
		git remote add ghmine  $(VscodeSettingsOrg)/dotfiles-spaces || :
		git fetch ghmine

		# Reset the remote binding to use ssh instead of the https that codespaces
		# created:
		current_branch_name=$$( git branch | awk '/^\* / {print $$2}' )
		git branch -u ghmine/$$current_branch_name
	fi
	echo > $@

$(Flag)/gh-cli:
	@source <( $(absdir)bin/env-detect )
	case "$(PKG_MANAGERS)" in
		*apt-get*)
			apt-get install -s gh-cli &>/dev/null &&  {
				$(Sudo) apt-get install -y gh-cli
			} || {
				# If we can't apt-get it, let's try Github's magic repo
				set -x
				curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | $(Sudo) dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
				$(Sudo) chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
				echo "deb [arch=$$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
					| $(Sudo) tee /etc/apt/sources.list.d/github-cli.list > /dev/null
				$(Sudo) apt update
				$(Sudo) sudo apt install gh -y
			} || {
				# Next guess: maybe dnf can get it?
				# See also https://github.com/cli/cli/blob/trunk/docs/install_linux.md#fedora-centos-red-hat-enterprise-linux-dnf
				$(Sudo) mkdir -p /usr/share/keyrings
				$(Sudo) dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
				$(Sudo) dnf install -y --skip-broken gh --repo gh-cli
				$(Sudo) dnf install -y gh
			}
			touch $@
			;;
		*)
			exit 19  # No suitable package manager
			;;
	esac

gh-cli: $(Flag)/gh-cli

$(Flag)/gh-help: $(Flag)/gh-cli | vbase
	@# Install gh cli
	source <( $$(absdir)bin/env-detect )
	echo "STUB-gh-help:1 PKG_MANAGERS=$${PKG_MANAGERS}" >&2
	case "$${PKG_MANAGERS}" in
		*shpm*)
			bash -lic 'shpm install gh-help'
			touch $@
			;;
		*)
			exit 21  # No suitable package manager
			;;
	esac

gh-help: $(Flag)/gh-help
