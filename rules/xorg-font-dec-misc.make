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
PACKAGES-$(PTXCONF_XORG_FONT_DEC_MISC) += xorg-font-dec-misc

#
# Paths and names
#
XORG_FONT_DEC_MISC_VERSION	:= 1.0.0
XORG_FONT_DEC_MISC		:= font-dec-misc-X11R7.0-$(XORG_FONT_DEC_MISC_VERSION)
XORG_FONT_DEC_MISC_SUFFIX	:= tar.bz2
XORG_FONT_DEC_MISC_URL		:= ftp://ftp.gwdg.de/pub/x11/x.org/pub/X11R7.0/src/font//$(XORG_FONT_DEC_MISC).$(XORG_FONT_DEC_MISC_SUFFIX)
XORG_FONT_DEC_MISC_SOURCE	:= $(SRCDIR)/$(XORG_FONT_DEC_MISC).$(XORG_FONT_DEC_MISC_SUFFIX)
XORG_FONT_DEC_MISC_DIR		:= $(BUILDDIR)/$(XORG_FONT_DEC_MISC)


# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

xorg-font-dec-misc_get: $(STATEDIR)/xorg-font-dec-misc.get

$(STATEDIR)/xorg-font-dec-misc.get: $(xorg-font-dec-misc_get_deps_default)
	@$(call targetinfo, $@)
	@$(call touch, $@)

$(XORG_FONT_DEC_MISC_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, XORG_FONT_DEC_MISC)

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

xorg-font-dec-misc_extract: $(STATEDIR)/xorg-font-dec-misc.extract

$(STATEDIR)/xorg-font-dec-misc.extract: $(xorg-font-dec-misc_extract_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(XORG_FONT_DEC_MISC_DIR))
	@$(call extract, XORG_FONT_DEC_MISC)
	@$(call patchin, XORG_FONT_DEC_MISC)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

xorg-font-dec-misc_prepare: $(STATEDIR)/xorg-font-dec-misc.prepare

XORG_FONT_DEC_MISC_PATH	:=  PATH=$(CROSS_PATH)
XORG_FONT_DEC_MISC_ENV 	:=  $(CROSS_ENV)

#
# autoconf
#
XORG_FONT_DEC_MISC_AUTOCONF := $(CROSS_AUTOCONF_USR)

$(STATEDIR)/xorg-font-dec-misc.prepare: $(xorg-font-dec-misc_prepare_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(XORG_FONT_DEC_MISC_DIR)/config.cache)
	cd $(XORG_FONT_DEC_MISC_DIR) && \
		$(XORG_FONT_DEC_MISC_PATH) $(XORG_FONT_DEC_MISC_ENV) \
		./configure $(XORG_FONT_DEC_MISC_AUTOCONF)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

xorg-font-dec-misc_compile: $(STATEDIR)/xorg-font-dec-misc.compile

$(STATEDIR)/xorg-font-dec-misc.compile: $(xorg-font-dec-misc_compile_deps_default)
	@$(call targetinfo, $@)
	cd $(XORG_FONT_DEC_MISC_DIR) && $(XORG_FONT_DEC_MISC_PATH) make
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

xorg-font-dec-misc_install: $(STATEDIR)/xorg-font-dec-misc.install

$(STATEDIR)/xorg-font-dec-misc.install: $(xorg-font-dec-misc_install_deps_default)
	@$(call targetinfo, $@)
	@$(call install, XORG_FONT_DEC_MISC)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

xorg-font-dec-misc_targetinstall: $(STATEDIR)/xorg-font-dec-misc.targetinstall

$(STATEDIR)/xorg-font-dec-misc.targetinstall: $(xorg-font-dec-misc_targetinstall_deps_default)
	@$(call targetinfo, $@)

	@$(call install_init, xorg-font-dec-misc)
	@$(call install_fixup, xorg-font-dec-misc,PACKAGE,xorg-font-dec-misc)
	@$(call install_fixup, xorg-font-dec-misc,PRIORITY,optional)
	@$(call install_fixup, xorg-font-dec-misc,VERSION,$(XORG_FONT_DEC_MISC_VERSION))
	@$(call install_fixup, xorg-font-dec-misc,SECTION,base)
	@$(call install_fixup, xorg-font-dec-misc,AUTHOR,"Erwin Rol <ero\@pengutronix.de>")
	@$(call install_fixup, xorg-font-dec-misc,DEPENDS,)
	@$(call install_fixup, xorg-font-dec-misc,DESCRIPTION,missing)

	@cd $(XORG_FONT_DEC_MISC_DIR); \
	for file in *.pcf.gz; do	\
		$(call install_copy, xorg-font-dec-misc, 0, 0, 0644, $$file, $(XORG_FONTDIR)/misc/$$file, n); \
	done

	@$(call install_finish, xorg-font-dec-misc)

	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

xorg-font-dec-misc_clean:
	rm -rf $(STATEDIR)/xorg-font-dec-misc.*
	rm -rf $(IMAGEDIR)/xorg-font-dec-misc_*
	rm -rf $(XORG_FONT_DEC_MISC_DIR)

# vim: syntax=make
