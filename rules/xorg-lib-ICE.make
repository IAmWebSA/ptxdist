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
PACKAGES-$(PTXCONF_XORG_LIB_ICE) += xorg-lib-ICE

#
# Paths and names
#
XORG_LIB_ICE_VERSION	:= 1.0.0
XORG_LIB_ICE		:= libICE-X11R7.0-$(XORG_LIB_ICE_VERSION)
XORG_LIB_ICE_SUFFIX	:= tar.bz2
XORG_LIB_ICE_URL	:= ftp://ftp.gwdg.de/pub/x11/x.org/pub/X11R7.0/src/lib//$(XORG_LIB_ICE).$(XORG_LIB_ICE_SUFFIX)
XORG_LIB_ICE_SOURCE	:= $(SRCDIR)/$(XORG_LIB_ICE).$(XORG_LIB_ICE_SUFFIX)
XORG_LIB_ICE_DIR	:= $(BUILDDIR)/$(XORG_LIB_ICE)

-include $(call package_depfile)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

xorg-lib-ICE_get: $(STATEDIR)/xorg-lib-ICE.get

$(STATEDIR)/xorg-lib-ICE.get: $(xorg-lib-ICE_get_deps_default)
	@$(call targetinfo, $@)
	@$(call touch, $@)

$(XORG_LIB_ICE_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, $(XORG_LIB_ICE_URL))

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

xorg-lib-ICE_extract: $(STATEDIR)/xorg-lib-ICE.extract

$(STATEDIR)/xorg-lib-ICE.extract: $(xorg-lib-ICE_extract_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(XORG_LIB_ICE_DIR))
	@$(call extract, $(XORG_LIB_ICE_SOURCE))
	@$(call patchin, $(XORG_LIB_ICE))
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

xorg-lib-ICE_prepare: $(STATEDIR)/xorg-lib-ICE.prepare

XORG_LIB_ICE_PATH	:=  PATH=$(CROSS_PATH)
XORG_LIB_ICE_ENV 	:=  $(CROSS_ENV)

#
# autoconf
#
XORG_LIB_ICE_AUTOCONF := $(CROSS_AUTOCONF_USR)

$(STATEDIR)/xorg-lib-ICE.prepare: $(xorg-lib-ICE_prepare_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(XORG_LIB_ICE_DIR)/config.cache)
	cd $(XORG_LIB_ICE_DIR) && \
		$(XORG_LIB_ICE_PATH) $(XORG_LIB_ICE_ENV) \
		./configure $(XORG_LIB_ICE_AUTOCONF)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

xorg-lib-ICE_compile: $(STATEDIR)/xorg-lib-ICE.compile

$(STATEDIR)/xorg-lib-ICE.compile: $(xorg-lib-ICE_compile_deps_default)
	@$(call targetinfo, $@)
	cd $(XORG_LIB_ICE_DIR) && $(XORG_LIB_ICE_PATH) make
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

xorg-lib-ICE_install: $(STATEDIR)/xorg-lib-ICE.install

$(STATEDIR)/xorg-lib-ICE.install: $(xorg-lib-ICE_install_deps_default)
	@$(call targetinfo, $@)
	@$(call install, XORG_LIB_ICE)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

xorg-lib-ICE_targetinstall: $(STATEDIR)/xorg-lib-ICE.targetinstall

$(STATEDIR)/xorg-lib-ICE.targetinstall: $(xorg-lib-ICE_targetinstall_deps_default)
	@$(call targetinfo, $@)

	@$(call install_init,default)
	@$(call install_fixup,PACKAGE,xorg-lib-ICE)
	@$(call install_fixup,PRIORITY,optional)
	@$(call install_fixup,VERSION,$(XORG_LIB_ICE_VERSION))
	@$(call install_fixup,SECTION,base)
	@$(call install_fixup,AUTHOR,"Erwin Rol <ero\@pengutronix.de>")
	@$(call install_fixup,DEPENDS,)
	@$(call install_fixup,DESCRIPTION,missing)

	@$(call install_copy, 0, 0, 0644, \
		$(XORG_LIB_ICE_DIR)/src/.libs/libICE.so.6.3.0, \
		$(XORG_LIBDIR)/libICE.so.6.3.0)

	@$(call install_link, \
		libICE.so.6.3.0, \
		$(XORG_LIBDIR)/libICE.so.6)

	@$(call install_link, \
		libICE.so.6.3.0, \
		$(XORG_LIBDIR)/libICE.so)

	@$(call install_finish)

	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

xorg-lib-ICE_clean:
	rm -rf $(STATEDIR)/xorg-lib-ICE.*
	rm -rf $(IMAGEDIR)/xorg-lib-ICE_*
	rm -rf $(XORG_LIB_ICE_DIR)

# vim: syntax=make
