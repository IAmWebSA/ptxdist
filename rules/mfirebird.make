# -*-makefile-*-
# $Id: mfirebird.make,v 1.3 2003/08/22 15:32:11 robert Exp $
#
# (c) 2003 by Robert Schwebel <r.schwebel@pengutronix.de>, 
#             Pengutronix e.K. <info@pengutronix.de>, Germany
#          
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXDIST project and license conditions
# see the README file.
#

#
# We provide this package
#
ifdef PTXCONF_MFIREBIRD
PACKAGES += mfirebird
endif

#
# Paths and names
#
MFIREBIRD_VERSION		= 0.6.1
MFIREBIRD			= MozillaFirebird-source-$(MFIREBIRD_VERSION)
MFIREBIRD_SUFFIX		= tar.bz2
MFIREBIRD_URL			= http://ftp.mozilla.org/pub/firebird/releases/0.6.1/$(MFIREBIRD).$(MFIREBIRD_SUFFIX)
MFIREBIRD_SOURCE		= $(SRCDIR)/$(MFIREBIRD).$(MFIREBIRD_SUFFIX)
MFIREBIRD_DIR			= $(BUILDDIR)/$(MFIREBIRD)

MFIREBIRD_PATCH			= MozillaFirebird-source-$(MFIREBIRD_VERSION)-ptx3.diff
MFIREBIRD_PATCH_URL		= http://www.pengutronix.de/software/ptxdist/temporary-src/$(MFIREBIRD_PATCH)
MFIREBIRD_PATCH_SOURCE		= $(SRCDIR)/$(MFIREBIRD_PATCH)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

mfirebird_get: $(STATEDIR)/mfirebird.get

mfirebird_get_deps		=  $(MFIREBIRD_SOURCE)
mfirebird_get_deps		+= $(MFIREBIRD_PATCH_SOURCE)

$(STATEDIR)/mfirebird.get: $(mfirebird_get_deps)
	@$(call targetinfo, mfirebird.get)
	touch $@

$(MFIREBIRD_SOURCE):
	@$(call targetinfo, $(MFIREBIRD_SOURCE))
	@$(call get, $(MFIREBIRD_URL))

$(MFIREBIRD_PATCH_SOURCE):
	@$(call targetinfo, $(MFIREBIRD_PATCH_SOURCE))
	@$(call get, $(MFIREBIRD_PATCH_URL))

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

mfirebird_extract: $(STATEDIR)/mfirebird.extract

mfirebird_extract_deps	=  $(STATEDIR)/mfirebird.get

$(STATEDIR)/mfirebird.extract: $(mfirebird_extract_deps)
	@$(call targetinfo, mfirebird.extract)
	@$(call clean, $(MFIREBIRD_DIR))
	@$(call extract, $(MFIREBIRD_SOURCE))
	
	cd $(BUILDDIR) && mv mozilla $(MFIREBIRD)
	
	touch $@

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

mfirebird_prepare: $(STATEDIR)/mfirebird.prepare

#
# dependencies
#
mfirebird_prepare_deps =  \
	$(STATEDIR)/mfirebird.extract \
	$(STATEDIR)/gtk1210.install \
	$(STATEDIR)/libidl068.install \
#	$(STATEDIR)/virtual-xchain.install \

MFIREBIRD_PATH	=  PATH=$(CROSS_PATH)
#MFIREBIRD_PATH	=  PATH=$(PTXCONF_PREFIX)/bin:$$PATH

MFIREBIRD_ENV	=  $(CROSS_ENV)
MFIREBIRD_ENV	+= MOZILLA_OFFICIAL=1
MFIREBIRD_ENV	+= BUILD_OFFICIAL=1
MFIREBIRD_ENV	+= MOZ_PHOENIX=1
MFIREBIRD_ENV	+= ac_cv_have_x='have_x=yes ac_x_includes=$(PTXCONF_PREFIX)/$(PTXCONF_GNU_TARGET)/include ac_x_libraries=$(PTXCONF_PREFIX)/$(PTXCONF_GNU_TARGET)/lib'

