inc/vbase.mk: ;

vbase: $(Flag)/vbase
$(Flag)/vbase: $(Finit) $(Flag)/jumpstart
	@# Install shellkit vbase collection via jumpstart
	$(ISBB) && {
		bash -lic 'JUMPSTART_FORCE_YES=1 jumpstart add vbase; exit;'
	} || {
		# Fallback to public shpm:
		mkdir -p ~/tmp
		cd ~/tmp
		curl -L https://github.com/sanekits/shellkit-pm/releases/download/0.9.1/shellkit-bootstrap.sh -o ./shellkit-bootstrap.sh
		bash ./shellkit-bootstrap.sh
		{
			tmpfile=$(VHOME)/.tmp-vbase-$$$$
			cat <<-EOF > "$$tmpfile"
			set +ue
			for package in $$(shellkit-query-package.sh vbase | awk '/vbase.virtual/'); do
				[[ "$$package" == vbase.virtual ]] && continue
				$(VHOME)/.local/bin/shpm install "$$package"
			done
			exit
			EOF
		}
		bash -c "$$tmpfile"
	}
	set -ue
	$(VHOME)/.local/bin/vi-mode.sh on
	echo "jumpstart vbase added OK"
	echo 'alias d=dirs' >> $(HOME)/.cdpprc
	touch $@
