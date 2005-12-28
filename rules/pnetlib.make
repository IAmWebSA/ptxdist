# -*-makefile-*-
# $Id: template 3079 2005-09-02 18:09:51Z rsc $
#
# Copyright (C) 2005 by BSP
#          
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_PNETLIB) += pnetlib

#
# Paths and names
#
PNETLIB_VERSION	= 0.7.2
PNETLIB		= pnetlib-$(PNETLIB_VERSION)
PNETLIB_SUFFIX	= tar.gz
PNETLIB_URL	= http://www.southern-storm.com.au/download/$(PNETLIB).$(PNETLIB_SUFFIX)
PNETLIB_SOURCE	= $(SRCDIR)/$(PNETLIB).$(PNETLIB_SUFFIX)
PNETLIB_DIR	= $(BUILDDIR)/$(PNETLIB)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

pnetlib_get: $(STATEDIR)/pnetlib.get

pnetlib_get_deps = $(PNETLIB_SOURCE)

$(STATEDIR)/pnetlib.get: $(pnetlib_get_deps)
	@$(call targetinfo, $@)
	@$(call get_patches, $(PNETLIB))
	@$(call touch, $@)

$(PNETLIB_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, $(PNETLIB_URL))

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

pnetlib_extract: $(STATEDIR)/pnetlib.extract

pnetlib_extract_deps = $(STATEDIR)/pnetlib.get

$(STATEDIR)/pnetlib.extract: $(pnetlib_extract_deps)
	@$(call targetinfo, $@)
	@$(call clean, $(PNETLIB_DIR))
	@$(call extract, $(PNETLIB_SOURCE))
	@$(call patchin, $(PNETLIB))
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

pnetlib_prepare: $(STATEDIR)/pnetlib.prepare

#
# dependencies
#
pnetlib_prepare_deps = \
	$(STATEDIR)/pnetlib.extract \
	$(STATEDIR)/pnet.install \
	$(STATEDIR)/virtual-xchain.install

PNETLIB_PATH	=  PATH=$(CROSS_PATH)
PNETLIB_ENV 	=  $(CROSS_ENV)
PNETLIB_ENV	+= PKG_CONFIG_PATH=$(CROSS_LIB_DIR)/lib/pkgconfig

#
# autoconf
#
PNETLIB_AUTOCONF =  $(CROSS_AUTOCONF_USR)

$(STATEDIR)/pnetlib.prepare: $(pnetlib_prepare_deps)
	@$(call targetinfo, $@)
	@$(call clean, $(PNETLIB_DIR)/config.cache)
	cd $(PNETLIB_DIR) && \
		$(PNETLIB_PATH) $(PNETLIB_ENV) \
		./configure $(PNETLIB_AUTOCONF)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

pnetlib_compile: $(STATEDIR)/pnetlib.compile

pnetlib_compile_deps = $(STATEDIR)/pnetlib.prepare

$(STATEDIR)/pnetlib.compile: $(pnetlib_compile_deps)
	@$(call targetinfo, $@)
	cd $(PNETLIB_DIR) && $(PNETLIB_ENV) $(PNETLIB_PATH) make
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

pnetlib_install: $(STATEDIR)/pnetlib.install

$(STATEDIR)/pnetlib.install: $(STATEDIR)/pnetlib.compile
	@$(call targetinfo, $@)
	@$(call install, PNETLIB)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

pnetlib_targetinstall: $(STATEDIR)/pnetlib.targetinstall

pnetlib_targetinstall_deps = $(STATEDIR)/pnetlib.compile

$(STATEDIR)/pnetlib.targetinstall: $(pnetlib_targetinstall_deps)
	@$(call targetinfo, $@)

	@$(call install_init,default)
	@$(call install_fixup,PACKAGE,pnetlib)
	@$(call install_fixup,PRIORITY,optional)
	@$(call install_fixup,VERSION,$(PNETLIB_VERSION))
	@$(call install_fixup,SECTION,base)
	@$(call install_fixup,AUTHOR,"Robert Schwebel <b.spranger\@linutronix.de>")
	@$(call install_fixup,DEPENDS,)
	@$(call install_fixup,DESCRIPTION,missing)

	#@$(call install_copy, 0, 0, 0755, $(PNETLIB_DIR)/foobar, /dev/null)

	@$(call install_finish)

	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

pnetlib_clean:
	rm -rf $(STATEDIR)/pnetlib.*
	rm -rf $(IMAGEDIR)/pnetlib_*
	rm -rf $(PNETLIB_DIR)

# vim: syntax=make
