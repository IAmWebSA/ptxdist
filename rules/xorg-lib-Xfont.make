# -*-makefile-*-
# $Id: template 4565 2006-02-10 14:23:10Z mkl $
#
# Copyright (C) 2006 by Erwin Rol
#          
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_XORG_LIB_XFONT) += xorg-lib-Xfont

#
# Paths and names
#
XORG_LIB_XFONT_VERSION	:= 1.0.0
XORG_LIB_XFONT		:= libXfont-X11R7.0-$(XORG_LIB_XFONT_VERSION)
XORG_LIB_XFONT_SUFFIX	:= tar.bz2
XORG_LIB_XFONT_URL	:= ftp://ftp.gwdg.de/pub/x11/x.org/pub/X11R7.0/src/lib//$(XORG_LIB_XFONT).$(XORG_LIB_XFONT_SUFFIX)
XORG_LIB_XFONT_SOURCE	:= $(SRCDIR)/$(XORG_LIB_XFONT).$(XORG_LIB_XFONT_SUFFIX)
XORG_LIB_XFONT_DIR	:= $(BUILDDIR)/$(XORG_LIB_XFONT)

-include $(call package_depfile)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

xorg-lib-Xfont_get: $(STATEDIR)/xorg-lib-Xfont.get

$(STATEDIR)/xorg-lib-Xfont.get: $(xorg-lib-Xfont_get_deps_default)
	@$(call targetinfo, $@)
	@$(call touch, $@)

$(XORG_LIB_XFONT_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, $(XORG_LIB_XFONT_URL))

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

xorg-lib-Xfont_extract: $(STATEDIR)/xorg-lib-Xfont.extract

$(STATEDIR)/xorg-lib-Xfont.extract: $(xorg-lib-Xfont_extract_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(XORG_LIB_XFONT_DIR))
	@$(call extract, $(XORG_LIB_XFONT_SOURCE))
	@$(call patchin, $(XORG_LIB_XFONT))
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

xorg-lib-Xfont_prepare: $(STATEDIR)/xorg-lib-Xfont.prepare

XORG_LIB_XFONT_PATH	:=  PATH=$(CROSS_PATH)
XORG_LIB_XFONT_ENV 	:=  $(CROSS_ENV)

#
# autoconf
#
XORG_LIB_XFONT_AUTOCONF := $(CROSS_AUTOCONF_USR)

$(STATEDIR)/xorg-lib-Xfont.prepare: $(xorg-lib-Xfont_prepare_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(XORG_LIB_XFONT_DIR)/config.cache)
	cd $(XORG_LIB_XFONT_DIR) && \
		$(XORG_LIB_XFONT_PATH) $(XORG_LIB_XFONT_ENV) \
		./configure $(XORG_LIB_XFONT_AUTOCONF)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

xorg-lib-Xfont_compile: $(STATEDIR)/xorg-lib-Xfont.compile

$(STATEDIR)/xorg-lib-Xfont.compile: $(xorg-lib-Xfont_compile_deps_default)
	@$(call targetinfo, $@)
	cd $(XORG_LIB_XFONT_DIR) && $(XORG_LIB_XFONT_PATH) make
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

xorg-lib-Xfont_install: $(STATEDIR)/xorg-lib-Xfont.install

$(STATEDIR)/xorg-lib-Xfont.install: $(xorg-lib-Xfont_install_deps_default)
	@$(call targetinfo, $@)
	@$(call install, XORG_LIB_XFONT)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

xorg-lib-Xfont_targetinstall: $(STATEDIR)/xorg-lib-Xfont.targetinstall

$(STATEDIR)/xorg-lib-Xfont.targetinstall: $(xorg-lib-Xfont_targetinstall_deps_default)
	@$(call targetinfo, $@)

	@$(call install_init,default)
	@$(call install_fixup,PACKAGE,xorg-lib-xfont)
	@$(call install_fixup,PRIORITY,optional)
	@$(call install_fixup,VERSION,$(XORG_LIB_XFONT_VERSION))
	@$(call install_fixup,SECTION,base)
	@$(call install_fixup,AUTHOR,"Erwin Rol <ero\@pengutronix.de>")
	@$(call install_fixup,DEPENDS,)
	@$(call install_fixup,DESCRIPTION,missing)

	@$(call install_copy, 0, 0, 0644, \
		$(XORG_LIB_XFONT_DIR)/src/.libs/libXfont.so.1.4.1, \
		$(XORG_LIBDIR)/libXfont.so.1.4.1)

	@$(call install_link, \
		libXfont.so.1.4.1, \
		$(XORG_LIBDIR)/libXfont.so.1)
	
	@$(call install_link, \
		libXfont.so.1.4.1, \
		$(XORG_LIBDIR)/libXfont.so)

	@$(call install_finish)

	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

xorg-lib-Xfont_clean:
	rm -rf $(STATEDIR)/xorg-lib-Xfont.*
	rm -rf $(IMAGEDIR)/xorg-lib-Xfont_*
	rm -rf $(XORG_LIB_XFONT_DIR)

# vim: syntax=make
