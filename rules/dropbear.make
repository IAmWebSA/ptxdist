# -*-makefile-*-
# $Id$
#
# Copyright (C) 2003 by Marc Kleine-Budde <kleine-budde@gmx.de> for
#                       Pengutronix e.K. <info@pengutronix.de>, Germany
#          
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_DROPBEAR) += dropbear

#
# Paths and names
#
DROPBEAR_VERSION		= 0.43
DROPBEAR			= dropbear-$(DROPBEAR_VERSION)
DROPBEAR_SUFFIX			= tar.bz2
DROPBEAR_URL			= http://matt.ucc.asn.au/dropbear/releases/$(DROPBEAR).$(DROPBEAR_SUFFIX)
DROPBEAR_SOURCE			= $(SRCDIR)/$(DROPBEAR).$(DROPBEAR_SUFFIX)
DROPBEAR_DIR			= $(BUILDDIR)/$(DROPBEAR)


# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

dropbear_get: $(STATEDIR)/dropbear.get

$(STATEDIR)/dropbear.get: $(dropbear_get_deps_default)
	@$(call targetinfo, $@)
	@$(call touch, $@)

$(DROPBEAR_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, DROPBEAR)

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

dropbear_extract: $(STATEDIR)/dropbear.extract

$(STATEDIR)/dropbear.extract: $(dropbear_extract_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(DROPBEAR_DIR))
	@$(call extract, DROPBEAR)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

dropbear_prepare: $(STATEDIR)/dropbear.prepare

DROPBEAR_PATH	=  PATH=$(CROSS_PATH)
DROPBEAR_ENV 	=  $(CROSS_ENV)

#
# autoconf
#
DROPBEAR_AUTOCONF	=  $(CROSS_AUTOCONF_USR)
DROPBEAR_AUTOCONF	+= --disable-nls

ifdef PTXCONF_DROPBEAR_DIS_ZLIB
DROPBEAR_AUTOCONF	+= --disable-zlib
endif

ifdef PTXCONF_DROPBEAR_DIS_OPENPTY
DROPBEAR_AUTOCONF	+= --disable-openpty
endif

ifdef PTXCONF_DROPBEAR_DIS_SYSLOG
DROPBEAR_AUTOCONF	+= --disable-syslog
endif

ifdef PTXCONF_DROPBEAR_DIS_LASTLOG
DROPBEAR_AUTOCONF	+= --disable-lastlog
endif

ifdef PTXCONF_DROPBEAR_DIS_UTMP
DROPBEAR_AUTOCONF	+= --disable-utmp
endif

ifdef PTXCONF_DROPBEAR_DIS_UTMPX
DROPBEAR_AUTOCONF	+= --disable-utmpx
endif

ifdef PTXCONF_DROPBEAR_DIS_WTMP
DROPBEAR_AUTOCONF	+= --disable-wtmp
endif

ifdef PTXCONF_DROPBEAR_DIS_WTMPX
DROPBEAR_AUTOCONF	+= --disable-wtmpx
endif

ifdef PTXCONF_DROPBEAR_DIS_LIBUTIL
DROPBEAR_AUTOCONF	+= --disable-libutil
endif

ifdef PTXCONF_DROPBEAR_DIS_PUTUTLINE
DROPBEAR_AUTOCONF	+= --disable-pututline
endif

ifdef PTXCONF_DROPBEAR_DIS_PUTUTXLINE
DROPBEAR_AUTOCONF	+= --disable-pututxline
endif

$(STATEDIR)/dropbear.prepare: $(dropbear_prepare_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(DROPBEAR_BUILDDIR))
	cd $(DROPBEAR_DIR) && \
		$(DROPBEAR_PATH) $(DROPBEAR_ENV) \
		$(DROPBEAR_DIR)/configure $(DROPBEAR_AUTOCONF)

ifdef PTXCONF_DROPBEAR_DIS_X11
	@$(call enable_c, $(DROPBEAR_DIR)/options.h,DISABLE_X11FWD)
else
	@$(call disable_c, $(DROPBEAR_DIR)/options.h,DISABLE_X11FWD)
endif

ifdef PTXCONF_DROPBEAR_DIS_TCP
	@$(call enable_c, $(DROPBEAR_DIR)/options.h,DISABLE_TCPFWD)
else
	@$(call disable_c, $(DROPBEAR_DIR)/options.h,DISABLE_TCPFWD)
endif

ifdef PTXCONF_DROPBEAR_DIS_AGENT
	@$(call enable_c, $(DROPBEAR_DIR)/options.h,DISABLE_AGENTFWD)
else
	@$(call disable_c, $(DROPBEAR_DIR)/options.h,DISABLE_AGENTFWD)
endif


ifdef PTXCONF_DROPBEAR_AES128
	@$(call enable_c, $(DROPBEAR_DIR)/options.h,DROPBEAR_AES128_CBC)
else
	@$(call disable_c, $(DROPBEAR_DIR)/options.h,DROPBEAR_AES128_CBC)
endif

ifdef PTXCONF_DROPBEAR_BLOWFISH
	@$(call enable_c, $(DROPBEAR_DIR)/options.h,DROPBEAR_BLOWFISH_CBC)
else
	@$(call disable_c, $(DROPBEAR_DIR)/options.h,DROPBEAR_BLOWFISH_CBC)
endif

ifdef PTXCONF_DROPBEAR_TWOFISH123
	@$(call enable_c, $(DROPBEAR_DIR)/options.h,DROPBEAR_TWOFISH128_CBC)
