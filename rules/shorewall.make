# -*-makefile-*-
# $Id$
#
# Copyright (C) 2005 by Rex Tsai <chihchun@kalug.linux.org.tw>
# Copyright (C) 2003 by Dan Kegel, Ixia Communications (http://ixiacom.com)
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_SHOREWALL) += shorewall

#
# Paths and names
#
SHOREWALL_VERSION	= 2.2.2
SHOREWALL		= shorewall-$(SHOREWALL_VERSION)
SHOREWALL_SUFFIX	= tgz
SHOREWALL_URL		= http://www.shorewall.net/pub/shorewall/2.2/$(SHOREWALL)/$(SHOREWALL).$(SHOREWALL_SUFFIX)
SHOREWALL_SOURCE	= $(SRCDIR)/$(SHOREWALL).$(SHOREWALL_SUFFIX)
SHOREWALL_DIR		= $(BUILDDIR)/$(SHOREWALL)

-include $(call package_depfile)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

shorewall_get: $(STATEDIR)/shorewall.get

$(STATEDIR)/shorewall.get: $(SHOREWALL_SOURCE)
	@$(call targetinfo, $@)
	@$(call touch, $@)

$(SHOREWALL_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, $(SHOREWALL_URL))

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

shorewall_extract: $(STATEDIR)/shorewall.extract

$(STATEDIR)/shorewall.extract: $(shorewall_extract_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(SHOREWALL_DIR))
	@$(call extract, $(SHOREWALL_SOURCE))
	@$(call patchin, $(SHOREWALL))
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

shorewall_prepare: $(STATEDIR)/shorewall.prepare

$(STATEDIR)/shorewall.prepare: $(shorewall_prepare_deps_default)
	@$(call targetinfo, $@)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

shorewall_compile: $(STATEDIR)/shorewall.compile

$(STATEDIR)/shorewall.compile: $(shorewall_compile_deps_default)
	@$(call targetinfo, $@)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

shorewall_install: $(STATEDIR)/shorewall.install

$(STATEDIR)/shorewall.install: $(shorewall_install_deps_default)
	@$(call targetinfo, $@)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

shorewall_targetinstall: $(STATEDIR)/shorewall.targetinstall

#
# create /etc/shorewall directory before installing to keep it from
# using build system's chkconfig script to install itself!
#
$(STATEDIR)/shorewall.targetinstall: $(shorewall_targetinstall_deps_default)
	@$(call targetinfo, $@)

	@$(call install_init,default)
	@$(call install_fixup,PACKAGE,shorewall)
	@$(call install_fixup,PRIORITY,optional)
	@$(call install_fixup,VERSION,$(SHOREWALL_VERSION))
	@$(call install_fixup,SECTION,base)
	@$(call install_fixup,AUTHOR,"Robert Schwebel <r.schwebel\@pengutronix.de>")
	@$(call install_fixup,DEPENDS,)
	@$(call install_fixup,DESCRIPTION,missing)
	
	@$(call install_copy, 0, 0, 0755, /etc/shorewall)
	# FIXME: do this right
	PREFIX=$(ROOTDIR) $(FAKEROOT) $(SHOREWALL_DIR)/install.sh
	PREFIX=$(IMAGEDIR)/ipkg $(FAKEROOT) $(SHOREWALL_DIR)/install.sh

	@$(call install_finish)

	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

shorewall_clean:
	rm -rf $(STATEDIR)/shorewall.*
	rm -rf $(IMAGEDIR)/shorewall_*
	rm -rf $(SHOREWALL_DIR)

# vim: syntax=make
