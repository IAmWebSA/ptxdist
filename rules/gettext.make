# -*-makefile-*-
# $Id$
#
# Copyright (C) 2003 by Robert Schwebel <r.schwebel@pengutronix.de>
#             Pengutronix <info@pengutronix.de>, Germany
#          
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_GETTEXT) += gettext

#
# Paths and names
#
GETTEXT_VERSION		= 0.13
GETTEXT			= gettext-$(GETTEXT_VERSION)
GETTEXT_SUFFIX		= tar.gz
GETTEXT_URL		= $(PTXCONF_SETUP_GNUMIRROR)/gettext/$(GETTEXT).$(GETTEXT_SUFFIX)
GETTEXT_SOURCE		= $(SRCDIR)/$(GETTEXT).$(GETTEXT_SUFFIX)
GETTEXT_DIR		= $(BUILDDIR)/$(GETTEXT)

GETTEXT_INST_DIR	= $(BUILDDIR)/$(GETTEXT)-install

-include $(call package_depfile)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

gettext_get: $(STATEDIR)/gettext.get

$(STATEDIR)/gettext.get: $(GETTEXT_SOURCE)
	@$(call targetinfo, $@)
	@$(call touch, $@)

$(GETTEXT_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, $(GETTEXT_URL))

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

gettext_extract: $(STATEDIR)/gettext.extract

$(STATEDIR)/gettext.extract: $(gettext_extract_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(GETTEXT_DIR))
	@$(call extract, $(GETTEXT_SOURCE))
	@$(call patchin, $(GETTEXT))
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

gettext_prepare: $(STATEDIR)/gettext.prepare

GETTEXT_PATH	=  PATH=$(CROSS_PATH)
GETTEXT_ENV 	=  $(CROSS_ENV) \
	ac_cv_func_getline=yes \
	am_cv_func_working_getline=yes

#
# autoconf
#

GETTEXT_AUTOCONF =  $(CROSS_AUTOCONF_USR)

# This is braindead but correct :-) No, it isn't!
# GETTEXT_AUTOCONF	+= --disable-nls

$(STATEDIR)/gettext.prepare: $(gettext_prepare_deps_default)
	@$(call targetinfo, $@)
	cd $(GETTEXT_DIR) && \
		$(GETTEXT_PATH) $(GETTEXT_ENV) \
		./configure $(GETTEXT_AUTOCONF)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

gettext_compile: $(STATEDIR)/gettext.compile

gettext_compile_deps = $(gettext_compile_deps_default)

$(STATEDIR)/gettext.compile: $(gettext_compile_deps)
	@$(call targetinfo, $@)
	$(GETTEXT_PATH) make -C $(GETTEXT_DIR)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

gettext_install: $(STATEDIR)/gettext.install

$(STATEDIR)/gettext.install: (gettext_install_deps_default)
	@$(call targetinfo, $@)
	# FIXME
	#@$(call install, GETTEXT)
	rm -rf $(GETTEXT_INST_DIR)
	cd $(GETTEXT_DIR) && $(GETTEXT_PATH) $(MAKE_INSTALL) prefix=$(GETTEXT_INST_DIR)/usr
	mkdir -p $(PTXCONF_PREFIX)/$(PTXCONF_GNU_TARGET)/lib
	cp -a $(GETTEXT_INST_DIR)/usr/lib/. $(PTXCONF_PREFIX)/$(PTXCONF_GNU_TARGET)/lib
	mkdir -p $(PTXCONF_PREFIX)/$(PTXCONF_GNU_TARGET)/include
	cp -a $(GETTEXT_INST_DIR)/usr/include/. $(PTXCONF_PREFIX)/$(PTXCONF_GNU_TARGET)/include
	rm -rf $(GETTEXT_INST_DIR)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

gettext_targetinstall: $(STATEDIR)/gettext.targetinstall

$(STATEDIR)/gettext.targetinstall: $(gettext_targetinstall_deps_default)
	@$(call targetinfo, $@)

	@$(call install_init,default)
	@$(call install_fixup,PACKAGE,gettext)
	@$(call install_fixup,PRIORITY,optional)
	@$(call install_fixup,VERSION,$(GETTEXT_VERSION))
	@$(call install_fixup,SECTION,base)
	@$(call install_fixup,AUTHOR,"Robert Schwebel <r.schwebel\@pengutronix.de>")
	@$(call install_fixup,DEPENDS,)
	@$(call install_fixup,DESCRIPTION,missing)
	
	cd $(GETTEXT_DIR)/gettext-runtime/intl/.libs && \
		for file in `find . -type f -name 'lib*intl.so*'`; do \
			$(call install_copy, 0, 0, 0644, $$file, /usr/lib/$$file, n) \
		done
	cd $(GETTEXT_DIR)/gettext-runtime/intl/.libs && \
		for file in `find . -type l -name 'lib*intl.so*'`; do \
			$(call install_link, `readlink $$file`, /usr/lib/$$file) \
		done

	@$(call install_finish)

	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

gettext_clean:
	rm -rf $(STATEDIR)/gettext.*
	rm -rf $(IMAGEDIR)/gettext_*
	rm -rf $(GETTEXT_DIR)

# vim: syntax=make
