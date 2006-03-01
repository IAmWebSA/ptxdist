# -*-makefile-*-
# $Id: template 2922 2005-07-11 19:17:53Z rsc $
#
# Copyright (C) 2005 by Robert Schwebel
#          
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_APACHE2) += apache2

#
# Paths and names
#
APACHE2_VERSION	:= 2.0.55
APACHE2		:= httpd-$(APACHE2_VERSION)
APACHE2_SUFFIX	:= tar.bz2
APACHE2_URL	:= http://ftp.plusline.de/ftp.apache.org/httpd/$(APACHE2).$(APACHE2_SUFFIX)
APACHE2_SOURCE	:= $(SRCDIR)/$(APACHE2).$(APACHE2_SUFFIX)
APACHE2_DIR	:= $(BUILDDIR)/$(APACHE2)

-include $(call package_depfile)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

apache2_get: $(STATEDIR)/apache2.get

$(STATEDIR)/apache2.get: $(apache2_get_deps_default)
	@$(call targetinfo, $@)
	@$(call touch, $@)

$(APACHE2_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, $(APACHE2_URL))

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

apache2_extract: $(STATEDIR)/apache2.extract

$(STATEDIR)/apache2.extract: $(apache2_extract_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(APACHE2_DIR))
	@$(call extract, $(APACHE2_SOURCE))
	@$(call patchin, $(APACHE2))
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

apache2_prepare: $(STATEDIR)/apache2.prepare

APACHE2_PATH	=  PATH=$(CROSS_PATH)
# FIXME: find a real patch for ac_* apr_* (fix configure script)
APACHE2_ENV 	=  $(CROSS_ENV) \
	PKG_CONFIG_PATH=$(CROSS_LIB_DIR)/lib/pkgconfig \
	ac_cv_sizeof_ssize_t=4 \
	ac_cv_sizeof_size_t=4 \
	apr_cv_process_shared_works=yes \
	ac_cv_func_setpgrp_void=yes

#
# autoconf
#
APACHE2_AUTOCONF =  $(CROSS_AUTOCONF_USR)

$(STATEDIR)/apache2.prepare: $(apache2_prepare_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(APACHE2_DIR)/config.cache)
	cd $(APACHE2_DIR) && \
		$(APACHE2_PATH) $(APACHE2_ENV) \
		./configure $(APACHE2_AUTOCONF)

	#
	# Tweak, Tweak ...
	#
	# The original object files are also used for other binaries, so 
	# we generate a dummy dependency here
	#
	perl -i -p -e "s/^gen_test_char_OBJECTS =.*$$/gen_test_char_OBJECTS = dummy.lo/g" $(APACHE2_DIR)/server/Makefile

	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

apache2_compile: $(STATEDIR)/apache2.compile

$(STATEDIR)/apache2.compile: $(apache2_compile_deps_default)
	@$(call targetinfo, $@)

	#
	# Tweak, tweak...
	#
	# These files are run during compilation, so they have to be
	# compiled for the host, not for the target
	#
	touch $(APACHE2_DIR)/srclib/apr-util/uri/gen_uri_delims.lo
	cp $(HOST_APACHE2_DIR)/srclib/apr-util/uri/gen_uri_delims $(APACHE2_DIR)/srclib/apr-util/uri/gen_uri_delims
	touch $(APACHE2_DIR)/srclib/apr-util/uri/gen_uri_delims

	touch $(APACHE2_DIR)/srclib/pcre/dftables.lo
	cp $(HOST_APACHE2_DIR)/srclib/pcre/dftables $(APACHE2_DIR)/srclib/pcre/dftables
	touch $(APACHE2_DIR)/srclib/pcre/dftables

	touch $(APACHE2_DIR)/server/dummy.lo
	cp $(HOST_APACHE2_DIR)/server/gen_test_char $(APACHE2_DIR)/server/gen_test_char
	touch $(APACHE2_DIR)/server/gen_test_char

	cd $(APACHE2_DIR) && $(APACHE2_ENV) $(APACHE2_PATH) make

	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

apache2_install: $(STATEDIR)/apache2.install

$(STATEDIR)/apache2.install: $(apache2_install_deps_default)
	@$(call targetinfo, $@)
	@$(call install, APACHE2)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

apache2_targetinstall: $(STATEDIR)/apache2.targetinstall