#
# autoconf
#
MFIREBIRD_AUTOCONF	=  --prefix=/usr
MFIREBIRD_AUTOCONF	+= --build=$(GNU_HOST)
MFIREBIRD_AUTOCONF	+= --host=$(PTXCONF_GNU_TARGET)

#MFIREBIRD_AUTOCONF	+= --enable-default-toolkit=gtk

MFIREBIRD_AUTOCONF	+= --with-gtk-prefix=$(PTXCONF_PREFIX)/$(PTXCONF_GNU_TARGET)
MFIREBIRD_AUTOCONF	+= --with-glib-prefix=$(PTXCONF_PREFIX)/$(PTXCONF_GNU_TARGET)
MFIREBIRD_AUTOCONF	+= --disable-gtktest
MFIREBIRD_AUTOCONF	+= --disable-gdktest

MFIREBIRD_AUTOCONF	+= --disable-tests
MFIREBIRD_AUTOCONF	+= --disable-jsloader
MFIREBIRD_AUTOCONF	+= --disable-jsd
MFIREBIRD_AUTOCONF	+= --disable-oji
MFIREBIRD_AUTOCONF	+= --disable-xinerama
MFIREBIRD_AUTOCONF	+= --disable-calendar
MFIREBIRD_AUTOCONF	+= --disable-mailnews
MFIREBIRD_AUTOCONF	+= --disable-ldap
MFIREBIRD_AUTOCONF	+= --disable-freetype2
MFIREBIRD_AUTOCONF	+= --disable-freetypetest
MFIREBIRD_AUTOCONF	+= --disable-postscript
MFIREBIRD_AUTOCONF	+= --disable-xprint
MFIREBIRD_AUTOCONF	+= --disable-crypto
MFIREBIRD_AUTOCONF	+= --disable-accessability
MFIREBIRD_AUTOCONF	+= --enable-xfpe-components
#MFIREBIRD_AUTOCONF	+= --enable-single-profile
MFIREBIRD_AUTOCONF	+= --disable-composer
MFIREBIRD_AUTOCONF	+= --disable-mathml
MFIREBIRD_AUTOCONF	+= --disable-svg
MFIREBIRD_AUTOCONF	+= --disable-installer
MFIREBIRD_AUTOCONF	+= --disable-activex

# g++ currently seems to have a bug with -pedantic (at least the
# configure script claims so)
MFIREBIRD_AUTOCONF	+= --disable-pedantic

##ifdef PTXCONF_MFIREBIRD_CALENDAR
##MFIREBIRD_AUTOCONF	+= --enable-calendar
##else
##MFIREBIRD_AUTOCONF	+= --disable-calendar
##endif

##ifdef PTXCONF_MFIREBIRD_MAILNEWS
##MFIREBIRD_AUTOCONF	+= --enable-mailnews
##else
##MFIREBIRD_AUTOCONF	+= --disable-mailnews
##endif

#ifdef PTXCONF_MFIREBIRD_MAILNEWS_STATICBUILD
#MFIREBIRD_AUTOCONF	+= --enable-static-mail
#else
#MFIREBIRD_AUTOCONF	+= --disable-static-mail
#endif
#
#ifdef PTXCONF_MFIREBIRD_LDAP
#MFIREBIRD_AUTOCONF	+= --enable-ldap
#else
#MFIREBIRD_AUTOCONF	+= --disable-ldap
#endif

ifdef PTXCONF_MFIREBIRD_FREETYPE2
MFIREBIRD_AUTOCONF	+= --enable-freetype2
else
MFIREBIRD_AUTOCONF	+= --disable-freetype2
endif

