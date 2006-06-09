# -*-makefile-*-
# $Id: template 5041 2006-03-09 08:45:49Z mkl $
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
PACKAGES-$(PTXCONF_INITNG) += initng

#
# Paths and names
#
INITNG_VERSION	:= 0.6.7
INITNG		:= initng-$(INITNG_VERSION)
INITNG_SUFFIX	:= tar.bz2
INITNG_URL	:= http://download.initng.org/initng/v0.6/$(INITNG).$(INITNG_SUFFIX)
INITNG_SOURCE	:= $(SRCDIR)/$(INITNG).$(INITNG_SUFFIX)
INITNG_DIR	:= $(BUILDDIR)/$(INITNG)


# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

initng_get: $(STATEDIR)/initng.get

$(STATEDIR)/initng.get: $(initng_get_deps_default)
	@$(call targetinfo, $@)
	@$(call touch, $@)

$(INITNG_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, INITNG)

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

initng_extract: $(STATEDIR)/initng.extract

$(STATEDIR)/initng.extract: $(initng_extract_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(INITNG_DIR))
	@$(call extract, INITNG)
	@$(call patchin, INITNG)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

initng_prepare: $(STATEDIR)/initng.prepare

INITNG_PATH	:=  PATH=$(CROSS_PATH)
INITNG_ENV 	:=  $(CROSS_ENV)

#
# CMake options
#
INITNG_CMAKE	:= \
	-DCMAKE_SKIP_RPATH=ON \
	-DCMAKE_USE_RELATIVE_PATHS=OFF \
	-DCMAKE_VERBOSE_MAKEFILE=ON
#INITNG_CMAKE	+= -DCMAKE_AR=$(CROSS_AR)
#INITNG_CMAKE	+= -DCMAKE_CXX_COMPILER=$(CROSS_CXX)
#INITNG_CMAKE	+= -DCMAKE_CXX_FLAGS="$(CROSS_CPPFLAGS) $(CROSS_CXXFLAGS)"
#INITNG_CMAKE	+= -DCMAKE_CXX_FLAGS_DEBUG="-g"
#INITNG_CMAKE	+= -DCMAKE_CXX_FLAGS_MINSIZEREL="-Os -DNDEBUG"
#INITNG_CMAKE	+= -DCMAKE_CXX_FLAGS_RELEASE="-O3 -DNDEBUG"
#INITNG_CMAKE	+= -DCMAKE_CXX_FLAGS_RELWITHDEBINFO="-O2 -g"
#INITNG_CMAKE	+= -DCMAKE_C_COMPILER=$(CROSS_CC)
#INITNG_CMAKE	+= -DCMAKE_C_FLAGS="$(CROSS_CPPFLAGS) $(CROSS_CFLAGS)"
#INITNG_CMAKE	+= -DCMAKE_C_FLAGS_DEBUG="-g"
#INITNG_CMAKE	+= -DCMAKE_C_FLAGS_MINSIZEREL="-Os -DNDEBUG"
#INITNG_CMAKE	+= -DCMAKE_C_FLAGS_RELEASE="-O3 -DNDEBUG"
#INITNG_CMAKE	+= -DCMAKE_C_FLAGS_RELWITHDEBINFO="-O2 -g"
#INITNG_CMAKE	+= -DCMAKE_EXE_LINKER_FLAGS="$(CROSS_LDFLAGS)"
#INITNG_CMAKE	+= -DCMAKE_EXE_LINKER_FLAGS_DEBUG=""
#INITNG_CMAKE	+= -DCMAKE_EXE_LINKER_FLAGS_MINSIZE=""
#INITNG_CMAKE	+= -DCMAKE_EXE_LINKER_FLAGS_RELEASE=""
#INITNG_CMAKE	+= -DCMAKE_EXE_LINKER_FLAGS_RELWITH=""
#INITNG_CMAKE	+= -DCMAKE_MAKE_PROGRAM="$(MAKE)"
#INITNG_CMAKE	+= -DCMAKE_MODULE_LINKER_FLAGS="$(CROSS_LDFLAGS)"
#INITNG_CMAKE	+= -DCMAKE_MODULE_LINKER_FLAGS_DEBUG=""
#INITNG_CMAKE	+= -DCMAKE_MODULE_LINKER_FLAGS_MINSIZE=""
#INITNG_CMAKE	+= -DCMAKE_MODULE_LINKER_FLAGS_RELEASE=""
#INITNG_CMAKE	+= -DCMAKE_MODULE_LINKER_FLAGS_RELWITH=""
#INITNG_CMAKE	+= -DCMAKE_RANLIB=$(CROSS_RANLIB)
#INITNG_CMAKE	+= -DCMAKE_SHARED_LINKER_FLAGS="$(CROSS_LDFLAGS)"
#INITNG_CMAKE	+= -DCMAKE_SHARED_LINKER_FLAGS_DEBUG=""
#INITNG_CMAKE	+= -DCMAKE_SHARED_LINKER_FLAGS_MINSIZE=""
#INITNG_CMAKE	+= -DCMAKE_SHARED_LINKER_FLAGS_RELEASE=""
#INITNG_CMAKE	+= -DCMAKE_SHARED_LINKER_FLAGS_RELWITH=""

