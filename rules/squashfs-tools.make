# -*-makefile-*-
#
# Copyright (C) 2010 by Erwin Rol
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_SQUASHFS_TOOLS) += squashfs-tools

#
# Paths and names
#
SQUASHFS_TOOLS_VERSION	:= $(call ptx/ifdef, PTXCONF_HOST_SQUASHFS_TOOLS_V3X, 3.4, 4.1)
SQUASHFS_TOOLS		:= squashfs$(SQUASHFS_TOOLS_VERSION)
SQUASHFS_TOOLS_SUFFIX	:= tar.gz
SQUASHFS_TOOLS_URL	:= $(PTXCONF_SETUP_SFMIRROR)/squashfs/$(SQUASHFS_TOOLS).$(SQUASHFS_TOOLS_SUFFIX)
SQUASHFS_TOOLS_SOURCE	:= $(SRCDIR)/$(SQUASHFS_TOOLS).$(SQUASHFS_TOOLS_SUFFIX)
SQUASHFS_TOOLS_DIR	:= $(BUILDDIR)/$(SQUASHFS_TOOLS)
SQUASHFS_TOOLS_SUBDIR	:= squashfs-tools
SQUASHFS_TOOLS_LICENSE	:= unknown

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

$(SQUASHFS_TOOLS_SOURCE):
	@$(call targetinfo)
	@$(call get, SQUASHFS_TOOLS)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

SQUASHFS_TOOLS_MAKE_PAR := NO
SQUASHFS_TOOLS_MAKE_OPT := \
	$(CROSS_ENV)

SQUASHFS_TOOLS_INSTALL_OPT := \
	INSTALL_DIR="$(SQUASHFS_TOOLS_PKGDIR)/usr/sbin" \
	install

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/squashfs-tools.targetinstall:
	@$(call targetinfo)

	@$(call install_init,  squashfs-tools)
	@$(call install_fixup, squashfs-tools,PRIORITY,optional)
	@$(call install_fixup, squashfs-tools,SECTION,base)
	@$(call install_fixup, squashfs-tools,AUTHOR,"Erwin Rol")
	@$(call install_fixup, squashfs-tools,DESCRIPTION,missing)


ifdef PTXCONF_SQUASHFS_TOOLS_MKSQUASHFS
	@$(call install_copy, squashfs-tools, 0, 0, 0755, -, /usr/sbin/mksquashfs)
endif
ifdef PTXCONF_SQUASHFS_TOOLS_UNSQUASHFS
	@$(call install_copy, squashfs-tools, 0, 0, 0755, -, /usr/sbin/unsquashfs)
endif

	@$(call install_finish, squashfs-tools)

	@$(call touch)

# vim: syntax=make
