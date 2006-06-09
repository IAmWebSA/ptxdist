# -*-makefile-*-
# $Id: template 3079 2005-09-02 18:09:51Z rsc $
#
# Copyright (C) 2005 Pengutronix, Marc Kleine-Budde <mkl@pengutronix.de>
#          
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_LIBGSLOOP) += libgsloop

#
# Paths and names
#
LIBGSLOOP_VERSION	= 0.0.6
LIBGSLOOP		= libgsloop-$(LIBGSLOOP_VERSION)
LIBGSLOOP_SUFFIX	= tar.bz2
LIBGSLOOP_URL		= http://www.pengutronix.de/software/libgsloop/download/$(LIBGSLOOP).$(LIBGSLOOP_SUFFIX)
LIBGSLOOP_SOURCE	= $(SRCDIR)/$(LIBGSLOOP).$(LIBGSLOOP_SUFFIX)
LIBGSLOOP_DIR		= $(BUILDDIR)/$(LIBGSLOOP)


# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

libgsloop_get: $(STATEDIR)/libgsloop.get

$(STATEDIR)/libgsloop.get: $(libgsloop_get_deps_default)
	@$(call targetinfo, $@)
	@$(call touch, $@)

$(LIBGSLOOP_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, LIBGSLOOP)

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

libgsloop_extract: $(STATEDIR)/libgsloop.extract

$(STATEDIR)/libgsloop.extract: $(libgsloop_extract_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(LIBGSLOOP_DIR))
	@$(call extract, LIBGSLOOP)
	@$(call patchin, LIBGSLOOP)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

libgsloop_prepare: $(STATEDIR)/libgsloop.prepare

LIBGSLOOP_PATH	=  PATH=$(CROSS_PATH)
LIBGSLOOP_ENV 	=  $(CROSS_ENV)

#
# autoconf
#
LIBGSLOOP_AUTOCONF =  $(CROSS_AUTOCONF_USR)

$(STATEDIR)/libgsloop.prepare: $(libgsloop_prepare_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(LIBGSLOOP_DIR)/config.cache)
	cd $(LIBGSLOOP_DIR) && \
		$(LIBGSLOOP_PATH) $(LIBGSLOOP_ENV) \
		./configure $(LIBGSLOOP_AUTOCONF)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

libgsloop_compile: $(STATEDIR)/libgsloop.compile

$(STATEDIR)/libgsloop.compile: $(libgsloop_compile_deps_default)
	@$(call targetinfo, $@)
	cd $(LIBGSLOOP_DIR) && $(LIBGSLOOP_ENV) $(LIBGSLOOP_PATH) make
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

libgsloop_install: $(STATEDIR)/libgsloop.install

$(STATEDIR)/libgsloop.install: $(libgsloop_install_deps_default)
	@$(call targetinfo, $@)
	@$(call install, LIBGSLOOP)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

libgsloop_targetinstall: $(STATEDIR)/libgsloop.targetinstall

$(STATEDIR)/libgsloop.targetinstall: $(libgsloop_targetinstall_deps_default)
	@$(call targetinfo, $@)

	@$(call install_init, libgsloop)
	@$(call install_fixup, libgsloop,PACKAGE,libgsloop)
	@$(call install_fixup, libgsloop,PRIORITY,optional)
	@$(call install_fixup, libgsloop,VERSION,$(LIBGSLOOP_VERSION))
	@$(call install_fixup, libgsloop,SECTION,base)
	@$(call install_fixup, libgsloop,AUTHOR,"Robert Schwebel <r.schwebel\@pengutronix.de>")
	@$(call install_fixup, libgsloop,DEPENDS,)
	@$(call install_fixup, libgsloop,DESCRIPTION,missing)

	@$(call install_copy, libgsloop, 0, 0, 0644, $(LIBGSLOOP_DIR)/src/.libs/libgsloop.so.1.1.0, /usr/lib/libgsloop.so.1.1.0)
	@$(call install_link, libgsloop, libgsloop.so.1.1.0, /usr/lib/libgsloop.so.1)
	@$(call install_link, libgsloop, libgsloop.so.1.1.0, /usr/lib/libgsloop.so)

	@$(call install_finish, libgsloop)

	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

libgsloop_clean:
	rm -rf $(STATEDIR)/libgsloop.*
	rm -rf $(IMAGEDIR)/libgsloop_*
	rm -rf $(LIBGSLOOP_DIR)

# vim: syntax=make