ifdef PTXCONF_INITNG_WITH_BUSYBOX
INITNG_CMAKE += -DWITH_BUSYBOX=ON
else
INITNG_CMAKE += -DWITH_BUSYBOX=OFF
endif

ifdef PTXCONF_INITNG_INSTALL_INIT
INITNG_CMAKE += -DINSTALL_AS_INIT=ON
else
INITNG_CMAKE += -DINSTALL_AS_INIT=OFF
endif

ifdef PTXCONF_INITNG_SELINUX
INITNG_CMAKE += -DBUILD_SELINUX=ON
else
INITNG_CMAKE += -DBUILD_SELINUX=OFF
endif

ifdef PTXCONF_INITNG_DEBUG
INITNG_CMAKE += -DBUILD_DEBUG=ON
else
INITNG_CMAKE += -DBUILD_DEBUG=OFF
endif

ifdef PTXCONF_INITNG_FORCE_NO_COLOR
INITNG_CMAKE += -DFORCE_NO_COLOR=ON
else
INITNG_CMAKE += -DFORCE_NO_COLOR=OFF
endif

ifdef PTXCONF_INITNG_ALSO
INITNG_CMAKE += -DBUILD_ALSO=ON   
else
INITNG_CMAKE += -DBUILD_ALSO=OFF
endif

ifdef PTXCONF_INITNG_BASH_LAUNCHER
INITNG_CMAKE += -DBUILD_BASH_LAUNCER=ON 
else
INITNG_CMAKE += -DBUILD_BASH_LAUNCER=OFF
endif

ifdef PTXCONF_INITNG_CHDIR
INITNG_CMAKE += -DBUILD_CHDIR=ON
else
INITNG_CMAKE += -DBUILD_CHDIR=OFF
endif

ifdef PTXCONF_INITNG_CHROOT
INITNG_CMAKE += -DBUILD_CHROOT=ON  
else
INITNG_CMAKE += -DBUILD_CHROOT=OFF
endif

ifdef PTXCONF_INITNG_CONFLICT
INITNG_CMAKE += -DBUILD_CONFLICT=ON
else
INITNG_CMAKE += -DBUILD_CONFLICT=OFF
endif

ifdef PTXCONF_INITNG_CPOUT
INITNG_CMAKE += -DBUILD_CPOUT=ON
else
INITNG_CMAKE += -DBUILD_CPOUT=OFF
endif

ifdef PTXCONF_INITNG_CTRLALTDEL
INITNG_CMAKE += -DBUILD_CTRLALTDEL=ON
else
INITNG_CMAKE += -DBUILD_CTRLALTDEL=OFF
endif

ifdef PTXCONF_INITNG_CRITICAL
INITNG_CMAKE += -DBUILD_CRITICAL=ON     
else
INITNG_CMAKE += -DBUILD_CRITICAL=OFF
endif

ifdef PTXCONF_INITNG_DAEMON_CLEAN
INITNG_CMAKE += -DBUILD_DAEMON_CLEAN=ON
else
INITNG_CMAKE += -DBUILD_DAEMON_CLEAN=OFF
endif

ifdef PTXCONF_INITNG_DBUS_EVENT
INITNG_CMAKE += -DBUILD_DBUS_EVENT=ON
else
INITNG_CMAKE += -DBUILD_DBUS_EVENT=OFF
endif