else
	@$(call disable_c, $(DROPBEAR_DIR)/options.h,DROPBEAR_TWOFISH128_CBC)
endif

ifdef PTXCONF_DROPBEAR_3DES
	@$(call enable_c, $(DROPBEAR_DIR)/options.h,DROPBEAR_3DES_CBC)
else
	@$(call disable_c, $(DROPBEAR_DIR)/options.h,DROPBEAR_3DES_CBC)
endif


ifdef PTXCONF_DROPBEAR_SHA1
	@$(call enable_c, $(DROPBEAR_DIR)/options.h,DROPBEAR_SHA1_HMAC)
else
	@$(call disable_c, $(DROPBEAR_DIR)/options.h,DROPBEAR_SHA1_HMAC)
endif

ifdef PTXCONF_DROPBEAR_MD5
	@$(call enable_c, $(DROPBEAR_DIR)/options.h,DROPBEAR_MD5_HMAC)
else
	@$(call disable_c, $(DROPBEAR_DIR)/options.h,DROPBEAR_MD5_HMAC)
endif


ifdef PTXCONF_DROPBEAR_RSA
	@$(call enable_c, $(DROPBEAR_DIR)/options.h,DROPBEAR_RSA)
else
	@$(call disable_c, $(DROPBEAR_DIR)/options.h,DROPBEAR_RSA)
endif

ifdef PTXCONF_DROPBEAR_DSS
	@$(call enable_c, $(DROPBEAR_DIR)/options.h,DROPBEAR_DSS)
else
	@$(call disable_c, $(DROPBEAR_DIR)/options.h,DROPBEAR_DSS)
endif

ifdef PTXCONF_DROPBEAR_PASSWD
	@$(call enable_c, $(DROPBEAR_DIR)/options.h,DROPBEAR_PASSWORD_AUTH)
else
	@$(call disable_c, $(DROPBEAR_DIR)/options.h,DROPBEAR_PASSWORD_AUTH)
endif

ifdef PTXCONF_DROPBEAR_PUBKEY
	@$(call enable_c, $(DROPBEAR_DIR)/options.h,DROPBEAR_PUBKEY_AUTH)
else
	@$(call disable_c, $(DROPBEAR_DIR)/options.h,DROPBEAR_PUBKEY_AUTH)
endif

	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

dropbear_compile: $(STATEDIR)/dropbear.compile

$(STATEDIR)/dropbear.compile: $(dropbear_compile_deps_default)
	@$(call targetinfo, $@)
	cd $(DROPBEAR_DIR) && $(DROPBEAR_ENV) $(DROPBEAR_PATH) make dropbear

ifdef PTXCONF_DROPBEAR_DROPBEAR_KEY
	cd $(DROPBEAR_DIR) && $(DROPBEAR_ENV) $(DROPBEAR_PATH) make dropbearkey
endif

ifdef PTXCONF_DROPBEAR_DROPBEAR_CONVERT
	cd $(DROPBEAR_DIR) && $(DROPBEAR_ENV) $(DROPBEAR_PATH) make dropbearconvert
endif

ifdef PTXCONF_DROPBEAR_SCP
	cd $(DROPBEAR_DIR) && $(DROPBEAR_ENV) $(DROPBEAR_PATH) make scp
endif
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

dropbear_install: $(STATEDIR)/dropbear.install

$(STATEDIR)/dropbear.install: $(dropbear_install_deps_default)
	@$(call targetinfo, $@)
	# FIXME
	# @$(call install, DROPBEAR)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

dropbear_targetinstall: $(STATEDIR)/dropbear.targetinstall

$(STATEDIR)/dropbear.targetinstall: $(dropbear_targetinstall_deps_default)
	@$(call targetinfo, $@)

	@$(call install_init, dropbear)
	@$(call install_fixup, dropbear,PACKAGE,dropbear)
	@$(call install_fixup, dropbear,PRIORITY,optional)
	@$(call install_fixup, dropbear,VERSION,$(DROPBEAR_VERSION))
	@$(call install_fixup, dropbear,SECTION,base)
	@$(call install_fixup, dropbear,AUTHOR,"Robert Schwebel <r.schwebel\@pengutronix.de>")
	@$(call install_fixup, dropbear,DEPENDS,)
	@$(call install_fixup, dropbear,DESCRIPTION,missing)

ifdef PTXCONF_DROPBEAR_DROPBEAR
	@$(call install_copy, dropbear, 0, 0, 0755, $(DROPBEAR_DIR)/dropbear, /usr/sbin/dropbear)
endif

ifdef PTXCONF_DROPBEAR_DROPBEAR_KEY
	@$(call install_copy, dropbear, 0, 0, 0755, $(DROPBEAR_DIR)/dropbearkey, /usr/sbin/dropbearkey)
endif

ifdef PTXCONF_DROPBEAR_DROPBEAR_CONVERT
	@$(call install_copy, dropbear, 0, 0, 0755, $(DROPBEAR_DIR)/dropbearconvert, /usr/sbin/dropbearconvert)
endif

ifdef PTXCONF_DROPBEAR_SCP
	@$(call install_copy, dropbear, 0, 0, 0755, $(DROPBEAR_DIR)/scp, /usr/bin/scp)
endif

	@$(call install_finish, dropbear)

	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

dropbear_clean:
	rm -rf $(STATEDIR)/dropbear.*
	rm -rf $(IMAGEDIR)/dropbear_*
	rm -rf $(DROPBEAR_DIR)

# vim: syntax=make
