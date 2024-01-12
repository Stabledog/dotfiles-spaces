inc/vbase.mk: ;

vbase: $(Flag)/vbase-l1 $(Flag)/vbase-post

$(Flag)/vbase-l1: $(Flag)/jumpstart | $(Finit)
	@# Install shellkit vbase collection via jumpstart
	mkdir -p ~/tmp
	cd ~/tmp
	set -x
	if $(ISBB); then
		bootstrap_url=https://s3.dev.bcs.bloomberg.com/shellkit-data/bb-shellkit-bootstrap.sh
	else
		bootstrap_url=https://github.com/sanekits/shellkit-pm/releases/download/0.9.1/shellkit-bootstrap.sh
	fi
	curl -k -L "$$bootstrap_url" -o ./shellkit-bootstrap.sh
	bash ./shellkit-bootstrap.sh

	tmpfile=$(VHOME)/.tmp-vbase-$$$$
	cat <<-"EOF" | cut -c 2- > "$$tmpfile"
	|set +ue
	|set -x
	|tmpfile_A=$(VHOME)/.tmp-vbase-$$$$._A
	|$(VHOME)/.local/bin/shellkit-query-package.sh vbase | tee  "$$tmpfile_A"
	|packages=( $$( awk '/vbase.virtual/' "$$tmpfile_A"  ) )
	|for package in "$${packages[@]}"; do
	|	[[ "$$package" == vbase.virtual ]] && continue
	|	$(VHOME)/.local/bin/shpm install "$$package"
	|done
	|rm "$$tmpfile_A" || :
	|exit
	EOF

	bash -x "$$tmpfile"
	rm "$$tmpfile" || :

	set -ue
	$(VHOME)/.local/bin/vi-mode.sh on
	echo "jumpstart vbase added OK"
	echo 'alias d=dirs' >> $(VHOME)/.cdpprc
	touch $@

$(Flag)/vbase-post: $(Flag)/localhist-post $(Flag)/git-fix-name
	@touch $@

$(Flag)/git-fix-name:
	@git config user.name "Les Matheson"
	touch $@

$(Flag)/localhist-post: | $(HOME)/.localhistrc
	@# $@ localhist lets us munge the host name used for archival:
	source $(HOME)/.localhistrc
	GH_URL=
	# If someone already setup .git, skip out early:
	[[ -d $${LH_ARCHIVE}/.git ]] && {
		touch $@;
		exit 0
	} || :

	case $(DOTFILES_SYS) in
		devxspaces)
			GH_URL=git@bbgithub.dev.bloomberg.com:lmatheson4/localhist-archive
			;;
		*)
	esac
	[[ -n $$GH_URL ]] && {
		bash -x $(absdir)/bin/localhist-post.sh --infer-hostname --gh-url $$GH_URL
	}
	touch $@