ifdef PTXCONF_INITNG_DEBUG_COMMANDS
INITNG_CMAKE += -DBUILD_DEBUG_COMMANDS=ON
else
INITNG_CMAKE += -DBUILD_DEBUG_COMMANDS=OFF
endif

ifdef PTXCONF_INITNG_ENVPARSER
INITNG_CMAKE += -DBUILD_ENVPARSER=ON
else
INITNG_CMAKE += -DBUILD_ENVPARSER=OFF
endif

ifdef PTXCONF_INITNG_FIND
INITNG_CMAKE += -DBUILD_FIND=ON
else
INITNG_CMAKE += -DBUILD_FIND=OFF
endif

ifdef PTXCONF_INITNG_FSTAT
INITNG_CMAKE += -DBUILD_FSTAT=ON 
else
INITNG_CMAKE += -DBUILD_FSTAT=OFF
endif

ifdef PTXCONF_INITNG_FMON
INITNG_CMAKE += -DBUILD_FMON=ON 
else
INITNG_CMAKE += -DBUILD_FMON=OFF
endif


ifdef PTXCONF_INITNG_HISTORY
INITNG_CMAKE += -DBUILD_HISTORY=ON  
else
INITNG_CMAKE += -DBUILD_HISTORY=OFF
endif

ifdef PTXCONF_INITNG_INITCTL
INITNG_CMAKE += -DBUILD_INITCTL=ON
else
INITNG_CMAKE += -DBUILD_INITCTL=OFF
endif

ifdef PTXCONF_INITNG_INTERACTIVE
INITNG_CMAKE += -DBUILD_INTERACTIVE=ON 
else
INITNG_CMAKE += -DBUILD_INTERACTIVE=OFF
endif

ifdef PTXCONF_INITNG_IPARSER
INITNG_CMAKE += -DBUILD_IPARSER=ON
else
INITNG_CMAKE += -DBUILD_IPARSER=OFF
endif

ifdef PTXCONF_INITNG_LAST
INITNG_CMAKE += -DBUILD_LAST=ON
else
INITNG_CMAKE += -DBUILD_LAST=OFF
endif

ifdef PTXCONF_INITNG_LIMIT
INITNG_CMAKE += -DBUILD_LIMIT=ON 
else
INITNG_CMAKE += -DBUILD_LIMIT=OFF
endif

ifdef PTXCONF_INITNG_LOGFILE
INITNG_CMAKE += -DBUILD_LOGFILE=ON
else
INITNG_CMAKE += -DBUILD_LOGFILE=OFF
endif

ifdef PTXCONF_INITNG_LOCKFILE
INITNG_CMAKE += -DBUILD_LOCKFILE=ON
else
INITNG_CMAKE += -DBUILD_LOCKFILE=OFF
endif

ifdef PTXCONF_INITNG_NETPROBE
INITNG_CMAKE += -DBUILD_NETPROBE=ON
else
INITNG_CMAKE += -DBUILD_NETPROBE=OFF
endif

ifdef PTXCONF_INITNG_NETDEV
INITNG_CMAKE += -DBUILD_NETDEV=ON
else
INITNG_CMAKE += -DBUILD_NETDEV=OFF
endif

ifdef PTXCONF_INITNG_IDLEPROBE
INITNG_CMAKE += -DBUILD_IDLEPROBE=ON
else
INITNG_CMAKE += -DBUILD_IDLEPROBE=OFF
endif

ifdef PTXCONF_INITNG_NGC4
INITNG_CMAKE += -DBUILD_NGC4=ON
else
INITNG_CMAKE += -DBUILD_NGC4=OFF
endif

ifdef PTXCONF_INITNG_NGE
INITNG_CMAKE += -DBUILD_NGE=ON
else
INITNG_CMAKE += -DBUILD_NGE=OFF
endif

ifdef PTXCONF_INITNG_NGCS
INITNG_CMAKE += -DBUILD_NGCS=ON  
else
INITNG_CMAKE += -DBUILD_NGCS=OFF
endif

ifdef PTXCONF_INITNG_PAUSE
INITNG_CMAKE += -DBUILD_PAUSE=ON
else
INITNG_CMAKE += -DBUILD_PAUSE=OFF
endif

ifdef PTXCONF_INITNG_PROVIDE
INITNG_CMAKE += -DBUILD_PROVIDE=ON 
else
INITNG_CMAKE += -DBUILD_PROVIDE=OFF
endif

