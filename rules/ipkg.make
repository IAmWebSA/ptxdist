# -*-makefile-*-
# $Id: template 2224 2005-01-20 15:19:18Z rsc $
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
PACKAGES-$(PTXCONF_IPKG) += ipkg

#
# Paths and names
#
IPKG_VERSION		= 0.99.157
IPKG			= ipkg-$(IPKG_VERSION)
IPKG_SUFFIX		= tar.gz
IPKG_URL		= http://handhelds.org/download/packages/ipkg/$(IPKG).$(IPKG_SUFFIX)
IPKG_SOURCE		= $(SRCDIR)/$(IPKG).$(IPKG_SUFFIX)
IPKG_DIR		= $(BUILDDIR)/$(IPKG)

-include $(call package_depfile)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

ipkg_get: $(STATEDIR)/ipkg.get

$(STATEDIR)/ipkg.get: $(ipkg_get_deps_default)
	@$(call targetinfo, $@)
	@$(call get_patches, $(IPKG))
	@$(call touch, $@)

$(IPKG_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, $(IPKG_URL))

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

ipkg_extract: $(STATEDIR)/ipkg.extract

$(STATEDIR)/ipkg.extract: $(ipkg_extract_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(IPKG_DIR))
	@$(call extract, $(IPKG_SOURCE))
	@$(call patchin, $(IPKG))
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

ipkg_prepare: $(STATEDIR)/ipkg.prepare

IPKG_PATH	=  PATH=$(CROSS_PATH)
IPKG_ENV 	=  $(CROSS_ENV)

#
# autoconf
#
IPKG_AUTOCONF =  $(CROSS_AUTOCONF_USR)

$(STATEDIR)/ipkg.prepare: $(ipkg_prepare_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(IPKG_DIR)/config.cache)
	cd $(IPKG_DIR) && \
		$(IPKG_PATH) $(IPKG_ENV) \
		./configure $(IPKG_AUTOCONF)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

ipkg_compile: $(STATEDIR)/ipkg.compile

$(STATEDIR)/ipkg.compile: $(ipkg_compile_deps_default)
	@$(call targetinfo, $@)
	cd $(IPKG_DIR) && $(IPKG_ENV) $(IPKG_PATH) make
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

ipkg_install: $(STATEDIR)/ipkg.install

$(STATEDIR)/ipkg.install: $(ipkg_install_deps_default)
	@$(call targetinfo, $@)
	@$(call install, IPKG)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

ipkg_targetinstall: $(STATEDIR)/ipkg.targetinstall

$(STATEDIR)/ipkg.targetinstall: $(ipkg_targetinstall_deps_default)
	@$(call targetinfo, $@)

	@$(call install_init,default)
	@$(call install_fixup,PACKAGE,ipkg)
	@$(call install_fixup,PRIORITY,optional)
	@$(call install_fixup,VERSION,$(IPKG_VERSION))
	@$(call install_fixup,SECTION,base)
	@$(call install_fixup,AUTHOR,"Robert Schwebel <r.schwebel\@pengutronix.de>")
	@$(call install_fixup,DEPENDS,)
	@$(call install_fixup,DESCRIPTION,missing)

	@$(call install_copy, 0, 0, 0644, $(IPKG_DIR)/.libs/libipkg.so.0.0.0, /usr/lib/libipkg.so.0.0.0)
	@$(call install_link, libipkg.so.0.0.0, /usr/lib/libipkg.so.0.0)
	@$(call install_link, libipkg.so.0.0.0, /usr/lib/libipkg.so.0)

ifdef PTXCONF_IPKG_LOG_WRAPPER
	@$(call install_copy, 0, 0, 0755, $(IPKG_DIR)/.libs/ipkg-cl, /usr/bin/ipkg-cl)
	@$(call install_copy, 0, 0, 0755, $(PTXDIST_TOPDIR)/projects/generic/bin/ipkg_log_wrapper, /usr/bin/ipkg, n)
else
	@$(call install_copy, 0, 0, 0755, $(IPKG_DIR)/.libs/ipkg-cl, /usr/bin/ipkg)
endif

ifdef PTXCONF_IPKG_EXTRACT_TEST
	@$(call install_copy, 0, 0, 0755, $(IPKG_DIR)/ipkg_extract_test, /usr/bin/ipkg_extract_test)
endif
ifdef PTXCONF_IPKG_HASH_TEST
	@$(call install_copy, 0, 0, 0755, $(IPKG_DIR)/ipkg_hash_test, /usr/bin/ipkg_hash_test)
endif

	@$(call install_finish)

	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

ipkg_clean:
	rm -rf $(STATEDIR)/ipkg.*
	rm -rf $(IMAGEDIR)/ipkg_*
	rm -rf $(IPKG_DIR)

# vim: syntax=make
