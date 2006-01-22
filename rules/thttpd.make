# -*-makefile-*-
# $Id$
#
# Copyright (C) 2003 by Benedikt Spranger
#          
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_THTTPD) += thttpd

#
# Paths and names
#
THTTPD_VERSION	= 2.25b
THTTPD		= thttpd-$(THTTPD_VERSION)
THTTPD_SUFFIX	= tar.gz
THTTPD_URL	= http://www.acme.com/software/thttpd/$(THTTPD).$(THTTPD_SUFFIX)
THTTPD_SOURCE	= $(SRCDIR)/$(THTTPD).$(THTTPD_SUFFIX)
THTTPD_DIR	= $(BUILDDIR)/$(THTTPD)

-include $(call package_depfile)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

thttpd_get: $(STATEDIR)/thttpd.get

$(STATEDIR)/thttpd.get: $(thttpd_get_deps_default)
	@$(call targetinfo, $@)
	@$(call touch, $@)

$(THTTPD_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, $(THTTPD_URL))

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

thttpd_extract: $(STATEDIR)/thttpd.extract

$(STATEDIR)/thttpd.extract: $(thttpd_extract_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(THTTPD_DIR))
	@$(call extract, $(THTTPD_SOURCE))
	@$(call patchin, $(THTTPD))
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

thttpd_prepare: $(STATEDIR)/thttpd.prepare

THTTPD_PATH	=  PATH=$(CROSS_PATH)
THTTPD_ENV 	=  $(CROSS_ENV)

#
# autoconf
#
THTTPD_AUTOCONF =  $(CROSS_AUTOCONF_USR)

$(STATEDIR)/thttpd.prepare: $(thttpd_prepare_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(THTTPD_DIR)/config.cache)
	cd $(THTTPD_DIR) && \
		$(THTTPD_PATH) $(THTTPD_ENV) \
		./configure $(THTTPD_AUTOCONF)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

thttpd_compile: $(STATEDIR)/thttpd.compile

$(STATEDIR)/thttpd.compile: $(thttpd_compile_deps_default)
	@$(call targetinfo, $@)
	$(THTTPD_PATH) make -C $(THTTPD_DIR)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

thttpd_install: $(STATEDIR)/thttpd.install

$(STATEDIR)/thttpd.install: $(thttpd_install_deps_default)
	@$(call targetinfo, $@)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

thttpd_targetinstall: $(STATEDIR)/thttpd.targetinstall

$(STATEDIR)/thttpd.targetinstall: $(thttpd_targetinstall_deps_default)
	@$(call targetinfo, $@)

	@$(call install_init,default)
	@$(call install_fixup,PACKAGE,thttpd)
	@$(call install_fixup,PRIORITY,optional)
	@$(call install_fixup,VERSION,$(THTTPD_VERSION))
	@$(call install_fixup,SECTION,base)
	@$(call install_fixup,AUTHOR,"Robert Schwebel <r.schwebel\@pengutronix.de>")
	@$(call install_fixup,DEPENDS,)
	@$(call install_fixup,DESCRIPTION,missing)

	@$(call install_copy, 0, 0, 0755, $(THTTPD_DIR)/thttpd, /usr/sbin/thttpd)
ifdef PTXCONF_ROOTFS_ETC_INITD_THTTPD
ifneq ($(call remove_quotes,$(PTXCONF_ROOTFS_ETC_INITD_THTTPD_USER_FILE)),)
	@$(call install_copy, 0, 0, 0755, $(PTXCONF_ROOTFS_ETC_INITD_THTTPD_USER_FILE), /etc/init.d/thttpd, n)
else
	@$(call install_copy, 0, 0, 0755, $(PTXDIST_TOPDIR)/projects/generic/etc/init.d/thttpd, /etc/init.d/thttpd, n)
endif
endif
ifneq ($(PTXCONF_ROOTFS_ETC_INITD_THTTPD_LINK),"")
	@$(call install_copy, 0, 0, 0755, /etc/rc.d)
	@$(call install_link, ../init.d/thttpd, /etc/rc.d/$(PTXCONF_ROOTFS_ETC_INITD_THTTPD_LINK))
endif
	@$(call install_copy, 0, 0, 0755, /var/www)
	@$(call install_copy, 12, 102, 0755, $(PTXDIST_TOPDIR)/projects/generic/thttpd.html, /var/www/index.html, n)

	@$(call install_finish)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

thttpd_clean:
	rm -rf $(STATEDIR)/thttpd.*
	rm -rf $(IMAGEDIR)/thttpd_*
	rm -rf $(THTTPD_DIR)

# vim: syntax=make
