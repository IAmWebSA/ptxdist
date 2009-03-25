# -*-makefile-*-
# $Id: template-make 7626 2007-11-26 10:27:03Z mkl $
#
# Copyright (C) 2008 by Robert Schwebel
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_UTIL_LINUX_NG) += util-linux-ng

#
# Paths and names
#
UTIL_LINUX_NG_VERSION	:= 2.14.2
UTIL_LINUX_NG		:= util-linux-ng-$(UTIL_LINUX_NG_VERSION)
UTIL_LINUX_NG_SUFFIX	:= tar.bz2
UTIL_LINUX_NG_URL	:= http://ftp.kernel.org/pub/linux/utils/util-linux-ng/v2.14/$(UTIL_LINUX_NG).$(UTIL_LINUX_NG_SUFFIX)
UTIL_LINUX_NG_SOURCE	:= $(SRCDIR)/$(UTIL_LINUX_NG).$(UTIL_LINUX_NG_SUFFIX)
UTIL_LINUX_NG_DIR	:= $(BUILDDIR)/$(UTIL_LINUX_NG)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

$(UTIL_LINUX_NG_SOURCE):
	@$(call targetinfo)
	@$(call get, UTIL_LINUX_NG)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

UTIL_LINUX_NG_PATH	:= PATH=$(CROSS_PATH)
UTIL_LINUX_NG_ENV 	:= \
	$(CROSS_ENV) \
	$(call ptx/ncurses, PTXCONF_UTIL_LINUX_NG_USES_NCURSES) \
	ac_cv_lib_termcap_tgetnum=no \
	ac_cv_path_BLKID=no \
	ac_cv_path_PERL=no \
	ac_cv_path_VOLID=no

#
# autoconf
#
UTIL_LINUX_NG_AUTOCONF := \
	$(CROSS_AUTOCONF_USR) \
	--$(call ptx/endis, PTXCONF_UTIL_LINUX_NG_USES_NCURSES)-ncurses \
	--disable-nls \
	--disable-rpath \
	--disable-agetty \
	--disable-cramfs \
	--disable-init \
	--disable-kill \
	--disable-last \
	--disable-mesg \
	--disable-partx \
	--disable-raw \
	--disable-rdev \
	--disable-rename \
	--disable-reset \
	--disable-login-utils \
	--disable-wall \
	--disable-write \
	--disable-chsh-only-listed \
	--disable-login-chown-vcs \
	--disable-login-stat-mail \
	--disable-pg-bell \
	--disable-require-password \
	--disable-use-tty-group \
	--without-pam \
	--without-slang \
	--without-selinux \
	--without-audit \
	--with-fsprobe=blkid

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/util-linux-ng.targetinstall:
	@$(call targetinfo)

	@$(call install_init, util-linux-ng)
	@$(call install_fixup, util-linux-ng,PACKAGE,util-linux-ng)
	@$(call install_fixup, util-linux-ng,PRIORITY,optional)
	@$(call install_fixup, util-linux-ng,VERSION,$(UTIL_LINUX_NG_VERSION))
	@$(call install_fixup, util-linux-ng,SECTION,base)
	@$(call install_fixup, util-linux-ng,AUTHOR,"Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup, util-linux-ng,DEPENDS,)
	@$(call install_fixup, util-linux-ng,DESCRIPTION,missing)

ifdef PTXCONF_UTIL_LINUX_NG_MKSWAP
	@$(call install_copy, util-linux-ng, 0, 0, 0755, $(UTIL_LINUX_NG_DIR)/disk-utils/mkswap, /sbin/mkswap)
endif
ifdef PTXCONF_UTIL_LINUX_NG_SWAPON
	@$(call install_copy, util-linux-ng, 0, 0, 0755, $(UTIL_LINUX_NG_DIR)/mount/swapon, /sbin/swapon)
endif
ifdef PTXCONF_UTIL_LINUX_NG_MOUNT
	@$(call install_copy, util-linux-ng, 0, 0, 0755, $(UTIL_LINUX_NG_DIR)/mount/mount, /bin/mount)
endif
ifdef PTXCONF_UTIL_LINUX_NG_UMOUNT
	@$(call install_copy, util-linux-ng, 0, 0, 0755, $(UTIL_LINUX_NG_DIR)/mount/umount, /bin/umount)
endif
ifdef PTXCONF_UTIL_LINUX_NG_IPCS
	@$(call install_copy, util-linux-ng, 0, 0, 0755, $(UTIL_LINUX_NG_DIR)/sys-utils/ipcs, /usr/bin/ipcs)
endif
ifdef PTXCONF_UTIL_LINUX_NG_READPROFILE
	@$(call install_copy, util-linux-ng, 0, 0, 0755, $(UTIL_LINUX_NG_DIR)/sys-utils/readprofile, /usr/sbin/readprofile)
endif
ifdef PTXCONF_UTIL_LINUX_NG_FDISK
	@$(call install_copy, util-linux-ng, 0, 0, 0755, $(UTIL_LINUX_NG_DIR)/fdisk/fdisk, /usr/sbin/fdisk)
endif
ifdef PTXCONF_UTIL_LINUX_NG_SFDISK
	@$(call install_copy, util-linux-ng, 0, 0, 0755, $(UTIL_LINUX_NG_DIR)/fdisk/sfdisk, /usr/sbin/sfdisk)
endif
ifdef PTXCONF_UTIL_LINUX_NG_CFDISK
	@$(call install_copy, util-linux-ng, 0, 0, 0755, $(UTIL_LINUX_NG_DIR)/fdisk/cfdisk, /usr/sbin/cfdisk)
endif
ifdef PTXCONF_UTIL_LINUX_NG_SETTERM
	@$(call install_copy, util-linux-ng, 0, 0, 0755, $(UTIL_LINUX_NG_DIR)/misc-utils/setterm, /usr/bin/setterm)
endif
ifdef PTXCONF_UTIL_LINUX_NG_CHRT
	@$(call install_copy, util-linux-ng, 0, 0, 0755, $(UTIL_LINUX_NG_DIR)/schedutils/chrt, /usr/bin/chrt)
endif
ifdef PTXCONF_UTIL_LINUX_NG_IONICE
	@$(call install_copy, util-linux-ng, 0, 0, 0755, $(UTIL_LINUX_NG_DIR)/schedutils/ionice, /usr/bin/ionice)
endif
ifdef PTXCONF_UTIL_LINUX_NG_TASKSET
	@$(call install_copy, util-linux-ng, 0, 0, 0755, $(UTIL_LINUX_NG_DIR)/schedutils/taskset, /usr/bin/taskset)
endif


	@$(call install_finish, util-linux-ng)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

util-linux-ng_clean:
	rm -rf $(STATEDIR)/util-linux-ng.*
	rm -rf $(PKGDIR)/util-linux-ng_*
	rm -rf $(UTIL_LINUX_NG_DIR)

# vim: syntax=make
