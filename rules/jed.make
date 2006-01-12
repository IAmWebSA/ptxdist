# -*-makefile-*-
# $Id$
#
# Copyright (C) 2004 by BSP
#          
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_JED) += jed

#
# Paths and names
#
JED_VERSION	= 0.99-16
JED		= jed-$(JED_VERSION)
JED_SUFFIX	= tar.bz2
JED_URL		= ftp://space.mit.edu/pub/davis/jed/v0.99/$(JED).$(JED_SUFFIX)
JED_SOURCE	= $(SRCDIR)/$(JED).$(JED_SUFFIX)
JED_DIR		= $(BUILDDIR)/$(JED)

-include $(call package_depfile)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

jed_get: $(STATEDIR)/jed.get

$(STATEDIR)/jed.get: $(JED_SOURCE)
	@$(call targetinfo, $@)
	@$(call get_patches, $(JED))
	@$(call touch, $@)

$(JED_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, $(JED_URL))

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

jed_extract: $(STATEDIR)/jed.extract

$(STATEDIR)/jed.extract: $(jed_extract_deps)
	@$(call targetinfo, $@)
	@$(call clean, $(JED_DIR))
	@$(call extract, $(JED_SOURCE))
	@$(call patchin, $(JED))
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

jed_prepare: $(STATEDIR)/jed.prepare

JED_PATH	=  PATH=$(CROSS_PATH)
JED_ENV 	=  $(CROSS_ENV)

#
# autoconf
#
JED_AUTOCONF =  $(CROSS_AUTOCONF_USR) 

$(STATEDIR)/jed.prepare: $(jed_prepare_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(JED_DIR)/config.cache)
	cd $(JED_DIR) && \
		$(JED_PATH) $(JED_ENV) \
		./configure $(JED_AUTOCONF)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

jed_compile: $(STATEDIR)/jed.compile

$(STATEDIR)/jed.compile: $(jed_compile_deps_default)
	@$(call targetinfo, $@)
	cd $(JED_DIR) && $(JED_ENV) $(JED_PATH) make
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

jed_install: $(STATEDIR)/jed.install

$(STATEDIR)/jed.install: $(STATEDIR)/jed.compile
	@$(call targetinfo, $@)
	# FIXME: RSC: is it right that this is done on install? 
	@$(call install, JED)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

jed_targetinstall: $(STATEDIR)/jed.targetinstall

$(STATEDIR)/jed.targetinstall: $(jed_targetinstall_deps_default)
	@$(call targetinfo, $@)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

jed_clean:
	rm -rf $(STATEDIR)/jed.*
	rm -rf $(JED_DIR)

# vim: syntax=make
