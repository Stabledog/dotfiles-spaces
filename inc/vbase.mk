inc/vbase.mk: ;

vbase: $(Flag)/vbase
$(Flag)/vbase: $(Finit) $(Flag)/jumpstart
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