ifdef PTXCONF_MFIREBIRD_XFT
MFIREBIRD_AUTOCONF	+= --enable-xft
else
MFIREBIRD_AUTOCONF	+= --disable-xft
endif

#ifdef PTXCONF_MFIREBIRD_POSTSCRIPT
#MFIREBIRD_AUTOCONF	+= --enable-postscript
#else
#MFIREBIRD_AUTOCONF	+= --disable-postscript
#endif
#
#ifdef PTXCONF_MFIREBIRD_XPRINT
#MFIREBIRD_AUTOCONF	+= --enable-xprint
#else
#MFIREBIRD_AUTOCONF	+= --disable-xprint
#endif
#
#ifdef PTXCONF_MFIREBIRD_CRYPTO
#MFIREBIRD_AUTOCONF	+= --enable-crypto
#else
#MFIREBIRD_AUTOCONF	+= --disable-crypto
#endif
#
#ifdef PTXCONF_MFIREBIRD_JSD
#MFIREBIRD_AUTOCONF	+= --enable-jsd
#else
#MFIREBIRD_AUTOCONF	+= --disable-jsd
#endif
#
#ifdef PTXCONF_MFIREBIRD_OJI
#MFIREBIRD_AUTOCONF	+= --enable-oji
#else
#MFIREBIRD_AUTOCONF	+= --disable-oji
#endif
#
#ifdef PTXCONF_MFIREBIRD_XINERAMA
#MFIREBIRD_AUTOCONF	+= --enable-xinerama
#else
#MFIREBIRD_AUTOCONF	+= --disable-xinerama
#endif
#
#ifdef PTXCONF_MFIREBIRD_CTL
#MFIREBIRD_AUTOCONF	+= --enable-ctl
#else
#MFIREBIRD_AUTOCONF	+= --disable-ctl
#endif
#
#ifdef PTXCONF_MFIREBIRD_ACCESSABILITY
#MFIREBIRD_AUTOCONF	+= --enable-accessability
#else
#MFIREBIRD_AUTOCONF	+= --disable-accessability
#endif
#
#ifdef PTXCONF_MFIREBIRD_XFPE_COMP
#MFIREBIRD_AUTOCONF	+= --enable-xpfe-components
#else
#MFIREBIRD_AUTOCONF	+= --disable-xpfe-components
#endif
#
#ifdef PTXCONF_MFIREBIRD_XPINSTALL
#MFIREBIRD_AUTOCONF	+= --enable-xpinstall
#else
#MFIREBIRD_AUTOCONF	+= --disable-xpinstall
#endif
#
#ifdef PTXCONF_MFIREBIRD_SINGLE_PROFILE
#MFIREBIRD_AUTOCONF	+= --enable-single-profile
#else
#MFIREBIRD_AUTOCONF	+= --disable-single-profile
#endif
#
#ifdef PTXCONF_MFIREBIRD_JSLOADER
#MFIREBIRD_AUTOCONF	+= --enable-jsloader
#else
#MFIREBIRD_AUTOCONF	+= --disable-jsloader
#endif
#
#ifdef PTXCONF_MFIREBIRD_NATIVE_UCONV
#MFIREBIRD_AUTOCONF	+= --enable-native-uconv
#else
#MFIREBIRD_AUTOCONF	+= --disable-native-uconv
#endif
#
#ifdef PTXCONF_MFIREBIRD_PLAINTEXT
#MFIREBIRD_AUTOCONF	+= --enable-plaintext-editor-only
#else
#MFIREBIRD_AUTOCONF	+= --disable-plaintext-editor-only
#endif

##ifdef PTXCONF_MFIREBIRD_COMPOSER
##MFIREBIRD_AUTOCONF	+= --enable-composer
##else
##MFIREBIRD_AUTOCONF	+= --disable-composer
##endif

