# -*-makefile-*-
# $Id: template 6655 2007-01-02 12:55:21Z rsc $
#
# Copyright (C) 2007 by Sascha Hauer
#               2008 by Marc Kleine-Budde
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_U_BOOT_V2) += u-boot-v2

#
# handle special compilers
#
ifdef PTXCONF_U_BOOT_V2
    ifneq ($(PTXCONF_COMPILER_PREFIX),$(PTXCONF_COMPILER_PREFIX_UBOOT))
        ifeq ($(wildcard .utoolchain/$(PTXCONF_COMPILER_PREFIX_UBOOT)gcc),)
            $(warning *** no .utoolchain link found. Please create a link)
            $(warning *** .utoolchain to the bin directory of your $(PTXCONF_COMPILER_PREFIX_UBOOT) toolchain)
            $(error )
        endif
        U_BOOT_V2_TOOLCHAIN_LINK := $(PTXDIST_WORKSPACE)/.utoolchain/
    endif
endif

#
# Paths and names
#
U_BOOT_V2_VERSION	:= $(call remove_quotes,$(PTXCONF_U_BOOT_V2_VERSION))
U_BOOT_V2		:= u-boot-$(U_BOOT_V2_VERSION)
U_BOOT_V2_SUFFIX	:= tar.gz
U_BOOT_V2_URL		:= http://www.pengutronix.de/software/u-boot/download/$(U_BOOT_V2).$(U_BOOT_V2_SUFFIX)
U_BOOT_V2_SOURCE	:= $(SRCDIR)/$(U_BOOT_V2).$(U_BOOT_V2_SUFFIX)
U_BOOT_V2_DIR		:= $(BUILDDIR)/$(U_BOOT_V2)

U_BOOT_V2_CONFIG	:= $(call remove_quotes, $(PTXDIST_PLATFORMCONFIGDIR)/$(PTXCONF_U_BOOT_V2_CONFIG))

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

$(STATEDIR)/u-boot-v2.get:
	@$(call targetinfo)
	@$(call touch)

$(U_BOOT_V2_SOURCE):
	@$(call targetinfo)
	@$(call get, U_BOOT_V2)

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

$(STATEDIR)/u-boot-v2.extract:
	@$(call targetinfo)
	@$(call clean, $(U_BOOT_V2_DIR))
	@$(call extract, U_BOOT_V2)
	@$(call patchin, U_BOOT_V2)
	@$(call touch)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

U_BOOT_V2_PATH	:= PATH=$(CROSS_PATH)
U_BOOT_V2_ENV 	:= KCONFIG_NOTIMESTAMP=1
U_BOOT_V2_MAKEVARS := \
	$(PARALLELMFLAGS) \
	HOSTCC=$(HOSTCC) \
	ARCH=$(PTXCONF_U_BOOT_V2_ARCH_STRING) \
	CROSS_COMPILE=$(U_BOOT_V2_TOOLCHAIN_LINK)$(PTXCONF_COMPILER_PREFIX_UBOOT)

ifdef PTXCONF_U_BOOT_V2
$(U_BOOT_V2_CONFIG):
	@echo
	@echo "*****************************************************************************"
	@echo "**** Please generate a u-boot config with 'ptxdist menuconfig u-boot-v2' ****"
	@echo "*****************************************************************************"
	@echo
	@echo
	@exit 1
endif

$(STATEDIR)/u-boot-v2.prepare: $(U_BOOT_V2_CONFIG)
	@$(call targetinfo)

	@if [ -f $(U_BOOT_V2_CONFIG) ]; then						\
		echo "Using U-Boot-v2 config file: $(U_BOOT_V2_CONFIG)";		\
		install -m 644 $(U_BOOT_V2_CONFIG) $(U_BOOT_V2_DIR)/.config;		\
	else										\
		echo "ERROR: No such u-boot config: $(U_BOOT_V2_CONFIG)";		\
		exit 1;									\
	fi

	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

$(STATEDIR)/u-boot-v2.compile:
	@$(call targetinfo)
	cd $(U_BOOT_V2_DIR) && $(U_BOOT_V2_PATH) $(MAKE) $(U_BOOT_V2_MAKEVARS)
	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/u-boot-v2.install:
	@$(call targetinfo)

	install -D -m755 $(U_BOOT_V2_DIR)/scripts/ubootenv $(PTXCONF_SYSROOT_HOST)/bin/ubootenv

	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/u-boot-v2.targetinstall:
	@$(call targetinfo)

	install -D -m644 $(U_BOOT_V2_DIR)/uboot.bin $(IMAGEDIR)/u-boot-v2-image

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

u-boot-v2_clean:
	rm -rf $(STATEDIR)/u-boot-v2.*
	rm -rf $(PKGDIR)/u-boot-v2_*
	rm -rf $(U_BOOT_V2_DIR)

# ----------------------------------------------------------------------------
# oldconfig / menuconfig
# ----------------------------------------------------------------------------

u-boot-v2_oldconfig u-boot-v2_menuconfig: $(STATEDIR)/u-boot-v2.extract
	@if test -e $(U_BOOT_V2_CONFIG); then \
		cp $(U_BOOT_V2_CONFIG) $(U_BOOT_V2_DIR)/.config; \
	fi
	cd $(U_BOOT_V2_DIR) && \
		$(U_BOOT_V2_PATH) $(U_BOOT_V2_ENV) $(MAKE) $(U_BOOT_V2_MAKEVARS) $(subst u-boot-v2_,,$@)
	@if cmp -s $(U_BOOT_V2_DIR)/.config $(U_BOOT_V2_CONFIG); then \
		echo "U-Boot-v2 configuration unchanged"; \
	else \
		cp $(U_BOOT_V2_DIR)/.config $(U_BOOT_V2_CONFIG); \
	fi

# vim: syntax=make
