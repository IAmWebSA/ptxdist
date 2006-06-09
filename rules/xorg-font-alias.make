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
PACKAGES-$(PTXCONF_XORG_FONT_ALIAS) += xorg-font-alias

#
# Paths and names
#
XORG_FONT_ALIAS_VERSION	:= 1.0.1
XORG_FONT_ALIAS		:= font-alias-X11R7.0-$(XORG_FONT_ALIAS_VERSION)
XORG_FONT_ALIAS_SUFFIX	:= tar.bz2
XORG_FONT_ALIAS_URL	:= ftp://ftp.gwdg.de/pub/x11/x.org/pub/X11R7.0/src/font//$(XORG_FONT_ALIAS).$(XORG_FONT_ALIAS_SUFFIX)
XORG_FONT_ALIAS_SOURCE	:= $(SRCDIR)/$(XORG_FONT_ALIAS).$(XORG_FONT_ALIAS_SUFFIX)
XORG_FONT_ALIAS_DIR	:= $(BUILDDIR)/$(XORG_FONT_ALIAS)


# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

xorg-font-alias_get: $(STATEDIR)/xorg-font-alias.get

$(STATEDIR)/xorg-font-alias.get: $(xorg-font-alias_get_deps_default)
	@$(call targetinfo, $@)
	@$(call touch, $@)

$(XORG_FONT_ALIAS_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, XORG_FONT_ALIAS)

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

xorg-font-alias_extract: $(STATEDIR)/xorg-font-alias.extract

$(STATEDIR)/xorg-font-alias.extract: $(xorg-font-alias_extract_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(XORG_FONT_ALIAS_DIR))
	@$(call extract, XORG_FONT_ALIAS)
	@$(call patchin, XORG_FONT_ALIAS)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

xorg-font-alias_prepare: $(STATEDIR)/xorg-font-alias.prepare

XORG_FONT_ALIAS_PATH	:=  PATH=$(CROSS_PATH)
XORG_FONT_ALIAS_ENV 	:=  $(CROSS_ENV)

#
# autoconf
#
XORG_FONT_ALIAS_AUTOCONF := $(CROSS_AUTOCONF_USR)

$(STATEDIR)/xorg-font-alias.prepare: $(xorg-font-alias_prepare_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(XORG_FONT_ALIAS_DIR)/config.cache)
	cd $(XORG_FONT_ALIAS_DIR) && \
		$(XORG_FONT_ALIAS_PATH) $(XORG_FONT_ALIAS_ENV) \
		./configure $(XORG_FONT_ALIAS_AUTOCONF)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

xorg-font-alias_compile: $(STATEDIR)/xorg-font-alias.compile

$(STATEDIR)/xorg-font-alias.compile: $(xorg-font-alias_compile_deps_default)
	@$(call targetinfo, $@)
	cd $(XORG_FONT_ALIAS_DIR) && $(XORG_FONT_ALIAS_PATH) make
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

xorg-font-alias_install: $(STATEDIR)/xorg-font-alias.install

$(STATEDIR)/xorg-font-alias.install: $(xorg-font-alias_install_deps_default)
	@$(call targetinfo, $@)
	@$(call install, XORG_FONT_ALIAS)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

xorg-font-alias_targetinstall: $(STATEDIR)/xorg-font-alias.targetinstall

$(STATEDIR)/xorg-font-alias.targetinstall: $(xorg-font-alias_targetinstall_deps_default)
	@$(call targetinfo, $@)

	@$(call install_init, xorg-font-alias)
	@$(call install_fixup, xorg-font-alias,PACKAGE,xorg-font-alias)
	@$(call install_fixup, xorg-font-alias,PRIORITY,optional)
	@$(call install_fixup, xorg-font-alias,VERSION,$(XORG_FONT_ALIAS_VERSION))
	@$(call install_fixup, xorg-font-alias,SECTION,base)
	@$(call install_fixup, xorg-font-alias,AUTHOR,"Erwin Rol <ero\@pengutronix.de>")
	@$(call install_fixup, xorg-font-alias,DEPENDS,)
	@$(call install_fixup, xorg-font-alias,DESCRIPTION,missing)

	@$(call install_copy, xorg-font-alias, 0, 0, 0644, $(XORG_FONT_ALIAS_DIR)/100dpi/fonts.alias, $(XORG_FONTDIR)/100dpi/fonts.alias)
	@$(call install_copy, xorg-font-alias, 0, 0, 0644, $(XORG_FONT_ALIAS_DIR)/75dpi/fonts.alias, $(XORG_FONTDIR)/75dpi/fonts.alias)
	@$(call install_copy, xorg-font-alias, 0, 0, 0644, $(XORG_FONT_ALIAS_DIR)/cyrillic/fonts.alias, $(XORG_FONTDIR)/cyrillic/fonts.alias)
	@$(call install_copy, xorg-font-alias, 0, 0, 0644, $(XORG_FONT_ALIAS_DIR)/misc/fonts.alias, $(XORG_FONTDIR)/misc/fonts.alias)

	@$(call install_finish, xorg-font-alias)

	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

xorg-font-alias_clean:
	rm -rf $(STATEDIR)/xorg-font-alias.*
	rm -rf $(IMAGEDIR)/xorg-font-alias_*
	rm -rf $(XORG_FONT_ALIAS_DIR)

# vim: syntax=make