#ifdef PTXCONF_MFIREBIRD_EXTENSIONS
#MFIREBIRD_AUTOCONF	+= --enable-extensions
#else
#MFIREBIRD_AUTOCONF	+= --disable-extensions
#endif
#
#ifdef PTXCONF_MFIREBIRD_IMAGE_DECODERS
#MFIREBIRD_AUTOCONF	+= --enable-extensions
#else
#MFIREBIRD_AUTOCONF	+= --disable-extensions
#endif
#
#ifdef PTXCONF_MFIREBIRD_IMAGE_DECODERS_MOD1
#MFIREBIRD_AUTOCONF	+= --enable-image-decoders=mod1
#endif
#
#ifdef PTXCONF_MFIREBIRD_IMAGE_DECODERS_MOD2
#MFIREBIRD_AUTOCONF	+= --enable-image-decoders=mod2
#endif
#
#ifdef PTXCONF_MFIREBIRD_MATHML
#MFIREBIRD_AUTOCONF	+= --enable-mathml 
#else
#MFIREBIRD_AUTOCONF	+= --disable-mathml
#endif
#
#ifdef PTXCONF_MFIREBIRD_SVG
#MFIREBIRD_AUTOCONF	+= --enable-svg
#else
#MFIREBIRD_AUTOCONF	+= --disable-svg
#endif
#
#ifdef PTXCONF_MFIREBIRD_INSTALLER
#MFIREBIRD_AUTOCONF	+= --enable-installer
#else
#MFIREBIRD_AUTOCONF	+= --disable-installer
#endif
#
#ifdef PTXCONF_MFIREBIRD_LEAKY
#MFIREBIRD_AUTOCONF	+= --enable-leaky
#else
#MFIREBIRD_AUTOCONF	+= --disable-leaky
#endif
#
#ifdef PTXCONF_MFIREBIRD_XPCTOOLS
#MFIREBIRD_AUTOCONF	+= --enable-xpctools
#else
#MFIREBIRD_AUTOCONF	+= --disable-xpctools
#endif
#
#ifdef PTXCONF_MFIREBIRD_TESTS
#MFIREBIRD_AUTOCONF	+= --enable-tests
#else
#MFIREBIRD_AUTOCONF	+= --disable-tests
#endif
#
#ifdef PTXCONF_MFIREBIRD_XPCOM_LEA
#MFIREBIRD_AUTOCONF	+= --enable-xpcom-lea
#else
#MFIREBIRD_AUTOCONF	+= --disable-xpcom-lea
#endif
#
#ifdef PTXCONF_MFIREBIRD_DEBUG
#MFIREBIRD_AUTOCONF	+= --enable-debug
#else
#MFIREBIRD_AUTOCONF	+= --disable-debug
#endif
#
#ifdef PTXCONF_MFIREBIRD_BOEHM
#MFIREBIRD_AUTOCONF	+= --enable-boehm
#else
#MFIREBIRD_AUTOCONF	+= --disable-boehm
#endif
#
#ifdef PTXCONF_MFIREBIRD_LOGGING
#MFIREBIRD_AUTOCONF	+= --enable-logging
#else
#MFIREBIRD_AUTOCONF	+= --disable-logging
#endif
#
#ifdef PTXCONF_MFIREBIRD_CRASH_ASSERT
#MFIREBIRD_AUTOCONF	+= --enable-crash-on-assert
#else
#MFIREBIRD_AUTOCONF	+= --disable-crash-on-assert
#endif
#
#ifdef PTXCONF_MFIREBIRD_TIMELINE
#MFIREBIRD_AUTOCONF	+= --enable-timeline
#else
#MFIREBIRD_AUTOCONF	+= --disable-timeline
#endif
#
#ifdef PTXCONF_MFIREBIRD_XTERM_UPDATE
#MFIREBIRD_AUTOCONF	+= --enable-xterm-updates
#else
#MFIREBIRD_AUTOCONF	+= --disable-xterm-updates
#endif
#
#ifdef PTXCONF_MFIREBIRD_SHARED
#MFIREBIRD_AUTOCONF	+= --enable-shared
#else
#MFIREBIRD_AUTOCONF	+= --enable-static
#endif
#
#ifdef PTXCONF_MFIREBIRD_COMPONENTLIB
#MFIREBIRD_AUTOCONF	+= --enable-componentlib
#else
#MFIREBIRD_AUTOCONF	+= --disable-componentlib
#endif
#
#ifdef PTXCONF_MFIREBIRD_XUL
#MFIREBIRD_AUTOCONF	+= --enable-xul
#else
#MFIREBIRD_AUTOCONF	+= --disable-xul
#endif
#
#ifdef PTXCONF_MFIREBIRD_PROFILE_SHARING
#MFIREBIRD_AUTOCONF	+= --enable-profilesharing
#else
#MFIREBIRD_AUTOCONF	+= --disable-profilesharing
#endif
#
#ifdef PTXCONF_MFIREBIRD_PROFILE_LOCKING
#MFIREBIRD_AUTOCONF	+= --enable-profilelocking
#else
#MFIREBIRD_AUTOCONF	+= --disable-profilelocking
#endif
#
#ifdef PTXCONF_MFIREBIRD_NECKO_PROTOCOLS_FTP
#MFIREBIRD_AUTOCONF	+= --enable-necko-protocols=ftp
#endif
#
#ifdef PTXCONF_MFIREBIRD_NECKO_PROTOCOLS_HTTP
#MFIREBIRD_AUTOCONF	+= --enable-necko-protocols=http
#endif
#
#ifdef PTXCONF_MFIREBIRD_NECKO_CACHE
#MFIREBIRD_AUTOCONF	+= --enable-necko-disk-cache
#else
#MFIREBIRD_AUTOCONF	+= --disable-necko-disk-cache
#endif
#
#ifdef PTXCONF_MFIREBIRD_NECKO_SMALLBUF
#MFIREBIRD_AUTOCONF	+= --enable-necko-small-buffers
#else
#MFIREBIRD_AUTOCONF	+= --disable-necko-small-buffers
#endif

