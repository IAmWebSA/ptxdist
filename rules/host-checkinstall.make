# -*-makefile-*-
# $Id$
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
HOST_PACKAGES-$(PTXCONF_HOST_IMAGE_DEB) += host-checkinstall

#
# Paths and names
#
HOST_CHECKINSTALL_VERSION	= 1.6.0
HOST_CHECKINSTALL		= checkinstall-$(HOST_CHECKINSTALL_VERSION)
HOST_CHECKINSTALL_SUFFIX	= tgz
HOST_CHECKINSTALL_URL		= http://checkinstall.izto.org/files/source/$(HOST_CHECKINSTALL).$(HOST_CHECKINSTALL_SUFFIX)
HOST_CHECKINSTALL_SOURCE	= $(SRCDIR)/$(HOST_CHECKINSTALL).$(HOST_CHECKINSTALL_SUFFIX)
HOST_CHECKINSTALL_DIR		= $(HOST_BUILDDIR)/$(HOST_CHECKINSTALL)

-include $(call package_depfile)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

host-checkinstall_get: $(STATEDIR)/host-checkinstall.get

host-checkinstall_get_deps = $(HOST_CHECKINSTALL_SOURCE)

$(STATEDIR)/host-checkinstall.get: $(host-checkinstall_get_deps)
	@$(call targetinfo, $@)
	@$(call get_patches, $(HOST_CHECKINSTALL))
	@$(call touch, $@)

$(HOST_CHECKINSTALL_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, $(HOST_CHECKINSTALL_URL))

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

host-checkinstall_extract: $(STATEDIR)/host-checkinstall.extract

host-checkinstall_extract_deps = $(STATEDIR)/host-checkinstall.get

$(STATEDIR)/host-checkinstall.extract: $(host-checkinstall_extract_deps)
	@$(call targetinfo, $@)
	@$(call clean, $(HOST_CHECKINSTALL_DIR))
	@$(call extract, $(HOST_CHECKINSTALL_SOURCE), $(HOST_BUILDDIR))
	@$(call patchin, $(HOST_CHECKINSTALL), $(HOST_CHECKINSTALL_DIR))
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

host-checkinstall_prepare: $(STATEDIR)/host-checkinstall.prepare

#
# dependencies
#
host-checkinstall_prepare_deps = \
	$(STATEDIR)/host-checkinstall.extract

HOST_CHECKINSTALL_PATH	=  PATH=$(HOST_PATH)
HOST_CHECKINSTALL_ENV 	=  $(HOSTCC_ENV)

#
# autoconf
#
HOST_CHECKINSTALL_AUTOCONF =  $(HOST_AUTOCONF)

$(STATEDIR)/host-checkinstall.prepare: $(host-checkinstall_prepare_deps)
	@$(call targetinfo, $@)
#	@$(call clean, $(HOST_CHECKINSTALL_DIR)/config.cache)
#	cd $(HOST_CHECKINSTALL_DIR) && \
#		$(HOST_CHECKINSTALL_PATH) $(HOST_CHECKINSTALL_ENV) \
#		./configure $(HOST_CHECKINSTALL_AUTOCONF)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

host-checkinstall_compile: $(STATEDIR)/host-checkinstall.compile

host-checkinstall_compile_deps = $(STATEDIR)/host-checkinstall.prepare

$(STATEDIR)/host-checkinstall.compile: $(host-checkinstall_compile_deps)
	@$(call targetinfo, $@)
	cd $(HOST_CHECKINSTALL_DIR)/installwatch-* && $(HOST_CHECKINSTALL_ENV) $(HOST_CHECKINSTALL_PATH) make
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

host-checkinstall_install: $(STATEDIR)/host-checkinstall.install

host-checkinstall_install_deps = $(STATEDIR)/host-checkinstall.compile

$(STATEDIR)/host-checkinstall.install: $(host-checkinstall_install_deps)
	@$(call targetinfo, $@)
	# manual installation, make sure the directories exist
	mkdir -p $(PTXCONF_PREFIX)/lib
	mkdir -p $(PTXCONF_PREFIX)/bin
	cd $(HOST_CHECKINSTALL_DIR)/installwatch-* && make install PREFIX=$(PTXCONF_PREFIX)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

host-checkinstall_clean:
	rm -rf $(STATEDIR)/host-checkinstall.*
	rm -rf $(HOST_CHECKINSTALL_DIR)

# vim: syntax=make
