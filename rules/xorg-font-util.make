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
PACKAGES-$(PTXCONF_XORG_FONT_UTIL) += xorg-font-util

#
# Paths and names
#
XORG_FONT_UTIL_VERSION	:= 1.0.0
XORG_FONT_UTIL		:= font-util-X11R7.0-$(XORG_FONT_UTIL_VERSION)
XORG_FONT_UTIL_SUFFIX	:= tar.bz2
XORG_FONT_UTIL_URL	:= ftp://ftp.gwdg.de/pub/x11/x.org/pub/X11R7.0/src/font//$(XORG_FONT_UTIL).$(XORG_FONT_UTIL_SUFFIX)
XORG_FONT_UTIL_SOURCE	:= $(SRCDIR)/$(XORG_FONT_UTIL).$(XORG_FONT_UTIL_SUFFIX)
XORG_FONT_UTIL_DIR	:= $(BUILDDIR)/$(XORG_FONT_UTIL)

-include $(call package_depfile)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

xorg-font-util_get: $(STATEDIR)/xorg-font-util.get

$(STATEDIR)/xorg-font-util.get: $(xorg-font-util_get_deps_default)
	@$(call targetinfo, $@)
	@$(call touch, $@)

$(XORG_FONT_UTIL_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, $(XORG_FONT_UTIL_URL))

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

xorg-font-util_extract: $(STATEDIR)/xorg-font-util.extract

$(STATEDIR)/xorg-font-util.extract: $(xorg-font-util_extract_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(XORG_FONT_UTIL_DIR))
	@$(call extract, $(XORG_FONT_UTIL_SOURCE))
	@$(call patchin, $(XORG_FONT_UTIL))
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

xorg-font-util_prepare: $(STATEDIR)/xorg-font-util.prepare

XORG_FONT_UTIL_PATH	:=  PATH=$(CROSS_PATH)
XORG_FONT_UTIL_ENV 	:=  $(CROSS_ENV)

#
# autoconf
#
XORG_FONT_UTIL_AUTOCONF := $(CROSS_AUTOCONF_USR)

$(STATEDIR)/xorg-font-util.prepare: $(xorg-font-util_prepare_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(XORG_FONT_UTIL_DIR)/config.cache)
	cd $(XORG_FONT_UTIL_DIR) && \
		$(XORG_FONT_UTIL_PATH) $(XORG_FONT_UTIL_ENV) \
		./configure $(XORG_FONT_UTIL_AUTOCONF)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

xorg-font-util_compile: $(STATEDIR)/xorg-font-util.compile

$(STATEDIR)/xorg-font-util.compile: $(xorg-font-util_compile_deps_default)
	@$(call targetinfo, $@)
	cd $(XORG_FONT_UTIL_DIR) && $(XORG_FONT_UTIL_PATH) make
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

xorg-font-util_install: $(STATEDIR)/xorg-font-util.install

$(STATEDIR)/xorg-font-util.install: $(xorg-font-util_install_deps_default)
	@$(call targetinfo, $@)
	@$(call install, XORG_FONT_UTIL)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

xorg-font-util_targetinstall: $(STATEDIR)/xorg-font-util.targetinstall

$(STATEDIR)/xorg-font-util.targetinstall: $(xorg-font-util_targetinstall_deps_default)
	@$(call targetinfo, $@)

	@$(call install_init,default)
	@$(call install_fixup,PACKAGE,xorg-font-util)
	@$(call install_fixup,PRIORITY,optional)
	@$(call install_fixup,VERSION,$(XORG_FONT_UTIL_VERSION))
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

xorg-font-util_clean:
	rm -rf $(STATEDIR)/xorg-font-util.*
	rm -rf $(IMAGEDIR)/xorg-font-util_*
	rm -rf $(XORG_FONT_UTIL_DIR)

# vim: syntax=make
