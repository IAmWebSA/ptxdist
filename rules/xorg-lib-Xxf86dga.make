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
PACKAGES-$(PTXCONF_XORG_LIB_XXF86DGA) += xorg-lib-Xxf86dga

#
# Paths and names
#
XORG_LIB_XXF86DGA_VERSION	:= 1.0.0
XORG_LIB_XXF86DGA		:= libXxf86dga-X11R7.0-$(XORG_LIB_XXF86DGA_VERSION)
XORG_LIB_XXF86DGA_SUFFIX	:= tar.bz2
XORG_LIB_XXF86DGA_URL		:= ftp://ftp.gwdg.de/pub/x11/x.org/pub/X11R7.0/src/lib//$(XORG_LIB_XXF86DGA).$(XORG_LIB_XXF86DGA_SUFFIX)
XORG_LIB_XXF86DGA_SOURCE	:= $(SRCDIR)/$(XORG_LIB_XXF86DGA).$(XORG_LIB_XXF86DGA_SUFFIX)
XORG_LIB_XXF86DGA_DIR		:= $(BUILDDIR)/$(XORG_LIB_XXF86DGA)

-include $(call package_depfile)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

xorg-lib-Xxf86dga_get: $(STATEDIR)/xorg-lib-Xxf86dga.get

$(STATEDIR)/xorg-lib-Xxf86dga.get: $(xorg-lib-Xxf86dga_get_deps_default)
	@$(call targetinfo, $@)
	@$(call touch, $@)

$(XORG_LIB_XXF86DGA_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, $(XORG_LIB_XXF86DGA_URL))

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

xorg-lib-Xxf86dga_extract: $(STATEDIR)/xorg-lib-Xxf86dga.extract

$(STATEDIR)/xorg-lib-Xxf86dga.extract: $(xorg-lib-Xxf86dga_extract_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(XORG_LIB_XXF86DGA_DIR))
	@$(call extract, $(XORG_LIB_XXF86DGA_SOURCE))
	@$(call patchin, $(XORG_LIB_XXF86DGA))
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

xorg-lib-Xxf86dga_prepare: $(STATEDIR)/xorg-lib-Xxf86dga.prepare

XORG_LIB_XXF86DGA_PATH	:=  PATH=$(CROSS_PATH)
XORG_LIB_XXF86DGA_ENV 	:=  $(CROSS_ENV)

#
# autoconf
#
XORG_LIB_XXF86DGA_AUTOCONF := $(CROSS_AUTOCONF_USR)

$(STATEDIR)/xorg-lib-Xxf86dga.prepare: $(xorg-lib-Xxf86dga_prepare_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(XORG_LIB_XXF86DGA_DIR)/config.cache)
	cd $(XORG_LIB_XXF86DGA_DIR) && \
		$(XORG_LIB_XXF86DGA_PATH) $(XORG_LIB_XXF86DGA_ENV) \
		./configure $(XORG_LIB_XXF86DGA_AUTOCONF)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

xorg-lib-Xxf86dga_compile: $(STATEDIR)/xorg-lib-Xxf86dga.compile

$(STATEDIR)/xorg-lib-Xxf86dga.compile: $(xorg-lib-Xxf86dga_compile_deps_default)
	@$(call targetinfo, $@)
	cd $(XORG_LIB_XXF86DGA_DIR) && $(XORG_LIB_XXF86DGA_PATH) make
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

xorg-lib-Xxf86dga_install: $(STATEDIR)/xorg-lib-Xxf86dga.install

$(STATEDIR)/xorg-lib-Xxf86dga.install: $(xorg-lib-Xxf86dga_install_deps_default)
	@$(call targetinfo, $@)
	@$(call install, XORG_LIB_XXF86DGA)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

xorg-lib-Xxf86dga_targetinstall: $(STATEDIR)/xorg-lib-Xxf86dga.targetinstall

$(STATEDIR)/xorg-lib-Xxf86dga.targetinstall: $(xorg-lib-Xxf86dga_targetinstall_deps_default)
	@$(call targetinfo, $@)

	@$(call install_init,default)
	@$(call install_fixup,PACKAGE,xorg-lib-Xxf86dga)
	@$(call install_fixup,PRIORITY,optional)
	@$(call install_fixup,VERSION,$(XORG_LIB_XXF86DGA_VERSION))
	@$(call install_fixup,SECTION,base)
	@$(call install_fixup,AUTHOR,"Erwin Rol <ero\@pengutronix.de>")
	@$(call install_fixup,DEPENDS,)
	@$(call install_fixup,DESCRIPTION,missing)

# FIXME

	@$(call install_finish)

	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

xorg-lib-Xxf86dga_clean:
	rm -rf $(STATEDIR)/xorg-lib-Xxf86dga.*
	rm -rf $(IMAGEDIR)/xorg-lib-Xxf86dga_*
	rm -rf $(XORG_LIB_XXF86DGA_DIR)

# vim: syntax=make
