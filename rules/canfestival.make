# -*-makefile-*-
# $Id: template-make 8785 2008-08-26 07:48:06Z wsa $
#
# Copyright (C) 2008 by Markus Messmer
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_CANFESTIVAL) += canfestival

#
# Paths and names
#
CANFESTIVAL_VERSION	:= 3-20081204-1
CANFESTIVAL		:= CanFestival-$(CANFESTIVAL_VERSION)
CANFESTIVAL_SUFFIX	:= tar.bz2
CANFESTIVAL_URL		:= http://www.pengutronix.de/software/ptxdist/temporary-src/$(CANFESTIVAL).$(CANFESTIVAL_SUFFIX)
CANFESTIVAL_SOURCE	:= $(SRCDIR)/$(CANFESTIVAL).$(CANFESTIVAL_SUFFIX)
CANFESTIVAL_DIR		:= $(BUILDDIR)/$(CANFESTIVAL)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

$(CANFESTIVAL_SOURCE):
	@$(call targetinfo)
	@$(call get, CANFESTIVAL)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

CANFESTIVAL_PATH	:= PATH=$(CROSS_PATH)
CANFESTIVAL_ENV 	:= $(CROSS_ENV_CC)
CANFESTIVAL_MAKEVARS	=  CFLAGS="-I$(KERNEL_DIR)/include"
#
# autoconf
#
CANFESTIVAL_AUTOCONF := \
	--prefix=/usr \
	--can=socket

ifdef PTXCONF_ENDIAN_BIG
	CANFESTIVAL_AUTOCONF += --CANOPEN_BIG_ENDIAN=1
endif

$(STATEDIR)/canfestival.prepare:
	@$(call targetinfo)
	@$(call clean, $(CANFESTIVAL_DIR)/config.cache)
	cd $(CANFESTIVAL_DIR) && \
		$(CANFESTIVAL_PATH) $(CANFESTIVAL_ENV) \
		./configure $(CANFESTIVAL_AUTOCONF)
	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

$(STATEDIR)/canfestival.compile:
	@$(call targetinfo)
	cd $(CANFESTIVAL_DIR) && $(CANFESTIVAL_PATH) $(MAKE) $(PARALLELMFLAGS) $(CANFESTIVAL_MAKEVARS)
	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/canfestival.install:
	@$(call targetinfo)
	@$(call install, CANFESTIVAL)
	@for file in objdictedit objdictgen; do \
		ln -sf $(PTXCONF_SYSROOT_TARGET)/usr/bin/"$${file}" $(PTXCONF_SYSROOT_HOST)/bin; \
	done

	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/canfestival.targetinstall:
	@$(call targetinfo)

	@$(call install_init, canfestival)
	@$(call install_fixup, canfestival,PACKAGE,canfestival)
	@$(call install_fixup, canfestival,PRIORITY,optional)
	@$(call install_fixup, canfestival,VERSION,$(CANFESTIVAL_VERSION))
	@$(call install_fixup, canfestival,SECTION,base)
	@$(call install_fixup, canfestival,AUTHOR,"Markus Messmer <m.messmer@pengutronix.de>")
	@$(call install_fixup, canfestival,DEPENDS,)
	@$(call install_fixup, canfestival,DESCRIPTION,missing)

	@$(call install_copy, canfestival, 0, 0, 0644, \
		$(CANFESTIVAL_DIR)/drivers/can_socket/libcanfestival_can_socket.so, \
		/usr/lib/libcanfestival_can_socket.so)

	@$(call install_finish, canfestival)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

canfestival_clean:
	rm -rf $(STATEDIR)/canfestival.*
	rm -rf $(PKGDIR)/canfestival_*
	rm -rf $(CANFESTIVAL_DIR)

# vim: syntax=make tabstop=8
