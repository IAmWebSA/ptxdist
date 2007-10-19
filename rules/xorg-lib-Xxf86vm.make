# -*-makefile-*-
# $Id: template 4565 2006-02-10 14:23:10Z mkl $
#
# Copyright (C) 2006 by Erwin Rol
#          
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_XORG_LIB_XXF86VM) += xorg-lib-Xxf86vm

#
# Paths and names
#
XORG_LIB_XXF86VM_VERSION	:= 1.0.1
XORG_LIB_XXF86VM		:= libXxf86vm-$(XORG_LIB_XXF86VM_VERSION)
XORG_LIB_XXF86VM_SUFFIX		:= tar.bz2
XORG_LIB_XXF86VM_URL		:= $(PTXCONF_SETUP_XORGMIRROR)/X11R7.3/src/lib/$(XORG_LIB_XXF86VM).$(XORG_LIB_XXF86VM_SUFFIX)
XORG_LIB_XXF86VM_SOURCE		:= $(SRCDIR)/$(XORG_LIB_XXF86VM).$(XORG_LIB_XXF86VM_SUFFIX)
XORG_LIB_XXF86VM_DIR		:= $(BUILDDIR)/$(XORG_LIB_XXF86VM)


# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

xorg-lib-Xxf86vm_get: $(STATEDIR)/xorg-lib-Xxf86vm.get

$(STATEDIR)/xorg-lib-Xxf86vm.get: $(xorg-lib-Xxf86vm_get_deps_default)
	@$(call targetinfo, $@)
	@$(call touch, $@)

$(XORG_LIB_XXF86VM_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, XORG_LIB_XXF86VM)

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

xorg-lib-Xxf86vm_extract: $(STATEDIR)/xorg-lib-Xxf86vm.extract

$(STATEDIR)/xorg-lib-Xxf86vm.extract: $(xorg-lib-Xxf86vm_extract_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(XORG_LIB_XXF86VM_DIR))
	@$(call extract, XORG_LIB_XXF86VM)
	@$(call patchin, XORG_LIB_XXF86VM)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

xorg-lib-Xxf86vm_prepare: $(STATEDIR)/xorg-lib-Xxf86vm.prepare

XORG_LIB_XXF86VM_PATH	:=  PATH=$(CROSS_PATH)
XORG_LIB_XXF86VM_ENV 	:=  $(CROSS_ENV)

#
# autoconf
#
XORG_LIB_XXF86VM_AUTOCONF := $(CROSS_AUTOCONF_USR)
XORG_LIB_XXF86VM_AUTOCONF += --disable-malloc0returnsnull

$(STATEDIR)/xorg-lib-Xxf86vm.prepare: $(xorg-lib-Xxf86vm_prepare_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(XORG_LIB_XXF86VM_DIR)/config.cache)
	cd $(XORG_LIB_XXF86VM_DIR) && \
		$(XORG_LIB_XXF86VM_PATH) $(XORG_LIB_XXF86VM_ENV) \
		./configure $(XORG_LIB_XXF86VM_AUTOCONF)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

xorg-lib-Xxf86vm_compile: $(STATEDIR)/xorg-lib-Xxf86vm.compile

$(STATEDIR)/xorg-lib-Xxf86vm.compile: $(xorg-lib-Xxf86vm_compile_deps_default)
	@$(call targetinfo, $@)
	cd $(XORG_LIB_XXF86VM_DIR) && $(XORG_LIB_XXF86VM_PATH) make
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

xorg-lib-Xxf86vm_install: $(STATEDIR)/xorg-lib-Xxf86vm.install

$(STATEDIR)/xorg-lib-Xxf86vm.install: $(xorg-lib-Xxf86vm_install_deps_default)
	@$(call targetinfo, $@)
	@$(call install, XORG_LIB_XXF86VM)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

xorg-lib-Xxf86vm_targetinstall: $(STATEDIR)/xorg-lib-Xxf86vm.targetinstall

$(STATEDIR)/xorg-lib-Xxf86vm.targetinstall: $(xorg-lib-Xxf86vm_targetinstall_deps_default)
	@$(call targetinfo, $@)

	@$(call install_init, xorg-lib-Xxf86vm)
	@$(call install_fixup, xorg-lib-Xxf86vm,PACKAGE,xorg-lib-xxf86vm)
	@$(call install_fixup, xorg-lib-Xxf86vm,PRIORITY,optional)
	@$(call install_fixup, xorg-lib-Xxf86vm,VERSION,$(XORG_LIB_XXF86VM_VERSION))
	@$(call install_fixup, xorg-lib-Xxf86vm,SECTION,base)
	@$(call install_fixup, xorg-lib-Xxf86vm,AUTHOR,"Erwin Rol <ero\@pengutronix.de>")
	@$(call install_fixup, xorg-lib-Xxf86vm,DEPENDS,)
	@$(call install_fixup, xorg-lib-Xxf86vm,DESCRIPTION,missing)

	@$(call install_copy, xorg-lib-Xxf86vm, 0, 0, 0644, \
		$(XORG_LIB_XXF86VM_DIR)/src/.libs/libXxf86vm.so.1.0.0, \
		$(XORG_LIBDIR)/libXxf86vm.so.1.0.0)

	@$(call install_link, xorg-lib-Xxf86vm, \
		libXxf86vm.so.1.0.0, \
		$(XORG_LIBDIR)/libXxf86vm.so.1)

	@$(call install_link, xorg-lib-Xxf86vm, \
		libXxf86vm.so.1.0.0, \
		$(XORG_LIBDIR)/libXxf86vm.so)

	@$(call install_finish, xorg-lib-Xxf86vm)

	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

xorg-lib-Xxf86vm_clean:
	rm -rf $(STATEDIR)/xorg-lib-Xxf86vm.*
	rm -rf $(IMAGEDIR)/xorg-lib-Xxf86vm_*
	rm -rf $(XORG_LIB_XXF86VM_DIR)

# vim: syntax=make
