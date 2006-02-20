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
PACKAGES-$(PTXCONF_XORG_LIB_XVMC) += xorg-lib-XvMC

#
# Paths and names
#
XORG_LIB_XVMC_VERSION	:= 1.0.1
XORG_LIB_XVMC		:= libXvMC-X11R7.0-$(XORG_LIB_XVMC_VERSION)
XORG_LIB_XVMC_SUFFIX	:= tar.bz2
XORG_LIB_XVMC_URL	:= ftp://ftp.gwdg.de/pub/x11/x.org/pub/X11R7.0/src/lib//$(XORG_LIB_XVMC).$(XORG_LIB_XVMC_SUFFIX)
XORG_LIB_XVMC_SOURCE	:= $(SRCDIR)/$(XORG_LIB_XVMC).$(XORG_LIB_XVMC_SUFFIX)
XORG_LIB_XVMC_DIR	:= $(BUILDDIR)/$(XORG_LIB_XVMC)

-include $(call package_depfile)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

xorg-lib-XvMC_get: $(STATEDIR)/xorg-lib-XvMC.get

$(STATEDIR)/xorg-lib-XvMC.get: $(xorg-lib-XvMC_get_deps_default)
	@$(call targetinfo, $@)
	@$(call touch, $@)

$(XORG_LIB_XVMC_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, $(XORG_LIB_XVMC_URL))

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

xorg-lib-XvMC_extract: $(STATEDIR)/xorg-lib-XvMC.extract

$(STATEDIR)/xorg-lib-XvMC.extract: $(xorg-lib-XvMC_extract_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(XORG_LIB_XVMC_DIR))
	@$(call extract, $(XORG_LIB_XVMC_SOURCE))
	@$(call patchin, $(XORG_LIB_XVMC))
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

xorg-lib-XvMC_prepare: $(STATEDIR)/xorg-lib-XvMC.prepare

XORG_LIB_XVMC_PATH	:=  PATH=$(CROSS_PATH)
XORG_LIB_XVMC_ENV 	:=  $(CROSS_ENV)

#
# autoconf
#
XORG_LIB_XVMC_AUTOCONF := $(CROSS_AUTOCONF_USR)

$(STATEDIR)/xorg-lib-XvMC.prepare: $(xorg-lib-XvMC_prepare_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(XORG_LIB_XVMC_DIR)/config.cache)
	cd $(XORG_LIB_XVMC_DIR) && \
		$(XORG_LIB_XVMC_PATH) $(XORG_LIB_XVMC_ENV) \
		./configure $(XORG_LIB_XVMC_AUTOCONF)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

xorg-lib-XvMC_compile: $(STATEDIR)/xorg-lib-XvMC.compile

$(STATEDIR)/xorg-lib-XvMC.compile: $(xorg-lib-XvMC_compile_deps_default)
	@$(call targetinfo, $@)
	cd $(XORG_LIB_XVMC_DIR) && $(XORG_LIB_XVMC_PATH) make
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

xorg-lib-XvMC_install: $(STATEDIR)/xorg-lib-XvMC.install

$(STATEDIR)/xorg-lib-XvMC.install: $(xorg-lib-XvMC_install_deps_default)
	@$(call targetinfo, $@)
	@$(call install, XORG_LIB_XVMC)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

xorg-lib-XvMC_targetinstall: $(STATEDIR)/xorg-lib-XvMC.targetinstall

$(STATEDIR)/xorg-lib-XvMC.targetinstall: $(xorg-lib-XvMC_targetinstall_deps_default)
	@$(call targetinfo, $@)

	@$(call install_init,default)
	@$(call install_fixup,PACKAGE,xorg-lib-XvMC)
	@$(call install_fixup,PRIORITY,optional)
	@$(call install_fixup,VERSION,$(XORG_LIB_XVMC_VERSION))
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

xorg-lib-XvMC_clean:
	rm -rf $(STATEDIR)/xorg-lib-XvMC.*
	rm -rf $(IMAGEDIR)/xorg-lib-XvMC_*
	rm -rf $(XORG_LIB_XVMC_DIR)

# vim: syntax=make
