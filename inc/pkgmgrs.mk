inc/pkgmgrs.mk: ;


Config: .cfg-pkgmgrs

# Environment detection is supposed to produce a PKG_MANAGERS list, and
# each entry in that list is potentially a subdir of inc/pkgmgrs  -- e.g. if PKG_MANAGERS contains
# 'apt-get', then we will try to  load inc/pkgmgrs/apt-get/*.mk:
-include $(addsuffix /*.mk, $(addprefix inc/pkgmgrs/, $(PKG_MANAGERS)))


.cfg-pkgmgrs:
	@cat <<-EOF
	#  inc/pkgmgrs.mk:
	PKG_MANAGERS="$(PKG_MANAGERS)"
	EOF