ifdef PTXCONF_INITNG_RELOAD
INITNG_CMAKE += -DBUILD_RELOAD=ON
else
INITNG_CMAKE += -DBUILD_RELOAD=OFF
endif

ifdef PTXCONF_INITNG_RENICE
INITNG_CMAKE += -DBUILD_RENICE=ON
else
INITNG_CMAKE += -DBUILD_RENICE=OFF
endif

ifdef PTXCONF_INITNG_RLPARSER
INITNG_CMAKE += -DBUILD_RLPARSER=ON
else
INITNG_CMAKE += -DBUILD_RLPARSER=OFF
endif

ifdef PTXCONF_INITNG_SIMPLE_LAUNCHER
INITNG_CMAKE += -DBUILD_SIMPLE_LAUNCHER=ON 
else
INITNG_CMAKE += -DBUILD_SIMPLE_LAUNCHER=OFF
endif

ifdef PTXCONF_INITNG_STCMD
INITNG_CMAKE += -DBUILD_STCMD=ON 
else
INITNG_CMAKE += -DBUILD_STCMD=OFF
endif

ifdef PTXCONF_INITNG_STDOUT
INITNG_CMAKE += -DBUILD_STDOUT=ON  
else
INITNG_CMAKE += -DBUILD_STDOUT=OFF
endif

ifdef PTXCONF_INITNG_SUID
INITNG_CMAKE += -DBUILD_SUID=ON
else
INITNG_CMAKE += -DBUILD_SUID=OFF
endif

ifdef PTXCONF_INITNG_SYNCRON
INITNG_CMAKE += -DBUILD_SYNCRON=ON 
else
INITNG_CMAKE += -DBUILD_SYNCRON=OFF
endif

ifdef PTXCONF_INITNG_SYSLOG
INITNG_CMAKE += -DBUILD_SYSLOG=ON
else
INITNG_CMAKE += -DBUILD_SYSLOG=OFF
endif

ifdef PTXCONF_INITNG_SYSRQ
INITNG_CMAKE += -DBUILD_SYSRQ=ON
else
INITNG_CMAKE += -DBUILD_SYSRQ=OFF
endif


ifdef PTXCONF_INITNG_UNNEEDED
INITNG_CMAKE += -DBUILD_UNEEDED=ON
else
INITNG_CMAKE += -DBUILD_UNEEDED=OFF
endif

$(STATEDIR)/initng.prepare: $(initng_prepare_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(INITNG_DIR)/config.cache)
	mkdir -p $(INITNG_DIR)/build/
	cd $(INITNG_DIR)/build/ && \
		$(INITNG_PATH) $(INITNG_ENV) \
		cmake .. $(INITNG_CMAKE) 
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

initng_compile: $(STATEDIR)/initng.compile

$(STATEDIR)/initng.compile: $(initng_compile_deps_default)
	@$(call targetinfo, $@)
	cd $(INITNG_DIR)/build/ && $(INITNG_PATH) make
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

initng_install: $(STATEDIR)/initng.install

$(STATEDIR)/initng.install: $(initng_install_deps_default)
	@$(call targetinfo, $@)
	cd $(INITNG_DIR)/build/ && $(INITNG_PATH) make install DESTDIR=$(SYSROOT)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

initng_targetinstall: $(STATEDIR)/initng.targetinstall

$(STATEDIR)/initng.targetinstall: $(initng_targetinstall_deps_default)
	@$(call targetinfo, $@)

	@$(call install_init, initng)
	@$(call install_fixup,initng,PACKAGE,initng)
	@$(call install_fixup,initng,PRIORITY,optional)
	@$(call install_fixup,initng,VERSION,$(INITNG_VERSION))
	@$(call install_fixup,initng,SECTION,base)
	@$(call install_fixup,initng,AUTHOR,"Erwin Rol <ero\@pengutronix.de>")
	@$(call install_fixup,initng,DEPENDS,)
	@$(call install_fixup,initng,DESCRIPTION,missing)

	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/src/libinitng.so.0.0.0, /usr/lib/libinitng.so.0.0.0)
	@$(call install_link, initng, libinitng.so.0.0.0, /usr/lib/libinitng.so.0)
	@$(call install_link, initng, libinitng.so.0.0.0, /usr/lib/libinitng.so)

	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/plugins/runlevel/librunlevel.so, /usr/lib/initng/librunlevel.so)
	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/plugins/daemon/libdaemon.so, /usr/lib/initng/libdaemon.so)
	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/plugins/service/libservice.so, /usr/lib/initng/libservice.so)

	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/src/initng, /sbin/initng)

	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/tools/killalli5, /sbin/killalli5)
	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/tools/itool, /sbin/itool)
	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/tools/itype, /sbin/itype)
