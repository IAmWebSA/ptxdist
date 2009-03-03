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
DROPBEAR_VERSION	:= 0.50
DROPBEAR		:= dropbear-$(DROPBEAR_VERSION)
DROPBEAR_SUFFIX		:= tar.bz2
DROPBEAR_URL		:= http://matt.ucc.asn.au/dropbear/releases/$(DROPBEAR).$(DROPBEAR_SUFFIX)
DROPBEAR_SOURCE		:= $(SRCDIR)/$(DROPBEAR).$(DROPBEAR_SUFFIX)
DROPBEAR_DIR		:= $(BUILDDIR)/$(DROPBEAR)


# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

$(DROPBEAR_SOURCE):
	@$(call targetinfo)
	@$(call get, DROPBEAR)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

DROPBEAR_PATH	:=  PATH=$(CROSS_PATH)
DROPBEAR_ENV 	:=  $(CROSS_ENV)

#
# autoconf
#
DROPBEAR_AUTOCONF := \
	$(CROSS_AUTOCONF_USR) \
	--disable-nls

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

$(STATEDIR)/dropbear.prepare:
	@$(call targetinfo)
	@$(call clean, $(DROPBEAR_BUILDDIR))
	cd $(DROPBEAR_DIR) && \
		$(DROPBEAR_PATH) $(DROPBEAR_ENV) \
		$(DROPBEAR_DIR)/configure $(DROPBEAR_AUTOCONF)

# FIXME: rsc: write a proper autotoolization for these switches, it
# really doesn't work this way!!!

ifdef PTXCONF_DROPBEAR_DIS_X11
	@echo "ptxdist: disabling x11 forwarding"
	$(call disable_c, $(DROPBEAR_DIR)/options.h,ENABLE_X11FWD)
else
	@echo "ptxdist: enabling x11 forwarding"
	$(call enable_c, $(DROPBEAR_DIR)/options.h,ENSABLE_X11FWD)
endif

ifdef PTXCONF_DROPBEAR_DIS_TCP
	@echo "ptxdist: enabling tcp"
	@$(call enable_c, $(DROPBEAR_DIR)/options.h,DISABLE_TCPFWD)
else
	@echo "ptxdist: disabling tcp"
	@$(call disable_c, $(DROPBEAR_DIR)/options.h,DISABLE_TCPFWD)
endif

ifdef PTXCONF_DROPBEAR_DIS_AGENT
	@echo "ptxdist: enabling agent"
	@$(call enable_c, $(DROPBEAR_DIR)/options.h,DISABLE_AGENTFWD)
else
	@echo "ptxdist: disabling agent"
	@$(call disable_c, $(DROPBEAR_DIR)/options.h,DISABLE_AGENTFWD)
endif


ifdef PTXCONF_DROPBEAR_AES128
	@echo "ptxdist: enabling aes128"
	@$(call enable_c, $(DROPBEAR_DIR)/options.h,DISABLE_AGENTFWD)
	@$(call enable_c, $(DROPBEAR_DIR)/options.h,DROPBEAR_AES128_CBC)
else
	@echo "ptxdist: disabling aes128"
	@$(call disable_c, $(DROPBEAR_DIR)/options.h,DROPBEAR_AES128_CBC)
endif

ifdef PTXCONF_DROPBEAR_BLOWFISH
	@echo "ptxdist: enabling blowfish"
	@$(call enable_c, $(DROPBEAR_DIR)/options.h,DROPBEAR_BLOWFISH_CBC)
else
	@echo "ptxdist: disabling blowfish"
	@$(call disable_c, $(DROPBEAR_DIR)/options.h,DROPBEAR_BLOWFISH_CBC)
endif

ifdef PTXCONF_DROPBEAR_TWOFISH123
	@echo "ptxdist: enabling twofish123"
	@$(call enable_c, $(DROPBEAR_DIR)/options.h,DROPBEAR_TWOFISH128_CBC)
else
	@echo "ptxdist: disabling twofish123"
	@$(call disable_c, $(DROPBEAR_DIR)/options.h,DROPBEAR_TWOFISH128_CBC)
endif

ifdef PTXCONF_DROPBEAR_3DES
	@echo "ptxdist: enabling 3des"
	@$(call enable_c, $(DROPBEAR_DIR)/options.h,DROPBEAR_3DES_CBC)
else
	@echo "ptxdist: disabling 3des"
	@$(call disable_c, $(DROPBEAR_DIR)/options.h,DROPBEAR_3DES_CBC)
endif


ifdef PTXCONF_DROPBEAR_SHA1
	@echo "ptxdist: enabling sha1"
	@$(call enable_c, $(DROPBEAR_DIR)/options.h,DROPBEAR_SHA1_HMAC)
else
	@echo "ptxdist: disabling sha1"
	@$(call disable_c, $(DROPBEAR_DIR)/options.h,DROPBEAR_SHA1_HMAC)
