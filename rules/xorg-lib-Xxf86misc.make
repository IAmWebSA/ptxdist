# -*-makefile-*-
# $Id: template 4565 2006-02-10 14:23:10Z mkl $
#
# Copyright (C) 2006 by Erwin Rol
#          
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_XORG_LIB_XXF86MISC) += xorg-lib-Xxf86misc

#
# Paths and names
#
XORG_LIB_XXF86MISC_VERSION	:= 1.0.0
XORG_LIB_XXF86MISC		:= libXxf86misc-X11R7.0-$(XORG_LIB_XXF86MISC_VERSION)
XORG_LIB_XXF86MISC_SUFFIX	:= tar.bz2
XORG_LIB_XXF86MISC_URL		:= ftp://ftp.gwdg.de/pub/x11/x.org/pub/X11R7.0/src/lib//$(XORG_LIB_XXF86MISC).$(XORG_LIB_XXF86MISC_SUFFIX)
XORG_LIB_XXF86MISC_SOURCE	:= $(SRCDIR)/$(XORG_LIB_XXF86MISC).$(XORG_LIB_XXF86MISC_SUFFIX)
XORG_LIB_XXF86MISC_DIR		:= $(BUILDDIR)/$(XORG_LIB_XXF86MISC)

-include $(call package_depfile)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

xorg-lib-Xxf86misc_get: $(STATEDIR)/xorg-lib-Xxf86misc.get

$(STATEDIR)/xorg-lib-Xxf86misc.get: $(xorg-lib-Xxf86misc_get_deps_default)
	@$(call targetinfo, $@)
	@$(call touch, $@)

$(XORG_LIB_XXF86MISC_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, XORG_LIB_XXF86MISC)

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

xorg-lib-Xxf86misc_extract: $(STATEDIR)/xorg-lib-Xxf86misc.extract

$(STATEDIR)/xorg-lib-Xxf86misc.extract: $(xorg-lib-Xxf86misc_extract_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(XORG_LIB_XXF86MISC_DIR))
	@$(call extract, XORG_LIB_XXF86MISC)
	@$(call patchin, $(XORG_LIB_XXF86MISC))
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

xorg-lib-Xxf86misc_prepare: $(STATEDIR)/xorg-lib-Xxf86misc.prepare

XORG_LIB_XXF86MISC_PATH	:=  PATH=$(CROSS_PATH)
XORG_LIB_XXF86MISC_ENV 	:=  $(CROSS_ENV)

#
# autoconf
#
XORG_LIB_XXF86MISC_AUTOCONF := $(CROSS_AUTOCONF_USR)

XORG_LIB_XXF86MISC_AUTOCONF += --disable-malloc0returnsnull

$(STATEDIR)/xorg-lib-Xxf86misc.prepare: $(xorg-lib-Xxf86misc_prepare_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(XORG_LIB_XXF86MISC_DIR)/config.cache)
	cd $(XORG_LIB_XXF86MISC_DIR) && \
		$(XORG_LIB_XXF86MISC_PATH) $(XORG_LIB_XXF86MISC_ENV) \
		./configure $(XORG_LIB_XXF86MISC_AUTOCONF)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

xorg-lib-Xxf86misc_compile: $(STATEDIR)/xorg-lib-Xxf86misc.compile

$(STATEDIR)/xorg-lib-Xxf86misc.compile: $(xorg-lib-Xxf86misc_compile_deps_default)
	@$(call targetinfo, $@)
	cd $(XORG_LIB_XXF86MISC_DIR) && $(XORG_LIB_XXF86MISC_PATH) make
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

xorg-lib-Xxf86misc_install: $(STATEDIR)/xorg-lib-Xxf86misc.install

$(STATEDIR)/xorg-lib-Xxf86misc.install: $(xorg-lib-Xxf86misc_install_deps_default)
	@$(call targetinfo, $@)
	@$(call install, XORG_LIB_XXF86MISC)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

xorg-lib-Xxf86misc_targetinstall: $(STATEDIR)/xorg-lib-Xxf86misc.targetinstall

$(STATEDIR)/xorg-lib-Xxf86misc.targetinstall: $(xorg-lib-Xxf86misc_targetinstall_deps_default)
	@$(call targetinfo, $@)

	@$(call install_init, xorg-lib-Xxf86misc)
	@$(call install_fixup, xorg-lib-Xxf86misc,PACKAGE,xorg-lib-xxf86misc)
	@$(call install_fixup, xorg-lib-Xxf86misc,PRIORITY,optional)
	@$(call install_fixup, xorg-lib-Xxf86misc,VERSION,$(XORG_LIB_XXF86MISC_VERSION))
	@$(call install_fixup, xorg-lib-Xxf86misc,SECTION,base)
	@$(call install_fixup, xorg-lib-Xxf86misc,AUTHOR,"Erwin Rol <ero\@pengutronix.de>")
	@$(call install_fixup, xorg-lib-Xxf86misc,DEPENDS,)
	@$(call install_fixup, xorg-lib-Xxf86misc,DESCRIPTION,missing)

	@$(call install_copy, xorg-lib-Xxf86misc, 0, 0, 0644, \
		$(XORG_LIB_XXF86MISC_DIR)/src/.libs/libXxf86misc.so.1.1.0, \
		$(XORG_LIBDIR)/libXxf86misc.so.1.1.0)

	@$(call install_link, xorg-lib-Xxf86misc, \
		libXxf86misc.so.1.1.0, \
		$(XORG_LIBDIR)/libXxf86misc.so.1)

	@$(call install_link, xorg-lib-Xxf86misc, \
		libXxf86misc.so.1.1.0, \
		$(XORG_LIBDIR)/libXxf86misc.so)

	@$(call install_finish, xorg-lib-Xxf86misc)

	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

xorg-lib-Xxf86misc_clean:
	rm -rf $(STATEDIR)/xorg-lib-Xxf86misc.*
	rm -rf $(IMAGEDIR)/xorg-lib-Xxf86misc_*
	rm -rf $(XORG_LIB_XXF86MISC_DIR)

# vim: syntax=make