ifdef PTXCONF_INITNG_INSTALL_INIT
	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/tools/mountpoint, /sbin/mountpoint)
	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/tools/sulogin, /sbin/sulogin)
endif
ifdef PTXCONF_INITNG_NGCS
	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/plugins/ngcs/libngcs.so, /usr/lib/initng/libngcs.so)
	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/plugins/ngcs/libngcs_common.so.0.0.0, /usr/lib/libngcs_common.so.0.0.0)
	@$(call install_link, initng, libngcs_common.so.0.0.0, /usr/lib/libngcs_common.so.0)
	@$(call install_link, initng, libngcs_common.so.0.0.0, /usr/lib/libngcs_common.so)
endif

ifdef PTXCONF_INITNG_NGC4
	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/plugins/ngc4/libngc4.so, /usr/lib/initng/libngc4.so)
	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/plugins/ngc4/libngcclient.so.0.0.0, /usr/lib/libngcclient.so.0.0.0)
	@$(call install_link, initng, libngcclient.so.0.0.0, /usr/lib/libngcclient.so.0)
	@$(call install_link, initng, libngcclient.so.0.0.0, /usr/lib/libngcclient.so)

	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/plugins/ngc4/ngc, /sbin/ngc)
endif

ifdef PTXCONF_INITNG_NGE
	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/plugins/nge/libngeclient.so, /usr/lib/libngeclient.so.0.0.0)
	@$(call install_link, initng, libngeclient.so.0.0.0, /usr/lib/libngeclient.so.0)
	@$(call install_link, initng, libngeclient.so.0.0.0, /usr/lib/libngeclient.so)

	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/plugins/nge/libnge.so, /usr/lib/initng/libnge.so)

	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/plugins/nge/nge, /sbin/nge)
	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/plugins/nge/nge_raw, /sbin/nge_raw)
endif

ifdef PTXCONF_INITNG_RELOAD
	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/plugins/reload/libreload.so, /usr/lib/initng/libreload.so)
endif

ifdef PTXCONF_INITNG_CONFLICT
	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/plugins/conflict/libconflict.so, /usr/lib/initng/libconflict.so)
endif

ifdef PTXCONF_INITNG_FSTAT
	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/plugins/fstat/libfstat.so, /usr/lib/initng/libfstat.so)
endif

ifdef PTXCONF_INITNG_FMON
	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/plugins/fmon/libfmon.so, /usr/lib/initng/libfmon.so)
endif

ifdef PTXCONF_INITNG_PAUSE
	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/plugins/pause/libpause.so, /usr/lib/initng/libpause.so)
endif

ifdef PTXCONF_INITNG_SUID
	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/plugins/suid/libsuid.so, /usr/lib/initng/libsuid.so)
endif

ifdef PTXCONF_INITNG_INTERACTIVE
	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/plugins/interactive/libinteractive.so, /usr/lib/initng/libinteractive.so)
endif

ifdef PTXCONF_INITNG_INITCTL
	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/plugins/initctl/libinitctl.so, /usr/lib/initng/libinitctl.so)
endif

ifdef PTXCONF_INITNG_CHROOT
	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/plugins/chroot/libchroot.so, /usr/lib/initng/libchroot.so)
endif

ifdef PTXCONF_INITNG_FIND
	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/plugins/find/libfind.so, /usr/lib/initng/libfind.so)
endif

ifdef PTXCONF_INITNG_UNNEEDED
	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/plugins/unneeded/libunneeded.so, /usr/lib/initng/libunneeded.so)
endif


ifdef PTXCONF_INITNG_IPARSER
	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/plugins/iparser/libiparser.so, /usr/lib/initng/libiparser.so)
endif

ifdef PTXCONF_INITNG_ALSO
	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/plugins/also/libalso.so, /usr/lib/initng/libalso.so)
endif

ifdef PTXCONF_INITNG_SIMPLE_LAUNCHER
	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/plugins/simple_launcher/libsimplelauncher.so, /usr/lib/initng/libsimplelauncher.so)
