nodestuff.mk: ;

.bb-npmrc:
	@cat <<-EOF
	strict-ssl=false
	registry=http://artprod.dev.bloomberg.com/artifactory/api/npm/npm-repos
	engine-strict=true
	prefix=~/.local/
	EOF

$(Flag)/bb-npmrc: $(Finit)
	@MAKEFLAGS= make -s -f $(Makefile) .bb-npmrc > $(HOME)/.npmrc
	touch $@

bb-npmrc: $(Flag)/bb-npmrc
