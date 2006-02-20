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
PACKAGES-$(PTXCONF_XORG_PROTO_XF86DGA) += xorg-proto-xf86dga

#
# Paths and names
#
XORG_PROTO_XF86DGA_VERSION	:= 2.0.2
XORG_PROTO_XF86DGA		:= xf86dgaproto-X11R7.0-$(XORG_PROTO_XF86DGA_VERSION)
XORG_PROTO_XF86DGA_SUFFIX	:= tar.bz2
XORG_PROTO_XF86DGA_URL		:= ftp://ftp.gwdg.de/pub/x11/x.org/pub/X11R7.0/src/proto/$(XORG_PROTO_XF86DGA).$(XORG_PROTO_XF86DGA_SUFFIX)
XORG_PROTO_XF86DGA_SOURCE	:= $(SRCDIR)/$(XORG_PROTO_XF86DGA).$(XORG_PROTO_XF86DGA_SUFFIX)
XORG_PROTO_XF86DGA_DIR		:= $(BUILDDIR)/$(XORG_PROTO_XF86DGA)

-include $(call package_depfile)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

xorg-proto-xf86dga_get: $(STATEDIR)/xorg-proto-xf86dga.get

$(STATEDIR)/xorg-proto-xf86dga.get: $(xorg-proto-xf86dga_get_deps_default)
	@$(call targetinfo, $@)
	@$(call touch, $@)

$(XORG_PROTO_XF86DGA_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, $(XORG_PROTO_XF86DGA_URL))

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

xorg-proto-xf86dga_extract: $(STATEDIR)/xorg-proto-xf86dga.extract

$(STATEDIR)/xorg-proto-xf86dga.extract: $(xorg-proto-xf86dga_extract_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(XORG_PROTO_XF86DGA_DIR))
	@$(call extract, $(XORG_PROTO_XF86DGA_SOURCE))
	@$(call patchin, $(XORG_PROTO_XF86DGA))
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

xorg-proto-xf86dga_prepare: $(STATEDIR)/xorg-proto-xf86dga.prepare

XORG_PROTO_XF86DGA_PATH	:=  PATH=$(CROSS_PATH)
XORG_PROTO_XF86DGA_ENV 	:=  $(CROSS_ENV)

#
# autoconf
#
XORG_PROTO_XF86DGA_AUTOCONF := $(CROSS_AUTOCONF_USR)

$(STATEDIR)/xorg-proto-xf86dga.prepare: $(xorg-proto-xf86dga_prepare_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(XORG_PROTO_XF86DGA_DIR)/config.cache)
	cd $(XORG_PROTO_XF86DGA_DIR) && \
		$(XORG_PROTO_XF86DGA_PATH) $(XORG_PROTO_XF86DGA_ENV) \
		./configure $(XORG_PROTO_XF86DGA_AUTOCONF)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

xorg-proto-xf86dga_compile: $(STATEDIR)/xorg-proto-xf86dga.compile

$(STATEDIR)/xorg-proto-xf86dga.compile: $(xorg-proto-xf86dga_compile_deps_default)
	@$(call targetinfo, $@)
	cd $(XORG_PROTO_XF86DGA_DIR) && $(XORG_PROTO_XF86DGA_PATH) make
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

xorg-proto-xf86dga_install: $(STATEDIR)/xorg-proto-xf86dga.install

$(STATEDIR)/xorg-proto-xf86dga.install: $(xorg-proto-xf86dga_install_deps_default)
	@$(call targetinfo, $@)
	@$(call install, XORG_PROTO_XF86DGA)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

xorg-proto-xf86dga_targetinstall: $(STATEDIR)/xorg-proto-xf86dga.targetinstall

$(STATEDIR)/xorg-proto-xf86dga.targetinstall: $(xorg-proto-xf86dga_targetinstall_deps_default)
	@$(call targetinfo, $@)

	@$(call install_init,default)
	@$(call install_fixup,PACKAGE,xorg-proto-xf86dga)
	@$(call install_fixup,PRIORITY,optional)
	@$(call install_fixup,VERSION,$(XORG_PROTO_XF86DGA_VERSION))
	@$(call install_fixup,SECTION,base)
	@$(call install_fixup,AUTHOR,"Erwin Rol <erwin\@erwinrol.com>")
	@$(call install_fixup,DEPENDS,)
	@$(call install_fixup,DESCRIPTION,missing)

	@$(call install_finish)

	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

xorg-proto-xf86dga_clean:
	rm -rf $(STATEDIR)/xorg-proto-xf86dga.*
	rm -rf $(IMAGEDIR)/xorg-proto-xf86dga_*
	rm -rf $(XORG_PROTO_XF86DGA_DIR)

# vim: syntax=make

