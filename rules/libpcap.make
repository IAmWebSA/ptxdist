# -*-makefile-*-
# $Id: libpcap.make,v 1.4 2003/10/28 01:50:31 mkl Exp $
#
# Copyright (C) 2003 by Marc Kleine-Budde <kleine-budde.de>
#          
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
ifdef PTXCONF_LIBPCAP
PACKAGES += libpcap
endif

#
# Paths and names
#
LIBPCAP_VERSION	= 0.7.2
LIBPCAP		= libpcap-$(LIBPCAP_VERSION)
LIBPCAP_SUFFIX	= tar.gz
LIBPCAP_URL	= http://www.tcpdump.org/release/$(LIBPCAP).$(LIBPCAP_SUFFIX)
LIBPCAP_SOURCE	= $(SRCDIR)/$(LIBPCAP).$(LIBPCAP_SUFFIX)
LIBPCAP_DIR	= $(BUILDDIR)/$(LIBPCAP)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

libpcap_get: $(STATEDIR)/libpcap.get

libpcap_get_deps = $(LIBPCAP_SOURCE)

$(STATEDIR)/libpcap.get: $(libpcap_get_deps)
	@$(call targetinfo, $@)
	touch $@

$(LIBPCAP_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, $(LIBPCAP_URL))

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

libpcap_extract: $(STATEDIR)/libpcap.extract

libpcap_extract_deps = $(STATEDIR)/libpcap.get

$(STATEDIR)/libpcap.extract: $(libpcap_extract_deps)
	@$(call targetinfo, $@)
	@$(call clean, $(LIBPCAP_DIR))
	@$(call extract, $(LIBPCAP_SOURCE))
	touch $@

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

libpcap_prepare: $(STATEDIR)/libpcap.prepare

#
# dependencies
#
libpcap_prepare_deps =  \
	$(STATEDIR)/libpcap.extract \
	$(STATEDIR)/virtual-xchain.install

LIBPCAP_PATH	=  PATH=$(CROSS_PATH)
LIBPCAP_ENV = \
	$(CROSS_ENV) \
	ac_cv_linux_vers=2


#
# autoconf
#
LIBPCAP_AUTOCONF = \
	--prefix=$(PTXCONF_PREFIX)/$(PTXCONF_GNU_TARGET) \
	--build=$(GNU_HOST) \
	--host=$(PTXCONF_GNU_TARGET) \
	--with-pcap=linux

$(STATEDIR)/libpcap.prepare: $(libpcap_prepare_deps)
	@$(call targetinfo, $@)
	@$(call clean, $(LIBPCAP_BUILDDIR))
	cd $(LIBPCAP_DIR) && \
		$(LIBPCAP_PATH) $(LIBPCAP_ENV) \
		./configure $(LIBPCAP_AUTOCONF)
	touch $@

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

libpcap_compile: $(STATEDIR)/libpcap.compile

libpcap_compile_deps = $(STATEDIR)/libpcap.prepare

$(STATEDIR)/libpcap.compile: $(libpcap_compile_deps)
	@$(call targetinfo, $@)
	$(LIBPCAP_PATH) make -C $(LIBPCAP_DIR)
	touch $@

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

libpcap_install: $(STATEDIR)/libpcap.install

$(STATEDIR)/libpcap.install: $(STATEDIR)/libpcap.compile
	@$(call targetinfo, $@)
	$(LIBPCAP_PATH) make -C $(LIBPCAP_DIR) install
	touch $@

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

libpcap_targetinstall: $(STATEDIR)/libpcap.targetinstall

libpcap_targetinstall_deps =  $(STATEDIR)/libpcap.install

$(STATEDIR)/libpcap.targetinstall: $(libpcap_targetinstall_deps)
	@$(call targetinfo, $@)
	touch $@

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

libpcap_clean:
	rm -rf $(STATEDIR)/libpcap.*
	rm -rf $(LIBPCAP_DIR)

# vim: syntax=make
