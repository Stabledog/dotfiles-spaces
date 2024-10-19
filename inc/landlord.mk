inc/landlord.mk: ;

landlord: $(Flag)/landlord
$(Flag)/landlord: $(Finit)
	@# Add landlord to the current env
	cd $(HOME)
	git clone bbgithub:TdocProgressMetrics/landlord
	cd landlord
	make setup
	touch $@
