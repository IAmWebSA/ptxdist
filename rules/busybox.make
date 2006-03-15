# -*-makefile-*-
# $Id$
#
# Copyright (C) 2003 by Robert Schwebel <r.schwebel@pengutronix.de>
#          
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_BUSYBOX) += busybox

#
# Paths and names
#
BUSYBOX_VERSION		= 1.1.0
BUSYBOX			= busybox-$(BUSYBOX_VERSION)
BUSYBOX_SUFFIX		= tar.bz2
BUSYBOX_URL		= http://www.busybox.net/downloads/$(BUSYBOX).$(BUSYBOX_SUFFIX)
BUSYBOX_SOURCE		= $(SRCDIR)/$(BUSYBOX).$(BUSYBOX_SUFFIX)
BUSYBOX_DIR		= $(BUILDDIR)/$(BUSYBOX)

-include $(call package_depfile)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

busybox_get: $(STATEDIR)/busybox.get

$(STATEDIR)/busybox.get: $(busybox_get_deps_default)
	@$(call targetinfo, $@)
	@$(call touch, $@)

$(BUSYBOX_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, $(BUSYBOX_URL))

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

busybox_extract: $(STATEDIR)/busybox.extract

$(STATEDIR)/busybox.extract: $(busybox_extract_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(BUSYBOX_DIR))
	@$(call extract, $(BUSYBOX_SOURCE))
	@$(call patchin, $(BUSYBOX))

#	# fix: turn off debugging in init.c
	perl -i -p -e 's/^#define DEBUG_INIT/#undef DEBUG_INIT/g' $(BUSYBOX_DIR)/init/init.c

	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

busybox_prepare: $(STATEDIR)/busybox.prepare

BUSYBOX_PATH		=  PATH=$(CROSS_PATH)
BUSYBOX_ENV 		=  $(CROSS_ENV)

BUSYBOX_TARGET_LDFLAGS	=  $(call remove_quotes,$(TARGET_LDFLAGS))
ifdef PTXCONF_BB_CONFIG_STATIC                                                                                                        
BUSYBOX_TARGET_LDFLAGS	+= -static
endif                                                                                                                                 

BUSYBOX_MAKEVARS=\
	CROSS=$(COMPILER_PREFIX) \
	HOSTCC=$(HOSTCC) \
	EXTRA_CFLAGS='$(call remove_quotes,$(TARGET_CFLAGS))' \
	LDFLAGS='$(BUSYBOX_TARGET_LDFLAGS)' \
	PREFIX=$(SYSROOT)

$(STATEDIR)/busybox.prepare: $(busybox_prepare_deps_default)
	@$(call targetinfo, $@)

#	FIXME: is this necessary?
	touch $(BUSYBOX_DIR)/busybox.links

	$(BUSYBOX_PATH) make -C $(BUSYBOX_DIR) distclean $(BUSYBOX_MAKEVARS)
	grep -e PTXCONF_BB_ $(PTXDIST_WORKSPACE)/ptxconfig > $(BUSYBOX_DIR)/.config
	perl -i -p -e 's/PTXCONF_BB_//g' $(BUSYBOX_DIR)/.config
	echo GCC_PREFIX=$(COMPILER_PREFIX)
	perl -i -p -e 's/^CROSS_COMPILER_PREFIX=.*$$/CROSS_COMPILER_PREFIX=\"$(COMPILER_PREFIX)\"/g' $(BUSYBOX_DIR)/.config
	yes "" | $(BUSYBOX_PATH) make -C $(BUSYBOX_DIR) oldconfig $(BUSYBOX_MAKEVARS)
	$(BUSYBOX_PATH) make -C $(BUSYBOX_DIR) dep $(BUSYBOX_MAKEVARS)

	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

busybox_compile: $(STATEDIR)/busybox.compile

$(STATEDIR)/busybox.compile: $(busybox_compile_deps_default)
	@$(call targetinfo, $@)
	cd $(BUSYBOX_DIR) && $(BUSYBOX_PATH) make $(BUSYBOX_MAKEVARS)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

busybox_install: $(STATEDIR)/busybox.install

$(STATEDIR)/busybox.install: $(busybox_install_deps_default)
	@$(call targetinfo, $@)
	@$(call install, BUSYBOX)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

busybox_targetinstall: $(STATEDIR)/busybox.targetinstall

$(STATEDIR)/busybox.targetinstall: $(busybox_targetinstall_deps_default)
	@$(call targetinfo, $@)

	@$(call install_init, busybox)
	@$(call install_fixup, busybox,PACKAGE,busybox)
	@$(call install_fixup, busybox,PRIORITY,optional)
	@$(call install_fixup, busybox,VERSION,$(BUSYBOX_VERSION))
	@$(call install_fixup, busybox,SECTION,base)
	@$(call install_fixup, busybox,AUTHOR,"Robert Schwebel <r.schwebel\@pengutronix.de>")
	@$(call install_fixup, busybox,DEPENDS,)
	@$(call install_fixup, busybox,DESCRIPTION,missing)

	rm -f $(BUSYBOX_DIR)/busybox.links
	cd $(BUSYBOX_DIR) && $(MAKE) busybox.links

	@$(call install_copy, busybox, 0, 0, 1555, $(BUSYBOX_DIR)/busybox, /bin/busybox)
	for file in `cat $(BUSYBOX_DIR)/busybox.links`; do	\
		$(call install_link, busybox, /bin/busybox, $$file);	\
	done

ifdef PTXCONF_BB_CONFIG_VI
	vimfile=`mktemp`; \
	echo "#!/bin/sh" >> $$vimfile; \
	echo "/bin/vi $*" >> $$vimfile; \
	$(call install_copy, busybox, 0, 0, 0755, $$vimfile, /usr/bin/vim,n); \
	rm $$vimfile
endif
	@$(call install_finish, busybox)

	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

busybox_clean:
	rm -rf $(STATEDIR)/busybox.*
	rm -rf $(BUSYBOX_DIR)

# vim: syntax=make
