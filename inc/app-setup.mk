inc/app-setup.mk: ;

#  About app-specific init hooks:
#  (using target 'app-setup')
#  -----------------------------
#
#    The "app" is "whatever primary repos(s) comprise the development trees for
#    which this environment was constructed."
#
#    To dynamically resolve that set:
#       - Search for any git WC off the root (e.g. /*/.git exists)
#       - Find the list of makefiles that we recognize as environment setup hooks
#       - Run those hooks
#
#    We recognize all of the following (order matters):
#       /me/.dotfiles.mk
#       /me/dotfiles.mk
#       /me/spaces-dotfiles.mk
#       /.dotfiles.mk
#       /dotfiles.mk
#       /spaces-dotfiles.mk
#
#    For all such files:
#     - we 'cd' to the dir containing the makefile first
#     - we invoke the default target
#     - the ordering within a dir is always [.dotfiles.mk, dotfiles.mk,spaces-dotfiles.mk]
#     - any error in any hook aborts the entire hook sequence remaining
#

app-setup: $(Flag)/app-setup
AppSetupHooks = $(shell \
				for xroot in $$(ls -d /*/.git 2>/dev/null | sed 's|/.git||'); do \
					for makefile in $$(ls $${xroot}{/me,}/{.dotfiles,dotfiles,spaces-dotfiles}.mk 2>/dev/null); do \
						echo $$makefile; \
					done; \
				done; \
			)
$(Flag)/app-setup:
	@ # Load the application hooks for dotfiles setup:
	[[ -n "$(AppSetupHooks)" ]] && {
		for hook in $(AppSetupHooks); do
			(
				set -ue
				echo "app-setup hook start: $$hook:" >&2
				cd $$(dirname $$hook)
				make -f $$(basename $$hook) || {
					echo "ERROR 19: failed running \"make $$hook\" in $$PWD"
					exit 1
				}
			)
		done
	}
	touch $@

Config: .cfg.app-setup
.cfg.app-setup: .cfg.top
	@echo '#  inc/app-setup.mk:'
	echo 'AppSetupHooks="$(AppSetupHooks)"'
