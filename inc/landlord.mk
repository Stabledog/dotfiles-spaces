inc/landlord.mk: ;

landlord: $(Flag)/landlord
$(Flag)/landlord: $(Finit)
	@# Add landlord to the current env
	cd $(HOME)
	git clone bbgithub:TdocProgressMetrics/landlord -b bare-spaces
	cd landlord
	make setup
	touch $@
