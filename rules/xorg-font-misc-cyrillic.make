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
PACKAGES-$(PTXCONF_XORG_FONT_MISC_CYRILLIC) += xorg-font-misc-cyrillic

#
# Paths and names
#
XORG_FONT_MISC_CYRILLIC_VERSION	:= 1.0.0
XORG_FONT_MISC_CYRILLIC		:= font-misc-cyrillic-X11R7.0-$(XORG_FONT_MISC_CYRILLIC_VERSION)
XORG_FONT_MISC_CYRILLIC_SUFFIX	:= tar.bz2
XORG_FONT_MISC_CYRILLIC_URL	:= ftp://ftp.gwdg.de/pub/x11/x.org/pub/X11R7.0/src/font//$(XORG_FONT_MISC_CYRILLIC).$(XORG_FONT_MISC_CYRILLIC_SUFFIX)
XORG_FONT_MISC_CYRILLIC_SOURCE	:= $(SRCDIR)/$(XORG_FONT_MISC_CYRILLIC).$(XORG_FONT_MISC_CYRILLIC_SUFFIX)
XORG_FONT_MISC_CYRILLIC_DIR	:= $(BUILDDIR)/$(XORG_FONT_MISC_CYRILLIC)


# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

xorg-font-misc-cyrillic_get: $(STATEDIR)/xorg-font-misc-cyrillic.get

$(STATEDIR)/xorg-font-misc-cyrillic.get: $(xorg-font-misc-cyrillic_get_deps_default)
	@$(call targetinfo, $@)
	@$(call touch, $@)

$(XORG_FONT_MISC_CYRILLIC_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, XORG_FONT_MISC_CYRILLIC)

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

xorg-font-misc-cyrillic_extract: $(STATEDIR)/xorg-font-misc-cyrillic.extract

$(STATEDIR)/xorg-font-misc-cyrillic.extract: $(xorg-font-misc-cyrillic_extract_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(XORG_FONT_MISC_CYRILLIC_DIR))
	@$(call extract, XORG_FONT_MISC_CYRILLIC)
	@$(call patchin, XORG_FONT_MISC_CYRILLIC)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

xorg-font-misc-cyrillic_prepare: $(STATEDIR)/xorg-font-misc-cyrillic.prepare

XORG_FONT_MISC_CYRILLIC_PATH	:=  PATH=$(CROSS_PATH)
XORG_FONT_MISC_CYRILLIC_ENV 	:=  $(CROSS_ENV)

#
# autoconf
#
XORG_FONT_MISC_CYRILLIC_AUTOCONF := $(CROSS_AUTOCONF_USR)

$(STATEDIR)/xorg-font-misc-cyrillic.prepare: $(xorg-font-misc-cyrillic_prepare_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(XORG_FONT_MISC_CYRILLIC_DIR)/config.cache)
	cd $(XORG_FONT_MISC_CYRILLIC_DIR) && \
		$(XORG_FONT_MISC_CYRILLIC_PATH) $(XORG_FONT_MISC_CYRILLIC_ENV) \
		./configure $(XORG_FONT_MISC_CYRILLIC_AUTOCONF)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

xorg-font-misc-cyrillic_compile: $(STATEDIR)/xorg-font-misc-cyrillic.compile

$(STATEDIR)/xorg-font-misc-cyrillic.compile: $(xorg-font-misc-cyrillic_compile_deps_default)
	@$(call targetinfo, $@)
	cd $(XORG_FONT_MISC_CYRILLIC_DIR) && $(XORG_FONT_MISC_CYRILLIC_PATH) make
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

xorg-font-misc-cyrillic_install: $(STATEDIR)/xorg-font-misc-cyrillic.install

$(STATEDIR)/xorg-font-misc-cyrillic.install: $(xorg-font-misc-cyrillic_install_deps_default)
	@$(call targetinfo, $@)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

xorg-font-misc-cyrillic_targetinstall: $(STATEDIR)/xorg-font-misc-cyrillic.targetinstall

$(STATEDIR)/xorg-font-misc-cyrillic.targetinstall: $(xorg-font-misc-cyrillic_targetinstall_deps_default)
	@$(call targetinfo, $@)

	@$(call install_init, xorg-font-misc-cyrillic)
	@$(call install_fixup, xorg-font-misc-cyrillic,PACKAGE,xorg-font-misc-cyrillic)
	@$(call install_fixup, xorg-font-misc-cyrillic,PRIORITY,optional)
	@$(call install_fixup, xorg-font-misc-cyrillic,VERSION,$(XORG_FONT_MISC_CYRILLIC_VERSION))
	@$(call install_fixup, xorg-font-misc-cyrillic,SECTION,base)
	@$(call install_fixup, xorg-font-misc-cyrillic,AUTHOR,"Erwin Rol <ero\@pengutronix.de>")
	@$(call install_fixup, xorg-font-misc-cyrillic,DEPENDS,)
	@$(call install_fixup, xorg-font-misc-cyrillic,DESCRIPTION,missing)

	@cd $(XORG_FONT_MISC_CYRILLIC_DIR); \
	for file in *.pcf.gz; do	\
		$(call install_copy, xorg-font-misc-cyrillic, 0, 0, 0644, $$file, $(XORG_FONTDIR)/cyrillic/$$file, n); \
	done

	@$(call install_finish, xorg-font-misc-cyrillic)

	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

xorg-font-misc-cyrillic_clean:
	rm -rf $(STATEDIR)/xorg-font-misc-cyrillic.*
	rm -rf $(IMAGEDIR)/xorg-font-misc-cyrillic_*
	rm -rf $(XORG_FONT_MISC_CYRILLIC_DIR)

# vim: syntax=make
