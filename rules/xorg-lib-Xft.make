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
PACKAGES-$(PTXCONF_XORG_LIB_XFT) += xorg-lib-Xft

#
# Paths and names
#
XORG_LIB_XFT_VERSION	:= 2.1.8.2
XORG_LIB_XFT		:= libXft-X11R7.0-$(XORG_LIB_XFT_VERSION)
XORG_LIB_XFT_SUFFIX	:= tar.bz2
XORG_LIB_XFT_URL	:= ftp://ftp.gwdg.de/pub/x11/x.org/pub/X11R7.0/src/lib//$(XORG_LIB_XFT).$(XORG_LIB_XFT_SUFFIX)
XORG_LIB_XFT_SOURCE	:= $(SRCDIR)/$(XORG_LIB_XFT).$(XORG_LIB_XFT_SUFFIX)
XORG_LIB_XFT_DIR	:= $(BUILDDIR)/$(XORG_LIB_XFT)

-include $(call package_depfile)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

xorg-lib-Xft_get: $(STATEDIR)/xorg-lib-Xft.get

$(STATEDIR)/xorg-lib-Xft.get: $(xorg-lib-Xft_get_deps_default)
	@$(call targetinfo, $@)
	@$(call touch, $@)

$(XORG_LIB_XFT_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, $(XORG_LIB_XFT_URL))

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

xorg-lib-Xft_extract: $(STATEDIR)/xorg-lib-Xft.extract

$(STATEDIR)/xorg-lib-Xft.extract: $(xorg-lib-Xft_extract_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(XORG_LIB_XFT_DIR))
	@$(call extract, $(XORG_LIB_XFT_SOURCE))
	@$(call patchin, $(XORG_LIB_XFT))
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

xorg-lib-Xft_prepare: $(STATEDIR)/xorg-lib-Xft.prepare

XORG_LIB_XFT_PATH	:=  PATH=$(CROSS_PATH)
XORG_LIB_XFT_ENV 	:=  $(CROSS_ENV)

#
# autoconf
#
XORG_LIB_XFT_AUTOCONF := $(CROSS_AUTOCONF_USR)

$(STATEDIR)/xorg-lib-Xft.prepare: $(xorg-lib-Xft_prepare_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(XORG_LIB_XFT_DIR)/config.cache)
	cd $(XORG_LIB_XFT_DIR) && \
		$(XORG_LIB_XFT_PATH) $(XORG_LIB_XFT_ENV) \
		./configure $(XORG_LIB_XFT_AUTOCONF)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

xorg-lib-Xft_compile: $(STATEDIR)/xorg-lib-Xft.compile

$(STATEDIR)/xorg-lib-Xft.compile: $(xorg-lib-Xft_compile_deps_default)
	@$(call targetinfo, $@)
	cd $(XORG_LIB_XFT_DIR) && $(XORG_LIB_XFT_PATH) make
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

xorg-lib-Xft_install: $(STATEDIR)/xorg-lib-Xft.install

$(STATEDIR)/xorg-lib-Xft.install: $(xorg-lib-Xft_install_deps_default)
	@$(call targetinfo, $@)
	@$(call install, XORG_LIB_XFT)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

xorg-lib-Xft_targetinstall: $(STATEDIR)/xorg-lib-Xft.targetinstall

$(STATEDIR)/xorg-lib-Xft.targetinstall: $(xorg-lib-Xft_targetinstall_deps_default)
	@$(call targetinfo, $@)

	@$(call install_init,default)
	@$(call install_fixup,PACKAGE,xorg-lib-xft)
	@$(call install_fixup,PRIORITY,optional)
	@$(call install_fixup,VERSION,$(XORG_LIB_XFT_VERSION))
	@$(call install_fixup,SECTION,base)
	@$(call install_fixup,AUTHOR,"Erwin Rol <ero\@pengutronix.de>")
	@$(call install_fixup,DEPENDS,)
	@$(call install_fixup,DESCRIPTION,missing)

#FIXME

	@$(call install_finish)

	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

xorg-lib-Xft_clean:
	rm -rf $(STATEDIR)/xorg-lib-Xft.*
	rm -rf $(IMAGEDIR)/xorg-lib-Xft_*
	rm -rf $(XORG_LIB_XFT_DIR)

# vim: syntax=make