$(STATEDIR)/apache2.targetinstall: $(apache2_targetinstall_deps_default)
	@$(call targetinfo, $@)

	@$(call install_init, apache2)
	@$(call install_fixup, apache2,PACKAGE,apache2)
	@$(call install_fixup, apache2,PRIORITY,optional)
	@$(call install_fixup, apache2,VERSION,$(APACHE2_VERSION))
	@$(call install_fixup, apache2,SECTION,base)
	@$(call install_fixup, apache2,AUTHOR,"Robert Schwebel <r.schwebel\@pengutronix.de>")
	@$(call install_fixup, apache2,DEPENDS,)
	@$(call install_fixup, apache2,DESCRIPTION,missing)

	# the server binary
	@$(call install_copy, apache2, 0, 0, 0755, $(APACHE2_DIR)/.libs/httpd, /usr/sbin/apache2)

	# and some needed shared libraries
	@$(call install_copy, apache2, 0, 0, 0644, \
		$(APACHE2_DIR)/srclib/apr-util/.libs/libaprutil-0.so.0.9.7, \
		/usr/lib/libaprutil-0.so.0.9.7)
	@$(call install_link, apache2, libaprutil-0.so.0.9.7, /usr/lib/libaprutil-0.so.0.9)
	@$(call install_link, apache2, libaprutil-0.so.0.9.7, /usr/lib/libaprutil-0.so.0)

	@$(call install_copy, apache2, 0, 0, 0644, \
		$(APACHE2_DIR)/srclib/apr/.libs/libapr-0.so.0.9.7, \
		/usr/lib/libapr-0.so.0.9.7)
	@$(call install_link, apache2, libapr-0.so.0.9.7, /usr/lib/libapr-0.so.0.9)
	@$(call install_link, apache2, libapr-0.so.0.9.7, /usr/lib/libapr-0.so.0)

ifneq ($(PTXCONF_APACHE2_SERVERROOT),"")
	@$(call install_copy, apache2, 12,102,0755,$(PTXCONF_APACHE2_SERVERROOT))

	# TODO: are the icons needed? (or are all icons required?)

	@$(call install_copy, apache2, 12,102,0755,$(PTXCONF_APACHE2_SERVERROOT)/icons)
	@cd $(APACHE2_DIR)/docs/icons; \
	for i in *.gif *.png; do \
		$(call install_copy, apache2, 12,102,0644,$$i,$(PTXCONF_APACHE2_SERVERROOT)/icons/$$i,n); \
	done
	@$(call install_copy, apache2, 12,102,0755,$(PTXCONF_APACHE2_SERVERROOT)/icons/small)
	@cd $(APACHE2_DIR)/docs/icons/small; \
	for i in *.gif *.png; do \
		$(call install_copy, apache2, 12,102,0644,$$i,$(PTXCONF_APACHE2_SERVERROOT)/icons/small/$$i,n); \
	done
	@$(call install_copy, apache2, 12, 102, 0644, \
		$(APACHE2_DIR)/docs/conf/mime.types, \
		$(PTXCONF_APACHE2_SERVERROOT)/conf/mime.types,n)
endif

ifneq ($(PTXCONF_APACHE2_DOCUMENTROOT),"")
	@$(call install_copy, apache2, 12, 102, 0755, $(PTXCONF_APACHE2_DOCUMENTROOT))
ifdef PTXCONF_APACHE2_DEFAULT_INDEX
	@$(call install_copy, apache2, 12, 102, 0644, \
		$(PTXDIST_TOPDIR)/projects/generic/index.html, \
		$(PTXCONF_APACHE2_DOCUMENTROOT)/index.html,n)
endif
endif

ifneq ($(PTXCONF_APACHE2_CONFIGDIR),"")
	@$(call install_copy, apache2, 12, 102, 0755, $(PTXCONF_APACHE2_CONFIGDIR))

	@$(call install_copy, apache2, 12, 102, 0644, \
		$(APACHE2_DIR)/docs/conf/magic, \
		$(PTXCONF_APACHE2_CONFIGDIR)/magic,n)

