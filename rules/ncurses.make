# -*-makefile-*-
# $Id$
#
# Copyright (C) 2002-2006 by Pengutronix e.K., Hildesheim, Germany
# See CREDITS for details about who has contributed to this project. 
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_NCURSES) += ncurses

#
# Paths and names 
#
NCURSES_VERSION	:= 5.5
NCURSES		:= ncurses-$(NCURSES_VERSION)
NCURSES_SUFFIX	:= tar.gz
NCURSES_URL	:= $(PTXCONF_SETUP_GNUMIRROR)/ncurses/$(NCURSES).$(NCURSES_SUFFIX)
NCURSES_SOURCE	:= $(SRCDIR)/$(NCURSES).$(NCURSES_SUFFIX)
NCURSES_DIR	:= $(BUILDDIR)/$(NCURSES)

-include $(call package_depfile)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

ncurses_get: $(STATEDIR)/ncurses.get

$(STATEDIR)/ncurses.get: $(ncurses_get_deps_default)
	@$(call targetinfo, $@)
	@$(call touch, $@)

$(NCURSES_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, $(NCURSES_URL))

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

ncurses_extract: $(STATEDIR)/ncurses.extract

$(STATEDIR)/ncurses.extract: $(ncurses_extract_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(NCURSES_DIR))
	@$(call extract, $(NCURSES_SOURCE))
	@$(call patchin, $(NCURSES))
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

ncurses_prepare: $(STATEDIR)/ncurses.prepare

NCURSES_PATH	:= PATH=$(CROSS_PATH)
NCURSES_ENV 	:= $(CROSS_ENV)

NCURSES_AUTOCONF := \
	$(CROSS_AUTOCONF_USR) \
	--libdir=/lib \
	--with-shared \
	--disable-nls \
	--without-ada \
	--enable-const \
	--enable-overwrite

$(STATEDIR)/ncurses.prepare: $(ncurses_prepare_deps_default)
	@$(call targetinfo, $@)
	cd $(NCURSES_DIR) && \
		$(NCURSES_PATH) $(NCURSES_ENV) \
		./configure $(NCURSES_AUTOCONF)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

ncurses_compile: $(STATEDIR)/ncurses.compile

$(STATEDIR)/ncurses.compile: $(ncurses_compile_deps_default)
	@$(call targetinfo, $@)
	cd $(NCURSES_DIR) && $(NCURSES_PATH) make
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

ncurses_install: $(STATEDIR)/ncurses.install

$(STATEDIR)/ncurses.install: $(ncurses_install_deps_default)
	@$(call targetinfo, $@)
	@$(call install, NCURSES)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

ncurses_targetinstall: $(STATEDIR)/ncurses.targetinstall

$(STATEDIR)/ncurses.targetinstall: $(ncurses_targetinstall_deps_default)
	@$(call targetinfo, $@)

	@$(call install_init, ncurses)
	@$(call install_fixup, ncurses,PACKAGE,ncurses)
	@$(call install_fixup, ncurses,PRIORITY,optional)
	@$(call install_fixup, ncurses,VERSION,$(NCURSES_VERSION))
	@$(call install_fixup, ncurses,SECTION,base)
	@$(call install_fixup, ncurses,AUTHOR,"Robert Schwebel <r.schwebel\@pengutronix.de>")
	@$(call install_fixup, ncurses,DEPENDS,)
	@$(call install_fixup, ncurses,DESCRIPTION,missing)

	@$(call install_copy, ncurses, 0, 0, 0644, $(NCURSES_DIR)/lib/libncurses.so.5.5, /lib/libncurses.so.5.5)
	@$(call install_link, ncurses, libncurses.so.5.5, /lib/libncurses.so.5)
	@$(call install_link, ncurses, libncurses.so.5.5, /lib/libncurses.so)

ifdef PTXCONF_NCURSES_FORM
	@$(call install_copy, ncurses, 0, 0, 0644, $(NCURSES_DIR)/lib/libform.so.5.5, /lib/libform.so.5.5)
	@$(call install_link, ncurses, libform.so.5.5, /lib/libform.so.5)
	@$(call install_link, ncurses, libform.so.5.5, /lib/libform.so)
endif

ifdef PTXCONF_NCURSES_MENU
	@$(call install_copy, ncurses, 0, 0, 0644, $(NCURSES_DIR)/lib/libmenu.so.5.5, /lib/libmenu.so.5.5)
	@$(call install_link, ncurses, libmenu.so.5.5, /lib/libmenu.so.5)
	@$(call install_link, ncurses, libmenu.so.5.5, /lib/libmenu.so)
endif

ifdef PTXCONF_NCURSES_PANEL
	@$(call install_copy, ncurses, 0, 0, 0644, $(NCURSES_DIR)/lib/libpanel.so.5.5, /lib/libpanel.so.5.5)
	@$(call install_link, ncurses, libpanel.so.5.5, /lib/libpanel.so.5)
	@$(call install_link, ncurses, libpanel.so.5.5, /lib/libpanel.so)
endif

ifdef PTXCONF_NCURSES_TERMCAP
	mkdir -p $(ROOTDIR)/usr/share/terminfo
	@$(call install_copy, ncurses, 0, 0, 0644, $(SYSROOT)/usr/share/terminfo/x/xterm, /usr/share/terminfo/x/xterm, n);
	@$(call install_copy, ncurses, 0, 0, 0644, $(SYSROOT)/usr/share/terminfo/x/xterm-color, /usr/share/terminfo/x/xterm-color, n);
	@$(call install_copy, ncurses, 0, 0, 0644, $(SYSROOT)/usr/share/terminfo/x/xterm-xfree86, /usr/share/terminfo/x/xterm-xfree86, n);
	@$(call install_copy, ncurses, 0, 0, 0644, $(SYSROOT)/usr/share/terminfo/v/vt100, /usr/share/terminfo/v/vt100, n);
	@$(call install_copy, ncurses, 0, 0, 0644, $(SYSROOT)/usr/share/terminfo/v/vt102, /usr/share/terminfo/v/vt102, n);
	@$(call install_copy, ncurses, 0, 0, 0644, $(SYSROOT)/usr/share/terminfo/v/vt200, /usr/share/terminfo/v/vt200, n);
	@$(call install_copy, ncurses, 0, 0, 0644, $(SYSROOT)/usr/share/terminfo/a/ansi, /usr/share/terminfo/a/ansi, n);
	@$(call install_copy, ncurses, 0, 0, 0644, $(SYSROOT)/usr/share/terminfo/l/linux, /usr/share/terminfo/l/linux, n);
endif

	@$(call install_finish, ncurses)

	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

ncurses_clean: 
	rm -rf $(STATEDIR)/ncurses.* $(NCURSES_DIR)
	rm -rf $(IMAGEDIR)/ncurses_* 

# vim: syntax=make
