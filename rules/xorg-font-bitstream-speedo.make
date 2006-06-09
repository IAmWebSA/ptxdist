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
PACKAGES-$(PTXCONF_XORG_FONT_BITSTREAM_SPEEDO) += xorg-font-bitstream-speedo

#
# Paths and names
#
XORG_FONT_BITSTREAM_SPEEDO_VERSION	:= 1.0.0
XORG_FONT_BITSTREAM_SPEEDO		:= font-bitstream-speedo-X11R7.0-$(XORG_FONT_BITSTREAM_SPEEDO_VERSION)
XORG_FONT_BITSTREAM_SPEEDO_SUFFIX	:= tar.bz2
XORG_FONT_BITSTREAM_SPEEDO_URL		:= ftp://ftp.gwdg.de/pub/x11/x.org/pub/X11R7.0/src/font//$(XORG_FONT_BITSTREAM_SPEEDO).$(XORG_FONT_BITSTREAM_SPEEDO_SUFFIX)
XORG_FONT_BITSTREAM_SPEEDO_SOURCE	:= $(SRCDIR)/$(XORG_FONT_BITSTREAM_SPEEDO).$(XORG_FONT_BITSTREAM_SPEEDO_SUFFIX)
XORG_FONT_BITSTREAM_SPEEDO_DIR		:= $(BUILDDIR)/$(XORG_FONT_BITSTREAM_SPEEDO)


# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

xorg-font-bitstream-speedo_get: $(STATEDIR)/xorg-font-bitstream-speedo.get

$(STATEDIR)/xorg-font-bitstream-speedo.get: $(xorg-font-bitstream-speedo_get_deps_default)
	@$(call targetinfo, $@)
	@$(call touch, $@)

$(XORG_FONT_BITSTREAM_SPEEDO_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, XORG_FONT_BITSTREAM_SPEEDO)

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

xorg-font-bitstream-speedo_extract: $(STATEDIR)/xorg-font-bitstream-speedo.extract

$(STATEDIR)/xorg-font-bitstream-speedo.extract: $(xorg-font-bitstream-speedo_extract_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(XORG_FONT_BITSTREAM_SPEEDO_DIR))
	@$(call extract, XORG_FONT_BITSTREAM_SPEEDO)
	@$(call patchin, XORG_FONT_BITSTREAM_SPEEDO)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

xorg-font-bitstream-speedo_prepare: $(STATEDIR)/xorg-font-bitstream-speedo.prepare

XORG_FONT_BITSTREAM_SPEEDO_PATH	:=  PATH=$(CROSS_PATH)
XORG_FONT_BITSTREAM_SPEEDO_ENV 	:=  $(CROSS_ENV)

#
# autoconf
#
XORG_FONT_BITSTREAM_SPEEDO_AUTOCONF := $(CROSS_AUTOCONF_USR)

$(STATEDIR)/xorg-font-bitstream-speedo.prepare: $(xorg-font-bitstream-speedo_prepare_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(XORG_FONT_BITSTREAM_SPEEDO_DIR)/config.cache)
	cd $(XORG_FONT_BITSTREAM_SPEEDO_DIR) && \
		$(XORG_FONT_BITSTREAM_SPEEDO_PATH) $(XORG_FONT_BITSTREAM_SPEEDO_ENV) \
		./configure $(XORG_FONT_BITSTREAM_SPEEDO_AUTOCONF)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

xorg-font-bitstream-speedo_compile: $(STATEDIR)/xorg-font-bitstream-speedo.compile

$(STATEDIR)/xorg-font-bitstream-speedo.compile: $(xorg-font-bitstream-speedo_compile_deps_default)
	@$(call targetinfo, $@)
	cd $(XORG_FONT_BITSTREAM_SPEEDO_DIR) && $(XORG_FONT_BITSTREAM_SPEEDO_PATH) make
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

xorg-font-bitstream-speedo_install: $(STATEDIR)/xorg-font-bitstream-speedo.install

$(STATEDIR)/xorg-font-bitstream-speedo.install: $(xorg-font-bitstream-speedo_install_deps_default)
	@$(call targetinfo, $@)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

xorg-font-bitstream-speedo_targetinstall: $(STATEDIR)/xorg-font-bitstream-speedo.targetinstall

$(STATEDIR)/xorg-font-bitstream-speedo.targetinstall: $(xorg-font-bitstream-speedo_targetinstall_deps_default)
	@$(call targetinfo, $@)

	@$(call install_init, xorg-font-bitstream-speedo)
	@$(call install_fixup, xorg-font-bitstream-speedo,PACKAGE,xorg-font-bitstream-speedo)
	@$(call install_fixup, xorg-font-bitstream-speedo,PRIORITY,optional)
	@$(call install_fixup, xorg-font-bitstream-speedo,VERSION,$(XORG_FONT_BITSTREAM_SPEEDO_VERSION))
	@$(call install_fixup, xorg-font-bitstream-speedo,SECTION,base)
	@$(call install_fixup, xorg-font-bitstream-speedo,AUTHOR,"Erwin Rol <ero\@pengutronix.de>")
	@$(call install_fixup, xorg-font-bitstream-speedo,DEPENDS,)
	@$(call install_fixup, xorg-font-bitstream-speedo,DESCRIPTION,missing)

	@cd $(XORG_FONT_BITSTREAM_SPEEDO_DIR); \
	for file in *.spd; do	\
		$(call install_copy, xorg-font-bitstream-speedo, 0, 0, 0644, $$file, $(XORG_FONTDIR)/Speedo/$$file, n); \
	done

	@$(call install_finish, xorg-font-bitstream-speedo)

	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

xorg-font-bitstream-speedo_clean:
	rm -rf $(STATEDIR)/xorg-font-bitstream-speedo.*
	rm -rf $(IMAGEDIR)/xorg-font-bitstream-speedo_*
	rm -rf $(XORG_FONT_BITSTREAM_SPEEDO_DIR)

# vim: syntax=make
