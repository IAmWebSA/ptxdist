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
HOST_PACKAGES-$(PTXCONF_HOST_PKG_CONFIG_WRAPPER) += host-pkg-config-wrapper

#
# Paths and names
#
HOST_PKG_CONFIG_WRAPPER_VERSION	= 1.0.0
HOST_PKG_CONFIG_WRAPPER		= pkg-config-wrapper-$(HOST_PKG_CONFIG_WRAPPER_VERSION)
HOST_PKG_CONFIG_WRAPPER_SUFFIX	= 
HOST_PKG_CONFIG_WRAPPER_DIR	= $(HOST_BUILDDIR)/$(HOST_PKG_CONFIG_WRAPPER)


# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

host-pkg-config-wrapper_get: $(STATEDIR)/host-pkg-config-wrapper.get

$(STATEDIR)/host-pkg-config-wrapper.get: $(host-pkg-config-wrapper_get_deps_default)
	@$(call targetinfo,$@,n)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

host-pkg-config-wrapper_extract: $(STATEDIR)/host-pkg-config-wrapper.extract

$(STATEDIR)/host-pkg-config-wrapper.extract: $(host-pkg-config-wrapper_extract_deps_default)
	@$(call targetinfo,$@,n)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

host-pkg-config-wrapper_prepare: $(STATEDIR)/host-pkg-config-wrapper.prepare

$(STATEDIR)/host-pkg-config-wrapper.prepare: $(host-pkg-config-wrapper_prepare_deps_default)
	@$(call targetinfo,$@,n)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

host-pkg-config-wrapper_compile: $(STATEDIR)/host-pkg-config-wrapper.compile

$(STATEDIR)/host-pkg-config-wrapper.compile: $(host-pkg-config-wrapper_compile_deps_default)
	@$(call targetinfo,$@,n)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

host-pkg-config-wrapper_install: $(STATEDIR)/host-pkg-config-wrapper.install

$(STATEDIR)/host-pkg-config-wrapper.install: $(host-pkg-config-wrapper_install_deps_default)
	@$(call targetinfo,$@,n)
	# fake a pkg-config
	mkdir -p $(PTXCONF_PREFIX)/bin
	cp $(PTXDIST_TOPDIR)/scripts/pkg-config-wrapper $(PTXCONF_PREFIX)/bin/pkg-config
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# targetinstall
# ----------------------------------------------------------------------------

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

host-pkg-config-wrapper_clean:
	rm -rf $(STATEDIR)/host-pkg-config-wrapper.*
	rm -rf $(HOST_PKG_CONFIG_WRAPPER_DIR)

# vim: syntax=make
