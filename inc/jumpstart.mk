inc/jumpstart.mk: ;

jumpstart: $(Flag)/jumpstart
$(Flag)/jumpstart: $(Finit)
	@# Install jumpstart
	$(ISBB) || {
		set -x
		bash -lic '[[ -n "$$JumpstartVersion" ]]' || {
			command ln -sf $(absdir)jumpstart.bashrc $(VHOME)
			echo 'source ~/jumpstart.bashrc # Added by $(absdir)Makefile:$(@F)' >> ~/.bashrc
		}
		touch $@
		exit 0
	}
	curl -k --noproxy '*' https://s3.dev.bcs.bloomberg.com/shellkit-data/jumpstart-setup-latest.sh \
		-o ~/jumpstart-$$UID-$$$$ || exit 19
	bash ~/jumpstart-$$UID-$$$$ && rm -f ~/jumpstart-$$UID-$$$$
	touch $@
	touch $(Flag)/env-dirty

Config: .cfg.jumpstart
.cfg.jumpstart: .cfg.top
	@echo '#  inc/jumpstart.mk:'
	bash -lic 'echo JumpstartVersion=$${JumpstartVersion}'
