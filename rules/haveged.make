# -*-makefile-*-
#
# Copyright (C) 2017 by Robert Schwebel <r.schwebel@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_HAVEGED) += haveged

#
# Paths and names
#
HAVEGED_VERSION	:= 1.9.1
HAVEGED_MD5	:= 015ff58cd10607db0e0de60aeca2f5f8
HAVEGED		:= haveged-$(HAVEGED_VERSION)
HAVEGED_SUFFIX	:= tar.gz
HAVEGED_URL	:= \
	http://www.issihosts.com/haveged/$(HAVEGED).$(HAVEGED_SUFFIX) \
	http://www.issihosts.com/haveged/archive/$(HAVEGED).$(HAVEGED_SUFFIX)
HAVEGED_SOURCE	:= $(SRCDIR)/$(HAVEGED).$(HAVEGED_SUFFIX)
HAVEGED_DIR	:= $(BUILDDIR)/$(HAVEGED)
HAVEGED_LICENSE	:= GPL-3.0

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
HAVEGED_CONF_TOOL	:= autoconf
HAVEGED_CONF_OPT	:= \
	$(CROSS_AUTOCONF_USR) \
	--enable-clock_gettime \
	--enable-daemon \
	--disable-diagnostic \
	--enable-init=service.fedora \
	--enable-initdir=/usr/lib/systemd/system \
	--disable-nistest \
	--disable-olt \
	--disable-threads \
	--enable-tune

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/haveged.targetinstall:
	@$(call targetinfo)

	@$(call install_init, haveged)
	@$(call install_fixup, haveged,PRIORITY,optional)
	@$(call install_fixup, haveged,SECTION,base)
	@$(call install_fixup, haveged,AUTHOR,"Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup, haveged,DESCRIPTION,missing)

	@$(call install_lib, haveged, 0, 0, 0644, libhavege)
	@$(call install_copy, haveged, 0, 0, 0755, -, /usr/sbin/haveged)

ifdef PTXCONF_INITMETHOD_SYSTEMD
	@$(call install_copy, haveged, 0, 0, 0644, -, /usr/lib/systemd/system/haveged.service)
	@$(call install_link, haveged, ../haveged.service, \
		/usr/lib/systemd/system/multi-user.target.wants/haveged.service)
endif

	@$(call install_finish, haveged)

	@$(call touch)

# vim: syntax=make
