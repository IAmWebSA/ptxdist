# -*-makefile-*-
#
# Copyright (C) 2009 by Erwin Rol
#               2010, 2013 by Marc Kleine-Budde <mkl@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_LIBGCRYPT) += libgcrypt

#
# Paths and names
#
LIBGCRYPT_VERSION	:= 1.7.6
LIBGCRYPT_MD5		:= 54e180679a7ae4d090f8689ca32b654c
LIBGCRYPT		:= libgcrypt-$(LIBGCRYPT_VERSION)
LIBGCRYPT_SUFFIX	:= tar.bz2
LIBGCRYPT_URL		:= http://artfiles.org/gnupg.org/libgcrypt/$(LIBGCRYPT).$(LIBGCRYPT_SUFFIX) ftp://ftp.gnupg.org/gcrypt/libgcrypt/$(LIBGCRYPT).$(LIBGCRYPT_SUFFIX)
LIBGCRYPT_SOURCE	:= $(SRCDIR)/$(LIBGCRYPT).$(LIBGCRYPT_SUFFIX)
LIBGCRYPT_DIR		:= $(BUILDDIR)/$(LIBGCRYPT)
LIBGCRYPT_LICENSE	:= GPL-2.0, LGPL-2.0
LIBGCRYPT_LICENSE_FILES	:= \
	file://COPYING;md5=94d55d512a9ba36caa9b7df079bae19f \
	file://COPYING.LIB;md5=bbb461211a33b134d42ed5ee802b37ff

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

LIBGCRYPT_ASM := y
ifneq ($(PTXCONF_ARCH_M68K)$(PTXCONF_ARCH_PPC),)
LIBGCRYPT_ASM :=
endif

LIBGCRYPT_ENV := \
	$(CROSS_ENV)

ifdef PTXCONF_ARCH_X86
LIBGCRYPT_ENV += ac_cv_sys_symbol_underscore=no
endif

#
# autoconf
#
LIBGCRYPT_AUTOCONF := \
	$(CROSS_AUTOCONF_USR) \
	--disable-static \
	--enable-shared \
	--enable-random=linux \
	--enable-dev-random \
	--disable-random-daemon \
	--$(call ptx/endis,LIBGCRYPT_ASM)-asm \
	--disable-m-guard \
	--disable-large-data-tests \
	--disable-hmac-binary-check \
	--enable-padlock-support \
	--enable-aesni-support \
	--enable-pclmul-support \
	--enable-sse41-support \
	--enable-drng-support \
	--enable-avx-support \
	--enable-avx2-support \
	--$(call ptx/endis,PTXCONF_ARCH_ARM_NEON)-neon-support \
	--enable-arm-crypto-support \
	--enable-O-flag-munging \
	--disable-amd64-as-feature-detection \
	--enable-optimization \
	--enable-noexecstack \
	--disable-doc \
	--enable-build-timestamp="$(PTXDIST_VERSION_YEAR)-$(PTXDIST_VERSION_MONTH)-01T00:00+0000" \
	--with-capabilities

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/libgcrypt.targetinstall:
	@$(call targetinfo)

	@$(call install_init, libgcrypt)
	@$(call install_fixup, libgcrypt,PRIORITY,optional)
	@$(call install_fixup, libgcrypt,SECTION,base)
	@$(call install_fixup, libgcrypt,AUTHOR,"Erwin Rol")
	@$(call install_fixup, libgcrypt,DESCRIPTION,missing)

	@$(call install_lib, libgcrypt, 0, 0, 0644, libgcrypt)

	@$(call install_finish, libgcrypt)

	@$(call touch)

# vim: syntax=make
