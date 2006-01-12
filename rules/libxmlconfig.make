# -*-makefile-*-
# $Id: template 2922 2005-07-11 19:17:53Z rsc $
#
# Copyright (C) 2005 by Robert Schwebel
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_LIBXMLCONFIG) += libxmlconfig

#
# Paths and names
#
LIBXMLCONFIG_VERSION	= 1.0.5
LIBXMLCONFIG		= libxmlconfig-$(LIBXMLCONFIG_VERSION)
LIBXMLCONFIG_SUFFIX	= tar.bz2
LIBXMLCONFIG_URL	= http://www.pengutronix.de/software/libxmlconfig/download/$(LIBXMLCONFIG).$(LIBXMLCONFIG_SUFFIX)
LIBXMLCONFIG_SOURCE	= $(SRCDIR)/$(LIBXMLCONFIG).$(LIBXMLCONFIG_SUFFIX)
LIBXMLCONFIG_DIR	= $(BUILDDIR)/$(LIBXMLCONFIG)

-include $(call package_depfile)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

libxmlconfig_get: $(STATEDIR)/libxmlconfig.get

libxmlconfig_get_deps = $(LIBXMLCONFIG_SOURCE)

$(STATEDIR)/libxmlconfig.get: $(libxmlconfig_get_deps_default)
	@$(call targetinfo, $@)
	@$(call get_patches, $(LIBXMLCONFIG))
	@$(call touch, $@)

$(LIBXMLCONFIG_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, $(LIBXMLCONFIG_URL))

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

libxmlconfig_extract: $(STATEDIR)/libxmlconfig.extract

$(STATEDIR)/libxmlconfig.extract: $(libxmlconfig_extract_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(LIBXMLCONFIG_DIR))
	@$(call extract, $(LIBXMLCONFIG_SOURCE))
	@$(call patchin, $(LIBXMLCONFIG))
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

libxmlconfig_prepare: $(STATEDIR)/libxmlconfig.prepare

LIBXMLCONFIG_PATH	=  PATH=$(CROSS_PATH)
LIBXMLCONFIG_ENV 	=  $(CROSS_ENV)

#
# autoconf
#
LIBXMLCONFIG_AUTOCONF =  $(CROSS_AUTOCONF_USR)

$(STATEDIR)/libxmlconfig.prepare: $(libxmlconfig_prepare_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(LIBXMLCONFIG_DIR)/config.cache)
	cd $(LIBXMLCONFIG_DIR) && \
		$(LIBXMLCONFIG_PATH) $(LIBXMLCONFIG_ENV) \
		./configure $(LIBXMLCONFIG_AUTOCONF)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

libxmlconfig_compile: $(STATEDIR)/libxmlconfig.compile

$(STATEDIR)/libxmlconfig.compile: $(libxmlconfig_compile_deps_default)
	@$(call targetinfo, $@)
	cd $(LIBXMLCONFIG_DIR) && $(LIBXMLCONFIG_ENV) $(LIBXMLCONFIG_PATH) make
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

libxmlconfig_install: $(STATEDIR)/libxmlconfig.install

$(STATEDIR)/libxmlconfig.install: $(libxmlconfig_install_deps_default)
	@$(call targetinfo, $@)
	@$(call install, LIBXMLCONFIG)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

libxmlconfig_targetinstall: $(STATEDIR)/libxmlconfig.targetinstall

$(STATEDIR)/libxmlconfig.targetinstall: $(libxmlconfig_targetinstall_deps_default)
	@$(call targetinfo, $@)

	@$(call install_init,default)
	@$(call install_fixup,PACKAGE,libxmlconfig)
	@$(call install_fixup,PRIORITY,optional)
	@$(call install_fixup,VERSION,$(LIBXMLCONFIG_VERSION))
	@$(call install_fixup,SECTION,base)
	@$(call install_fixup,AUTHOR,"Robert Schwebel <r.schwebel\@pengutronix.de>")
	@$(call install_fixup,DEPENDS,)
	@$(call install_fixup,DESCRIPTION,missing)

	@$(call install_copy, 0, 0, 0644, $(LIBXMLCONFIG_DIR)/.libs/libxmlconfig.so.0.0.0, /usr/lib/libxmlconfig.so.0.0.0)
	@$(call install_link, libxmlconfig.so.0.0.0, /usr/lib/libxmlconfig.so.0)
	@$(call install_link, libxmlconfig.so.0.0.0, /usr/lib/libxmlconfig.so)

	@$(call install_finish)

	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

libxmlconfig_clean:
	rm -rf $(STATEDIR)/libxmlconfig.*
	rm -rf $(IMAGEDIR)/libxmlconfig_*
	rm -rf $(LIBXMLCONFIG_DIR)

# vim: syntax=make