$(STATEDIR)/mfirebird.prepare: $(mfirebird_prepare_deps)
	@$(call targetinfo, mfirebird.prepare)
	@$(call clean, $(MFIREBIRD_BUILDDIR))
	cd $(MFIREBIRD_DIR) && \
		$(MFIREBIRD_PATH) $(MFIREBIRD_ENV) \
		./configure $(MFIREBIRD_AUTOCONF)
	touch $@

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

mfirebird_compile: $(STATEDIR)/mfirebird.compile

mfirebird_compile_deps =  $(STATEDIR)/mfirebird.prepare

$(STATEDIR)/mfirebird.compile: $(mfirebird_compile_deps)
	@$(call targetinfo, mfirebird.compile)
	$(MFIREBIRD_PATH) $(MFIREBIRD_ENV) make -C $(MFIREBIRD_DIR)
	touch $@

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

mfirebird_install: $(STATEDIR)/mfirebird.install

$(STATEDIR)/mfirebird.install: $(STATEDIR)/mfirebird.compile
	@$(call targetinfo, mfirebird.install)
	touch $@

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

mfirebird_targetinstall: $(STATEDIR)/mfirebird.targetinstall

mfirebird_targetinstall_deps	=  $(STATEDIR)/mfirebird.compile
mfirebird_targetinstall_deps	+= $(STATEDIR)/gtk1210.targetinstall

$(STATEDIR)/mfirebird.targetinstall: $(mfirebird_targetinstall_deps)
	@$(call targetinfo, mfirebird.targetinstall)

	cd $(MFIREBIRD_DIR) && make install DESTDIR=$(ROOTDIR)

	touch $@

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

mfirebird_clean:
	rm -rf $(STATEDIR)/mfirebird.*
	rm -rf $(MFIREBIRD_DIR)

# vim: syntax=make
