# -*-makefile-*-
#
# Copyright (C) 2016 by Florian Scherf <f.scherf@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_PYTHON3_PEXPECT) += python3-pexpect

#
# Paths and names
#
PYTHON3_PEXPECT_VERSION	:= 4.0.1
PYTHON3_PEXPECT_MD5	:= 056df81e6ca7081f1015b4b147b977b7
PYTHON3_PEXPECT		:= pexpect-$(PYTHON3_PEXPECT_VERSION)
PYTHON3_PEXPECT_SUFFIX	:= tar.gz
PYTHON3_PEXPECT_URL	:= https://pypi.python.org/packages/source/p/pexpect/$(PYTHON3_PEXPECT).$(PYTHON3_PEXPECT_SUFFIX)\#md5=$(PYTHON3_PEXPECT_MD5)
PYTHON3_PEXPECT_SOURCE	:= $(SRCDIR)/$(PYTHON3_PEXPECT).$(PYTHON3_PEXPECT_SUFFIX)
PYTHON3_PEXPECT_DIR	:= $(BUILDDIR)/$(PYTHON3_PEXPECT)
PYTHON3_PEXPECT_LICENSE	:= ISC

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

PYTHON3_PEXPECT_CONF_TOOL	:= python3

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/python3-pexpect.targetinstall:
	@$(call targetinfo)

	@$(call install_init, python3-pexpect)
	@$(call install_fixup, python3-pexpect, PRIORITY, optional)
	@$(call install_fixup, python3-pexpect, SECTION, base)
	@$(call install_fixup, python3-pexpect, AUTHOR, "Florian Scherf <f.scherf@pengutronix.de>")
	@$(call install_fixup, python3-pexpect, DESCRIPTION, missing)

	@for file in `find $(PYTHON3_PEXPECT_PKGDIR)/usr/lib/python$(PYTHON3_MAJORMINOR)/site-packages/pexpect  \
			! -type d ! -name "*.py" -printf "%P\n"`; do \
		$(call install_copy, python3-pexpect, 0, 0, 0644, -, \
			/usr/lib/python$(PYTHON3_MAJORMINOR)/site-packages/pexpect/$$file); \
	done

	@$(call install_finish, python3-pexpect)

	@$(call touch)

# vim: syntax=make
