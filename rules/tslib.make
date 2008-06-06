# -*-makefile-*-
# $Id: template 6655 2007-01-02 12:55:21Z rsc $
#
# Copyright (C) 2005 by Sascha Hauer
#               2007-2008 by Marc Kleine-Budde <mkl@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_TSLIB) += tslib

#
# Paths and names
#
TSLIB_VERSION	:= 1.0
TSLIB		:= tslib-$(TSLIB_VERSION)
TSLIB_SUFFIX	:= tar.bz2
TSLIB_URL	:= http://www.pengutronix.de/software/ptxdist/temporary-src/$(TSLIB).$(TSLIB_SUFFIX)
TSLIB_SOURCE	:= $(SRCDIR)/$(TSLIB).$(TSLIB_SUFFIX)
TSLIB_DIR	:= $(BUILDDIR)/$(TSLIB)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

$(TSLIB_SOURCE):
	@$(call targetinfo)
	@$(call get, TSLIB)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

tslib_prepare: $(STATEDIR)/tslib.prepare

TSLIB_PATH	:= PATH=$(CROSS_PATH)
TSLIB_ENV 	:= $(CROSS_ENV)

#
# autoconf
#
TSLIB_AUTOCONF := $(CROSS_AUTOCONF_USR)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/tslib.targetinstall:
	@$(call targetinfo)

	@$(call install_init, tslib)
	@$(call install_fixup, tslib,PACKAGE,tslib)
	@$(call install_fixup, tslib,PRIORITY,optional)
	@$(call install_fixup, tslib,VERSION,$(TSLIB_VERSION))
	@$(call install_fixup, tslib,SECTION,base)
	@$(call install_fixup, tslib,AUTHOR,"Robert Schwebel <r.schwebel\@pengutronix.de>")
	@$(call install_fixup, tslib,DEPENDS,)
	@$(call install_fixup, tslib,DESCRIPTION,missing)

	@$(call install_copy, tslib, 0, 0, 0755, $(TSLIB_DIR)/src/.libs/libts-0.0.so.0.1.1, /usr/lib/libts-0.0.so.0.1.1)
	@$(call install_link, tslib, libts-0.0.so.0.1.1, /usr/lib/libts.so)
	@$(call install_link, tslib, libts-0.0.so.0.1.1, /usr/lib/libts-0.0.so.0)

ifdef PTXCONF_TSLIB_TS_CALIBRATE
	@$(call install_copy, tslib, 0, 0, 0755, $(TSLIB_DIR)/tests/ts_calibrate, /usr/bin/ts_calibrate)
endif
ifdef PTXCONF_TSLIB_TS_TEST
	@$(call install_copy, tslib, 0, 0, 0755, $(TSLIB_DIR)/tests/ts_test, /usr/bin/ts_test)
endif

	@$(call install_copy, tslib, 0, 0, 0755, $(TSLIB_DIR)/plugins/.libs/input.so, /usr/lib/ts/input.so)
	@$(call install_copy, tslib, 0, 0, 0755, $(TSLIB_DIR)/plugins/.libs/pthres.so, /usr/lib/ts/pthres.so)
	@$(call install_copy, tslib, 0, 0, 0755, $(TSLIB_DIR)/plugins/.libs/variance.so, /usr/lib/ts/variance.so)
	@$(call install_copy, tslib, 0, 0, 0755, $(TSLIB_DIR)/plugins/.libs/dejitter.so, /usr/lib/ts/dejitter.so)
	@$(call install_copy, tslib, 0, 0, 0755, $(TSLIB_DIR)/plugins/.libs/linear.so, /usr/lib/ts/linear.so)

	@$(call install_finish, tslib)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

tslib_clean:
	rm -rf $(STATEDIR)/tslib.*
	rm -rf $(PKGDIR)/tslib_*
	rm -rf $(TSLIB_DIR)

# vim: syntax=make