ifdef PTXCONF_APACHE2_DEFAULTCONFIG
	cp $(PTXDIST_TOPDIR)/projects/generic/httpd.conf $(APACHE2_DIR)/httpd.conf

	# now replace our own options
	perl -i -p -e "s,\@SERVERROOT@,\"$(PTXCONF_APACHE2_SERVERROOT)\",g" $(APACHE2_DIR)/httpd.conf
	perl -i -p -e "s,\@DOCUMENTROOT@,\"$(PTXCONF_APACHE2_DOCUMENTROOT)\",g" $(APACHE2_DIR)/httpd.conf
	perl -i -p -e "s,\@CONFIGDIR@,\"$(PTXCONF_APACHE2_CONFIGDIR)\",g" $(APACHE2_DIR)/httpd.conf
	perl -i -p -e "s,\@LOGPATH@,$(PTXCONF_APACHE2_LOGDIR),g" $(APACHE2_DIR)/httpd.conf
	perl -i -p -e "s,\@PIDFILE@,/var/run/apache2.pid,g" $(APACHE2_DIR)/httpd.conf
	perl -i -p -e "s,\@LISTEN@,$(PTXCONF_APACHE2_LISTEN),g" $(APACHE2_DIR)/httpd.conf
	perl -i -p -e "s,\@SERVERADMIN@,$(PTXCONF_APACHE2_SERVERADMIN),g" $(APACHE2_DIR)/httpd.conf
	perl -i -p -e "s,\@SERVERNAME@,$(PTXCONF_APACHE2_SERVERNAME),g" $(APACHE2_DIR)/httpd.conf

	@echo "installing default config file..."
	@$(call install_copy, apache2, 12, 102, 0644, \
		$(APACHE2_DIR)/httpd.conf, \
		$(PTXCONF_APACHE2_CONFIGDIR)/httpd.conf,n)
else
ifneq ($(PTXCONF_APACHE2_USERCONFIG), "")
	@echo "installing user config file..."
	@$(call install_copy, apache2, 12, 102, 0644, \
		$(PTXCONF_APACHE2_USERCONFIG), \
		$(PTXCONF_APACHE2_CONFIGDIR)/httpd.conf,n)
endif
endif
endif

ifneq ($(PTXCONF_APACHE2_LOGDIR),"")
	@$(call install_copy, apache2, 12, 102, 0755, $(PTXCONF_APACHE2_LOGDIR))
endif
ifdef PTXCONF_ROOTFS_ETC_INITD_HTTPD
ifneq ($(call remove_quotes,$(PTXCONF_ROOTFS_ETC_INITD_HTTPD_USER_FILE)),)
	@$(call install_copy, apache2, 0, 0, 0755, $(PTXCONF_ROOTFS_ETC_INITD_HTTPD_USER_FILE), /etc/init.d/httpd, n)
else
	@cp $(PTXDIST_TOPDIR)/projects/generic/etc/init.d/httpd $(APACHE2_DIR)/init_httpd
	@perl -i -p -e "s,\@APACHECONFIG@,$(call remove_quotes,$(PTXCONF_APACHE2_CONFIGDIR))/httpd.conf,g" $(APACHE2_DIR)/init_httpd
	@perl -i -p -e "s,\@LOGPATH@,$(call remove_quotes,$(PTXCONF_APACHE2_LOGDIR))/httpd.conf,g" $(APACHE2_DIR)/init_httpd
	@$(call install_copy, apache2, 0, 0, 0755, $(APACHE2_DIR)/init_httpd, /etc/init.d/httpd, n)
endif
endif

ifneq ($(PTXCONF_ROOTFS_ETC_INITD_HTTPD_LINK),"")
	@$(call install_copy, apache2, 0, 0, 0755, /etc/rc.d)
	@$(call install_link, apache2, ../init.d/httpd, /etc/rc.d/$(PTXCONF_ROOTFS_ETC_INITD_HTTPD_LINK))
endif

# #
# # create apache's default serverroot
# #
# ifneq ($(PTXCONF_ROOTFS_HTTPD_SERVERROOT),"")
# ifdef ROOTFS_HTTPD_USER_DOC
# 	@cd $(PTXCONF_ROOTFS_HTTPD_USER_DOC_PATH); \
# 	for i in *.html *.gif *.png; do \
# 		$(call install_copy, apache2, 12,102,0644,$$i,$(PTXCONF_ROOTFS_HTTPD_SERVERROOT)/docroot/$$i,n); \
# 	done
# else
# 	$(call install_copy, apache2, 12,102,0644,$(PTXDIST_TOPDIR)/projetcs/generic/index.html,$(PTXCONF_ROOTFS_HTTPD_SERVERROOT)/docroot/index.html,n)
# endif
# 	@$(call install_copy, apache2, 12,102,0755,$(PTXCONF_ROOTFS_HTTPD_SERVERROOT)/cgi-bin)
# 	@$(call install_copy, apache2, 12,102,0644,$(APACHE2_DIR)/doc/cgi-examples/test-cgi,$(PTXCONF_ROOTFS_HTTPD_SERVERROOT)/cgi-bin,n)
# 	@$(call install_copy, apache2, 12,102,0755,$(PTXCONF_ROOTFS_HTTPD_SERVERROOT)/log)

	@$(call install_finish, apache2)

	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

apache2_clean:
	rm -rf $(STATEDIR)/apache2.*
	rm -rf $(IMAGEDIR)/apache2_*
	rm -rf $(APACHE2_DIR)

# vim: syntax=make