endif

ifdef PTXCONF_DROPBEAR_MD5
	@echo "ptxdist: enabling md5"
	@$(call enable_c, $(DROPBEAR_DIR)/options.h,DROPBEAR_MD5_HMAC)
else
	@echo "ptxdist: disabling md5"
	@$(call disable_c, $(DROPBEAR_DIR)/options.h,DROPBEAR_MD5_HMAC)
endif


ifdef PTXCONF_DROPBEAR_RSA
	@echo "ptxdist: enabling rsa"
	@$(call enable_c, $(DROPBEAR_DIR)/options.h,DROPBEAR_RSA)
else
	@echo "ptxdist: disabling rsa"
	@$(call disable_c, $(DROPBEAR_DIR)/options.h,DROPBEAR_RSA)
endif

ifdef PTXCONF_DROPBEAR_DSS
	@echo "ptxdist: enabling dss"
	@$(call enable_c, $(DROPBEAR_DIR)/options.h,DROPBEAR_DSS)
else
	@echo "ptxdist: disabling dss"
	@$(call disable_c, $(DROPBEAR_DIR)/options.h,DROPBEAR_DSS)
endif

ifdef PTXCONF_DROPBEAR_PASSWD
	@echo "ptxdist: enabling passwd"
	@$(call enable_c, $(DROPBEAR_DIR)/options.h,DROPBEAR_PASSWORD_AUTH)
else
	@echo "ptxdist: disabling passwd"
	@$(call disable_c, $(DROPBEAR_DIR)/options.h,DROPBEAR_PASSWORD_AUTH)
endif

ifdef PTXCONF_DROPBEAR_PUBKEY
	@echo "ptxdist: enabling pubkey"
	@$(call enable_c, $(DROPBEAR_DIR)/options.h,DROPBEAR_PUBKEY_AUTH)
else
	@echo "ptxdist: disabling pubkey"
	@$(call disable_c, $(DROPBEAR_DIR)/options.h,DROPBEAR_PUBKEY_AUTH)
endif

	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

$(STATEDIR)/dropbear.compile:
	@$(call targetinfo)
	@cd $(DROPBEAR_DIR) && $(DROPBEAR_ENV) $(DROPBEAR_PATH) $(MAKE)

ifdef PTXCONF_DROPBEAR_SCP
	@cd $(DROPBEAR_DIR) && $(DROPBEAR_ENV) $(DROPBEAR_PATH) $(MAKE) scp
endif
	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/dropbear.install:
	@$(call targetinfo)
	# FIXME
	# @$(call install, DROPBEAR)
	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/dropbear.targetinstall:
	@$(call targetinfo)

	@$(call install_init, dropbear)
	@$(call install_fixup, dropbear,PACKAGE,dropbear)
	@$(call install_fixup, dropbear,PRIORITY,optional)
	@$(call install_fixup, dropbear,VERSION,$(DROPBEAR_VERSION))
	@$(call install_fixup, dropbear,SECTION,base)
	@$(call install_fixup, dropbear,AUTHOR,"Robert Schwebel <r.schwebel\@pengutronix.de>")
	@$(call install_fixup, dropbear,DEPENDS,)
	@$(call install_fixup, dropbear,DESCRIPTION,missing)

ifdef PTXCONF_DROPBEAR_DROPBEAR
	@$(call install_copy, dropbear, 0, 0, 0755, \
		$(DROPBEAR_DIR)/dropbear, /usr/sbin/dropbear)
endif

ifdef PTXCONF_DROPBEAR_DROPBEAR_KEY
	@$(call install_copy, dropbear, 0, 0, 0755, \
		$(DROPBEAR_DIR)/dropbearkey, /usr/sbin/dropbearkey)
endif

ifdef PTXCONF_DROPBEAR_DROPBEAR_CONVERT
	@$(call install_copy, dropbear, 0, 0, 0755, \
		$(DROPBEAR_DIR)/dropbearconvert, /usr/sbin/dropbearconvert)
endif

ifdef PTXCONF_DROPBEAR_SCP
	@$(call install_copy, dropbear, 0, 0, 0755, \
		$(DROPBEAR_DIR)/scp, /usr/bin/scp)
endif

#	#
#	# busybox init: start script
#	#

ifdef PTXCONF_INITMETHOD_BBINIT
ifdef PTXCONF_DROPBEAR_STARTSCRIPT
	@$(call install_alternative, dropbear, 0, 0, 0755, /etc/init.d/dropbear, n)
endif
endif

	@$(call install_copy, dropbear, 0, 0, 0755, /etc/dropbear)

	@$(call install_finish, dropbear)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

dropbear_clean:
	rm -rf $(STATEDIR)/dropbear.*
	rm -rf $(PKGDIR)/dropbear_*
	rm -rf $(DROPBEAR_DIR)

# vim: syntax=make
