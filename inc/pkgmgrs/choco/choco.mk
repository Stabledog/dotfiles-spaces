inc/pkgmgrs/choco/choco.mk: ;

Config:  .cfg-choco

ChocoVersion = $(shell choco.exe --version 2>/dev/null)
.cfg-choco:
	@cat <<-EOF
	#  inc/pkgmgrs/choco/choco.mk:
	ChocoVersion=$(ChocoVersion)
	EOF
