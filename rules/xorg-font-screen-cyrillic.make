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
PACKAGES-$(PTXCONF_XORG_FONT_SCREEN_CYRILLIC) += xorg-font-screen-cyrillic

#
# Paths and names
#
XORG_FONT_SCREEN_CYRILLIC_VERSION	:= 1.0.0
XORG_FONT_SCREEN_CYRILLIC		:= font-screen-cyrillic-X11R7.0-$(XORG_FONT_SCREEN_CYRILLIC_VERSION)
XORG_FONT_SCREEN_CYRILLIC_SUFFIX	:= tar.bz2
XORG_FONT_SCREEN_CYRILLIC_URL		:= ftp://ftp.gwdg.de/pub/x11/x.org/pub/X11R7.0/src/font//$(XORG_FONT_SCREEN_CYRILLIC).$(XORG_FONT_SCREEN_CYRILLIC_SUFFIX)
XORG_FONT_SCREEN_CYRILLIC_SOURCE	:= $(SRCDIR)/$(XORG_FONT_SCREEN_CYRILLIC).$(XORG_FONT_SCREEN_CYRILLIC_SUFFIX)
XORG_FONT_SCREEN_CYRILLIC_DIR		:= $(BUILDDIR)/$(XORG_FONT_SCREEN_CYRILLIC)


# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

xorg-font-screen-cyrillic_get: $(STATEDIR)/xorg-font-screen-cyrillic.get

$(STATEDIR)/xorg-font-screen-cyrillic.get: $(xorg-font-screen-cyrillic_get_deps_default)
	@$(call targetinfo, $@)
	@$(call touch, $@)

$(XORG_FONT_SCREEN_CYRILLIC_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, XORG_FONT_SCREEN_CYRILLIC)

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

xorg-font-screen-cyrillic_extract: $(STATEDIR)/xorg-font-screen-cyrillic.extract

$(STATEDIR)/xorg-font-screen-cyrillic.extract: $(xorg-font-screen-cyrillic_extract_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(XORG_FONT_SCREEN_CYRILLIC_DIR))
	@$(call extract, XORG_FONT_SCREEN_CYRILLIC)
	@$(call patchin, XORG_FONT_SCREEN_CYRILLIC)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

xorg-font-screen-cyrillic_prepare: $(STATEDIR)/xorg-font-screen-cyrillic.prepare

XORG_FONT_SCREEN_CYRILLIC_PATH	:=  PATH=$(CROSS_PATH)
XORG_FONT_SCREEN_CYRILLIC_ENV 	:=  $(CROSS_ENV)

#
# autoconf
#
XORG_FONT_SCREEN_CYRILLIC_AUTOCONF := $(CROSS_AUTOCONF_USR)

$(STATEDIR)/xorg-font-screen-cyrillic.prepare: $(xorg-font-screen-cyrillic_prepare_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(XORG_FONT_SCREEN_CYRILLIC_DIR)/config.cache)
	cd $(XORG_FONT_SCREEN_CYRILLIC_DIR) && \
		$(XORG_FONT_SCREEN_CYRILLIC_PATH) $(XORG_FONT_SCREEN_CYRILLIC_ENV) \
		./configure $(XORG_FONT_SCREEN_CYRILLIC_AUTOCONF)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

xorg-font-screen-cyrillic_compile: $(STATEDIR)/xorg-font-screen-cyrillic.compile

$(STATEDIR)/xorg-font-screen-cyrillic.compile: $(xorg-font-screen-cyrillic_compile_deps_default)
	@$(call targetinfo, $@)
	cd $(XORG_FONT_SCREEN_CYRILLIC_DIR) && $(XORG_FONT_SCREEN_CYRILLIC_PATH) make
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

xorg-font-screen-cyrillic_install: $(STATEDIR)/xorg-font-screen-cyrillic.install

$(STATEDIR)/xorg-font-screen-cyrillic.install: $(xorg-font-screen-cyrillic_install_deps_default)
	@$(call targetinfo, $@)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

xorg-font-screen-cyrillic_targetinstall: $(STATEDIR)/xorg-font-screen-cyrillic.targetinstall

$(STATEDIR)/xorg-font-screen-cyrillic.targetinstall: $(xorg-font-screen-cyrillic_targetinstall_deps_default)
	@$(call targetinfo, $@)

	@$(call install_init, xorg-font-screen-cyrillic)
	@$(call install_fixup, xorg-font-screen-cyrillic,PACKAGE,xorg-font-screen-cyrillic)
	@$(call install_fixup, xorg-font-screen-cyrillic,PRIORITY,optional)
	@$(call install_fixup, xorg-font-screen-cyrillic,VERSION,$(XORG_FONT_SCREEN_CYRILLIC_VERSION))
	@$(call install_fixup, xorg-font-screen-cyrillic,SECTION,base)
	@$(call install_fixup, xorg-font-screen-cyrillic,AUTHOR,"Erwin Rol <ero\@pengutronix.de>")
	@$(call install_fixup, xorg-font-screen-cyrillic,DEPENDS,)
	@$(call install_fixup, xorg-font-screen-cyrillic,DESCRIPTION,missing)

	@cd $(XORG_FONT_SCREEN_CYRILLIC_DIR); \
	for file in *.pcf.gz; do	\
		$(call install_copy, xorg-font-screen-cyrillic, 0, 0, 0644, $$file, $(XORG_FONTDIR)/cyrillic/$$file, n); \
	done

	@$(call install_finish, xorg-font-screen-cyrillic)

	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

xorg-font-screen-cyrillic_clean:
	rm -rf $(STATEDIR)/xorg-font-screen-cyrillic.*
	rm -rf $(IMAGEDIR)/xorg-font-screen-cyrillic_*
	rm -rf $(XORG_FONT_SCREEN_CYRILLIC_DIR)

# vim: syntax=make
