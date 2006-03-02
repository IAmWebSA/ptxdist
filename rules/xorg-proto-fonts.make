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
PACKAGES-$(PTXCONF_XORG_PROTO_FONTS) += xorg-proto-fonts

#
# Paths and names
#
XORG_PROTO_FONTS_VERSION	:= 2.0.2
XORG_PROTO_FONTS		:= fontsproto-X11R7.0-$(XORG_PROTO_FONTS_VERSION)
XORG_PROTO_FONTS_SUFFIX		:= tar.bz2
XORG_PROTO_FONTS_URL		:= ftp://ftp.gwdg.de/pub/x11/x.org/pub/X11R7.0/src/proto/$(XORG_PROTO_FONTS).$(XORG_PROTO_FONTS_SUFFIX)
XORG_PROTO_FONTS_SOURCE		:= $(SRCDIR)/$(XORG_PROTO_FONTS).$(XORG_PROTO_FONTS_SUFFIX)
XORG_PROTO_FONTS_DIR		:= $(BUILDDIR)/$(XORG_PROTO_FONTS)

-include $(call package_depfile)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

xorg-proto-fonts_get: $(STATEDIR)/xorg-proto-fonts.get

$(STATEDIR)/xorg-proto-fonts.get: $(xorg-proto-fonts_get_deps_default)
	@$(call targetinfo, $@)
	@$(call touch, $@)

$(XORG_PROTO_FONTS_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, $(XORG_PROTO_FONTS_URL))

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

xorg-proto-fonts_extract: $(STATEDIR)/xorg-proto-fonts.extract

$(STATEDIR)/xorg-proto-fonts.extract: $(xorg-proto-fonts_extract_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(XORG_PROTO_FONTS_DIR))
	@$(call extract, $(XORG_PROTO_FONTS_SOURCE))
	@$(call patchin, $(XORG_PROTO_FONTS))
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

xorg-proto-fonts_prepare: $(STATEDIR)/xorg-proto-fonts.prepare

XORG_PROTO_FONTS_PATH	:=  PATH=$(CROSS_PATH)
XORG_PROTO_FONTS_ENV 	:=  $(CROSS_ENV)

#
# autoconf
#
XORG_PROTO_FONTS_AUTOCONF := $(CROSS_AUTOCONF_USR)

$(STATEDIR)/xorg-proto-fonts.prepare: $(xorg-proto-fonts_prepare_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(XORG_PROTO_FONTS_DIR)/config.cache)
	cd $(XORG_PROTO_FONTS_DIR) && \
		$(XORG_PROTO_FONTS_PATH) $(XORG_PROTO_FONTS_ENV) \
		./configure $(XORG_PROTO_FONTS_AUTOCONF)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

xorg-proto-fonts_compile: $(STATEDIR)/xorg-proto-fonts.compile

$(STATEDIR)/xorg-proto-fonts.compile: $(xorg-proto-fonts_compile_deps_default)
	@$(call targetinfo, $@)
	cd $(XORG_PROTO_FONTS_DIR) && $(XORG_PROTO_FONTS_PATH) make
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

xorg-proto-fonts_install: $(STATEDIR)/xorg-proto-fonts.install

$(STATEDIR)/xorg-proto-fonts.install: $(xorg-proto-fonts_install_deps_default)
	@$(call targetinfo, $@)
	@$(call install, XORG_PROTO_FONTS)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

xorg-proto-fonts_targetinstall: $(STATEDIR)/xorg-proto-fonts.targetinstall

$(STATEDIR)/xorg-proto-fonts.targetinstall: $(xorg-proto-fonts_targetinstall_deps_default)
	@$(call targetinfo, $@)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

xorg-proto-fonts_clean:
	rm -rf $(STATEDIR)/xorg-proto-fonts.*
	rm -rf $(IMAGEDIR)/xorg-proto-fonts_*
	rm -rf $(XORG_PROTO_FONTS_DIR)

# vim: syntax=make

