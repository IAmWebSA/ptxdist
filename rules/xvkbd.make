# -*-makefile-*-
# $Id$
#
# Copyright (C) 2003 by Robert Schwebel <r.schwebel@pengutronix.de>
#          
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_XVKBD) += xvkbd

#
# Paths and names
#
XVKBD_VERSION		= 2.5a
XVKBD			= xvkbd-$(XVKBD_VERSION)
XVKBD_SUFFIX		= tar.gz
XVKBD_URL		= http://member.nifty.ne.jp/tsato/xvkbd/$(XVKBD).$(XVKBD_SUFFIX)
XVKBD_SOURCE		= $(SRCDIR)/$(XVKBD).$(XVKBD_SUFFIX)
XVKBD_DIR		= $(BUILDDIR)/$(XVKBD)

#include $(call package_depfile)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

xvkbd_get: $(STATEDIR)/xvkbd.get

$(STATEDIR)/xvkbd.get: $(XVKBD_SOURCE)
	@$(call targetinfo, $@)
	@$(call touch, $@)

$(XVKBD_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, $(XVKBD_URL))

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

xvkbd_extract: $(STATEDIR)/xvkbd.extract

$(STATEDIR)/xvkbd.extract: $(xvkbd_extract_deps)
	@$(call targetinfo, $@)
	@$(call clean, $(XVKBD_DIR))
	@$(call extract, $(XVKBD_SOURCE))
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

xvkbd_prepare: $(STATEDIR)/xvkbd.prepare

XVKBD_PATH	=  PATH=$(PTXCONF_PREFIX)/$(PTXCONF_GNU_TARGET)/bin:$(CROSS_PATH)
XVKBD_ENV 	=  $(CROSS_ENV)

$(STATEDIR)/xvkbd.prepare: $(xvkbd_prepare_deps_default)
	@$(call targetinfo, $@)
	cd $(XVKBD_DIR) && \
		$(XVKBD_PATH) $(XVKBD_ENV) \
		xmkmf
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

xvkbd_compile: $(STATEDIR)/xvkbd.compile

$(STATEDIR)/xvkbd.compile: $(xvkbd_compile_deps_default)
	@$(call targetinfo, $@)
	cd $(XVKBD_DIR) && $(XVKBD_PATH) $(XVKBD_ENV) make
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

xvkbd_install: $(STATEDIR)/xvkbd.install

$(STATEDIR)/xvkbd.install: $(STATEDIR)/xvkbd.compile
	@$(call targetinfo, $@)
	@$(call install, XVKBD)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

xvkbd_targetinstall: $(STATEDIR)/xvkbd.targetinstall

$(STATEDIR)/xvkbd.targetinstall: $(xvkbd_targetinstall_deps_default)
	@$(call targetinfo, $@)

	@$(call install_init,default)
	@$(call install_fixup,PACKAGE,xvkbd)
	@$(call install_fixup,PRIORITY,optional)
	@$(call install_fixup,VERSION,$(COREUTILS_VERSION))
	@$(call install_fixup,SECTION,base)
	@$(call install_fixup,AUTHOR,"Robert Schwebel <r.schwebel\@pengutronix.de>")
	@$(call install_fixup,DEPENDS,)
	@$(call install_fixup,DESCRIPTION,missing)

	@$(call install_copy, 0, 0, 0755, $(XVKBD_DIR)/xvkbd, /usr/X11R6/bin/xvkbd)
	@$(call install_copy, 0, 0, 0755, $(XVKBD_DIR)/XVkbd-common.ad, /etc/X11/app-defaults/XVkbd-common)
	@$(call install_copy, 0, 0, 0755, $(XVKBD_DIR)/XVkbd-german.ad, /etc/X11/app-defaults/XVkbd-german)
	echo '#include "XVkbd-german"' > $(ROOTDIR)/etc/X11/app-defaults/XVkbd
	# FIXME: fix permissions
	echo '#include "XVkbd-german"' > $(IMAGEIR)/ipkg/etc/X11/app-defaults/XVkbd

	@$(call install_finish)
	
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

xvkbd_clean:
	rm -rf $(STATEDIR)/xvkbd.*
	rm -rf $(IMAGEDIR)/xvkbd_*
	rm -rf $(XVKBD_DIR)

# vim: syntax=make