endif

ifdef PTXCONF_INITNG_LOGFILE
	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/plugins/logfile/liblogfile.so, /usr/lib/initng/liblogfile.so)
endif

ifdef PTXCONF_INITNG_STCMD
	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/plugins/stcmd/libstcmd.so, /usr/lib/initng/libstcmd.so)
endif

ifdef PTXCONF_INITNG_RENICE
	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/plugins/renice/librenice.so, /usr/lib/initng/librenice.so)
endif

ifdef PTXCONF_INITNG_CHDIR
	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/plugins/chdir/libchdir.so, /usr/lib/initng/libchdir.so)
endif

ifdef PTXCONF_INITNG_DAEMON_CLEAN
	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/plugins/daemon_clean/libdaemon_clean.so, /usr/lib/initng/libdaemon_clean.so)
endif

ifdef PTXCONF_INITNG_HISTORY
	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/plugins/history/libhistory.so, /usr/lib/initng/libhistory.so)
endif

ifdef PTXCONF_INITNG_RLPARSER
	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/plugins/rlparser/librlparser.so, /usr/lib/initng/librlparser.so)
endif

ifdef PTXCONF_INITNG_STDOUT
	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/plugins/stdout/libstdout.so, /usr/lib/initng/libstdout.so)
endif

ifdef PTXCONF_INITNG_BASH_LAUNCHER
	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/plugins/bash_launcher/libbashlaunch.so, /usr/lib/initng/libbashlaunch.so)
endif

ifdef PTXCONF_INITNG_NETPROBE
	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/plugins/netprobe/libnetprobe.so, /usr/lib/initng/libnetprobe.so)
endif

ifdef PTXCONF_INITNG_NETDEV
	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/plugins/netdev/libnetdev.so, /usr/lib/initng/libnetdev.so)
endif

ifdef PTXCONF_INITNG_SYSLOG
	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/plugins/syslog/libsyslog.so, /usr/lib/initng/libsyslog.so)
endif

ifdef PTXCONF_INITNG_SYSRQ
	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/plugins/sysrq/libsysrq.so, /usr/lib/initng/libsysrq.so)
endif

ifdef PTXCONF_INITNG_IDLEPROBE
	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/plugins/idleprobe/libidleprobe.so, /usr/lib/initng/libidleprobe.so)
endif

ifdef PTXCONF_INITNG_LAST
	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/plugins/last/liblast.so, /usr/lib/initng/liblast.so)
endif

ifdef PTXCONF_INITNG_CPOUT
	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/plugins/cpout/libcpout.so, /usr/lib/initng/libcpout.so)
endif

ifdef PTXCONF_INITNG_SYNCRON
	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/plugins/syncron/libsyncron.so, /usr/lib/initng/libsyncron.so)
endif

ifdef PTXCONF_INITNG_ENVPARSER
	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/plugins/envparser/libenvparser.so, /usr/lib/initng/libenvparser.so)
endif

ifdef PTXCONF_INITNG_LIMIT
	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/plugins/limit/liblimit.so, /usr/lib/initng/liblimit.so)
endif

ifdef PTXCONF_INITNG_PROVIDE
	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/plugins/provide/libprovide.so, /usr/lib/initng/libprovide.so)
endif

ifdef PTXCONF_INITNG_CTRLALTDEL
	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/plugins/ctrlaltdel/libctrlaltdel.so, /usr/lib/initng/libctrlaltdel.so)
endif

ifdef PTXCONF_INITNG_DBUS_EVENT
	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/plugins/dbus_event/libdbus_event.so, /usr/lib/initng/libdbus_event.so)
endif

ifdef PTXCONF_INITNG_DEBUG_COMMANDS
	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/plugins/debug_commands/libdebug_commands.so, /usr/lib/initng/libdebug_commands.so)
endif

ifdef PTXCONF_INITNG_CRITICAL
	@$(call install_copy, initng, 0, 0, 0755, $(INITNG_DIR)/build/plugins/critical/libcritical.so, /usr/lib/initng/libcritical.so)
endif
	@$(call install_finish,initng)

	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

initng_clean:
	rm -rf $(STATEDIR)/initng.*
	rm -rf $(IMAGEDIR)/initng_*
	rm -rf $(INITNG_DIR)

# vim: syntax=make
