inc/jumpstart.mk: ;

jumpstart: $(Flag)/jumpstart
FlagTargets += jumpstart
$(Flag)/jumpstart: $(Flag)/.init
	@set -ue
	$(ISBB) || {
		set -x
		bash -lic '[[ -n "$$JumpstartVersion" ]]' || {
			command ln -sf $(absdir)jumpstart.bashrc $(HOME)
			echo 'source ~/jumpstart.bashrc # Added by $(absdir)Makefile:$(@F)' >> ~/.bashrc
		}
		touch $@
		exit 0
	}
	curl -k --noproxy '*' https://s3.dev.bcs.bloomberg.com/shellkit-data/jumpstart-setup-latest.sh \
		-o ~/jumpstart-$$UID-$$$$ || exit 19
	bash ~/jumpstart-$$UID-$$$$ && rm -f ~/jumpstart-$$UID-$$$$
	touch $@

Config: .cfg.jumpstart
.PHONY: .cfg.jumpstart
.cfg.jumpstart: .cfg.top
	@echo '#  inc/jumpstart.mk:'
	bash -lic 'echo JumpstartVersion=$${JumpstartVersion}'
