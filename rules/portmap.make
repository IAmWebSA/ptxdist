# -*-makefile-*-
# $Id: portmap.make,v 1.6 2003/09/17 23:43:59 mkl Exp $
#
# (c) 2002 by Pengutronix e.K., Hildesheim, Germany
# See CREDITS for details about who has contributed to this project. 
#
# For further information about the PTXDIST project and license conditions
# see the README file.
#

#
# We provide this package
#
ifdef PTXCONF_PORTMAP
PACKAGES += portmap
endif

#
# Paths and names 
#
PORTMAP			= portmap_4
PORTMAP_URL		= ftp://ftp.porcupine.org/pub/security/$(PORTMAP).tar.gz
PORTMAP_SOURCE		= $(SRCDIR)/$(PORTMAP).tar.gz
PORTMAP_DIR		= $(BUILDDIR)/$(PORTMAP)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

portmap_get: $(STATEDIR)/portmap.get

$(STATEDIR)/portmap.get: $(PORTMAP_SOURCE)
	@$(call targetinfo, portmap.get)
	touch $@

$(PORTMAP_SOURCE):
	@$(call targetinfo, $(PORTMAP_SOURCE))
	@$(call get, $(PORTMAP_URL))

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

portmap_extract: $(STATEDIR)/portmap.extract

$(STATEDIR)/portmap.extract: $(STATEDIR)/portmap.get
	@$(call targetinfo, portmap.extract)
	@$(call clean, $(PORTMAP_DIR))
	@$(call extract, $(PORTMAP_SOURCE))
#	apply some fixes
	@$(call disable_sh, $(PORTMAP_DIR)/Makefile, HOSTS_ACCESS)
	@$(call disable_sh, $(PORTMAP_DIR)/Makefile, CHECK_PORT)
	@$(call disable_sh, $(PORTMAP_DIR)/Makefile, AUX)
#	FIXME: uggly, make patch
	perl -i -p -e "s/const/__const/g" $(PORTMAP_DIR)/portmap.c
	touch $@

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

portmap_prepare: $(STATEDIR)/portmap.prepare

portmap_prepare_deps = \
	$(STATEDIR)/virtual-xchain.install \
	$(STATEDIR)/tcpwrapper.install \
	$(STATEDIR)/portmap.extract

$(STATEDIR)/portmap.prepare: $(portmap_prepare_deps)
	@$(call targetinfo, portmap.prepare)
	touch $@

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

portmap_compile: $(STATEDIR)/portmap.compile

PORTMAP_ENV		= $(CROSS_ENV)
PORTMAP_PATH		= PATH=$(CROSS_PATH)
PORTMAP_MAKEVARS	= WRAP_DIR=$(CROSS_LIB_DIR)/lib

$(STATEDIR)/portmap.compile: $(STATEDIR)/portmap.prepare
	@$(call targetinfo, portmap.compile)
	$(PORTMAP_ENV) $(PORTMAP_PATH) \
		make -C $(PORTMAP_DIR) $(PORTMAP_MAKEVARS)
	touch $@

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

portmap_install: $(STATEDIR)/portmap.install

$(STATEDIR)/portmap.install: $(STATEDIR)/portmap.compile
	@$(call targetinfo, portmap.install)
	touch $@

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

portmap_targetinstall: $(STATEDIR)/portmap.targetinstall

$(STATEDIR)/portmap.targetinstall: $(STATEDIR)/portmap.install
	@$(call targetinfo, portmap.targetinstall)
ifdef PTXCONF_PORTMAP_INSTALL_PORTMAPPER
	mkdir -p $(ROOTDIR)/sbin
	install $(PORTMAP_DIR)/portmap $(ROOTDIR)/sbin
	$(CROSSSTRIP) -R .notes -R .comment $(ROOTDIR)/sbin/portmap
endif
	touch $@

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

portmap_clean: 
	rm -rf $(STATEDIR)/portmap.* $(PORTMAP_DIR)

# vim: syntax=make
