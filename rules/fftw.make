# -*-makefile-*-
# $Id: template 6487 2006-12-07 20:55:55Z rsc $
#
# Copyright (C) 2006 by Robert Schwebel
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_FFTW) += fftw

#
# Paths and names
#
FFTW_VERSION	:= 3.2
FFTW		:= fftw-$(FFTW_VERSION)
FFTW_SUFFIX	:= tar.gz
FFTW_URL	:= http://www.fftw.org/$(FFTW).$(FFTW_SUFFIX)
FFTW_SOURCE	:= $(SRCDIR)/$(FFTW).$(FFTW_SUFFIX)
FFTW_DIR	:= $(BUILDDIR)/$(FFTW)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

$(FFTW_SOURCE):
	@$(call targetinfo)
	@$(call get, FFTW)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

FFTW_PATH	:= PATH=$(CROSS_PATH)
FFTW_ENV 	:= $(CROSS_ENV)

#
# autoconf
#
FFTW_AUTOCONF := \
	$(CROSS_AUTOCONF_USR) \
	--enable-shared

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/fftw.targetinstall:
	@$(call targetinfo)

	@$(call install_init, fftw)
	@$(call install_fixup, fftw,PACKAGE,fftw)
	@$(call install_fixup, fftw,PRIORITY,optional)
	@$(call install_fixup, fftw,VERSION,$(FFTW_VERSION))
	@$(call install_fixup, fftw,SECTION,base)
	@$(call install_fixup, fftw,AUTHOR,"Robert Schwebel <r.schwebel\@pengutronix.de>")
	@$(call install_fixup, fftw,DEPENDS,)
	@$(call install_fixup, fftw,DESCRIPTION,missing)

	@$(call install_copy, fftw, 0, 0, 0644, $(FFTW_DIR)/.libs/libfftw3.so.3.2.2, /usr/lib/libfftw3.so.3.2.2)
	@$(call install_link, fftw, libfftw3.so.3.2.2, /usr/lib/libfftw3.so.3)
	@$(call install_link, fftw, libfftw3.so.3.2.2, /usr/lib/libfftw3.so)

	@$(call install_finish, fftw)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

fftw_clean:
	rm -rf $(STATEDIR)/fftw.*
	rm -rf $(PKGDIR)/fftw_*
	rm -rf $(FFTW_DIR)

# vim: syntax=make
