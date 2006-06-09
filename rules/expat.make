# -*-makefile-*-
# $Id$
#
# Copyright (C) 2003 by Robert Schwebel <r.schwebel@pengutronix.de>
#                       Pengutronix <info@pengutronix.de>, Germany
#          
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_EXPAT) += expat

#
# Paths and names
#
EXPAT_VERSION	:= 1.95.8
EXPAT		:= expat-$(EXPAT_VERSION)
EXPAT_SUFFIX	:= tar.gz
EXPAT_URL	:= $(PTXCONF_SETUP_SFMIRROR)/expat/$(EXPAT).$(EXPAT_SUFFIX)
EXPAT_SOURCE	:= $(SRCDIR)/$(EXPAT).$(EXPAT_SUFFIX)
EXPAT_DIR	:= $(BUILDDIR)/$(EXPAT)


# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

expat_get: $(STATEDIR)/expat.get

$(STATEDIR)/expat.get: $(expat_get_deps_default)
	@$(call targetinfo, $@)
	@$(call touch, $@)

$(EXPAT_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, EXPAT)

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

expat_extract: $(STATEDIR)/expat.extract

$(STATEDIR)/expat.extract: $(expat_extract_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(EXPAT_DIR))
	@$(call extract, EXPAT)
	@$(call patchin, EXPAT)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

expat_prepare: $(STATEDIR)/expat.prepare

EXPAT_PATH	:= PATH=$(CROSS_PATH)
EXPAT_ENV 	:= $(CROSS_ENV)

#
# autoconf
#
EXPAT_AUTOCONF  := $(CROSS_AUTOCONF_USR)

$(STATEDIR)/expat.prepare: $(expat_prepare_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(EXPAT_BUILDDIR))
	cd $(EXPAT_DIR) && \
		$(EXPAT_PATH) $(EXPAT_ENV) \
		./configure $(EXPAT_AUTOCONF)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

expat_compile: $(STATEDIR)/expat.compile

$(STATEDIR)/expat.compile: $(expat_compile_deps_default)
	@$(call targetinfo, $@)
	cd $(EXPAT_DIR) && \
		$(EXPAT_PATH) make
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

expat_install: $(STATEDIR)/expat.install

$(STATEDIR)/expat.install: $(expat_install_deps_default)
	@$(call targetinfo, $@)
	@$(call install, EXPAT)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

expat_targetinstall: $(STATEDIR)/expat.targetinstall

$(STATEDIR)/expat.targetinstall: $(expat_targetinstall_deps_default)
	@$(call targetinfo, $@)

	@$(call install_init, expat)
	@$(call install_fixup, expat,PACKAGE,expat)
	@$(call install_fixup, expat,PRIORITY,optional)
	@$(call install_fixup, expat,VERSION,$(EXPAT_VERSION))
	@$(call install_fixup, expat,SECTION,base)
	@$(call install_fixup, expat,AUTHOR,"Robert Schwebel <r.schwebel\@pengutronix.de>")
	@$(call install_fixup, expat,DEPENDS,)
	@$(call install_fixup, expat,DESCRIPTION,missing)

	@$(call install_copy, expat, 0, 0, 0644, $(EXPAT_DIR)/.libs/libexpat.so.0.5.0, /usr/lib/libexpat.so.0.5.0)
	@$(call install_link, expat, libexpat.so.0.5.0, /usr/lib/libexpat.so.0)
	@$(call install_link, expat, libexpat.so.0.5.0, /usr/lib/libexpat.so)

	@$(call install_finish, expat)

	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

expat_clean:
	rm -rf $(STATEDIR)/expat.*
	rm -rf $(IMAGEDIR)/expat_*
	rm -rf $(EXPAT_DIR)

# vim: syntax=make
