# -*-makefile-*-
# $Id$
#
# This file contains global macro and environment definitions. 
#

# ----------------------------------------------------------------------------
# Programs & Local Defines
# ----------------------------------------------------------------------------

# change this if you have some wired configuration :)

# FIXME: cleanup 

PTXUSER		= $(shell echo $$USER)
GNU_BUILD	= $(shell $(PTXDIST_TOPDIR)/scripts/config.guess)
GNU_HOST	= $(shell echo $(GNU_BUILD) | sed s/-[a-zA-Z0-9_]*-/-host-/)
DEP_OUTPUT	= depend.out
DEP_TREE_PS	= deptree.ps
DEP_TREE_A4_PS	= deptree-a4.ps

SUDO		= sudo
HOSTCC		= gcc
DOT		= dot
SH		= /bin/sh
# FIXME: disabled caching in wget. Make sure that all patches on the webserver
#        have a version number and reenable caching
WGET		= \
	export ptx_http_proxy=$(PTXCONF_SETUP_HTTP_PROXY); \
	export ptx_ftp_proxy=$(PTXCONF_SETUP_FTP_PROXY); \
	eval \
	$${ptx_http_proxy:+http_proxy=$${ptx_http_proxy}} \
	$${ptx_ftp_proxy:+ftp_proxy=$${ptx_ftp_proxy}} \
	wget --cache=off --passive-ftp
MAKE		= make
MAKE_INSTALL	= make install
PATCH		= patch
TAR		= tar
GZIP		= gzip
ZCAT		= zcat
BZIP2		= bzip2
BZCAT		= bzcat
CAT		= cat
RM		= rm
MKDIR		= mkdir
MKTEMP		= mktemp
CD		= cd
MV		= mv
CP		= cp
LN		= ln
AWK		= awk
PERL		= perl
GREP		= grep
INSTALL		= install
PARALLELMFLAGS  = -j$(shell if [ -r /proc/cpuinfo ];			\
	then echo `cat /proc/cpuinfo | grep 'processor' | wc -l`;	\
		else echo 1;						\
	fi)

FAKEROOT	= $(PTXCONF_HOST_PREFIX)/bin/fakeroot

ifdef PTXCONF_IMAGE_HOST_DEB
CHECKINSTALL	=  INSTALLWATCH_PREFIX=$(PTXCONF_PREFIX)
CHECKINSTALL	+= $(HOST_CHECKINSTALL_DIR)/checkinstall
CHECKINSTALL	+= -D -y
else
CHECKINSTALL	=
endif

HOSTCC_ENV	= CC=$(HOSTCC)


# ----------------------------------------------------------------------------
# Paths and other stuff
# ----------------------------------------------------------------------------

#
# CROSS_LIB_DIR	= the libs for the target system are installed into this dir
#
CROSS_LIB_DIR := $(call remove_quotes,$(PTXCONF_PREFIX)/$(PTXCONF_GNU_TARGET))
SYSROOT := $(call remove_quotes,$(PTXCONF_PREFIX)/$(PTXCONF_GNU_TARGET))

#
# Use the masquerading method of invoking distcc if enabled
#
#
ifdef PTXCONF_XCHAIN-DISTCC
# FIXME: should also allow use of DISTCC for native stuff
DISTCC_PATH_COLON := $(PTXCONF_PREFIX)/lib/distcc/bin:
endif

#
# prepare the search path
#
CROSS_PATH := $(call remove_quotes,$(DISTCC_PATH_COLON)$(PTXCONF_PREFIX)/bin:$(DISTCC_PATH_COLON)$(PTXCONF_PREFIX)/usr/bin:$$PATH)
HOST_PATH := $(call remove_quotes,$(PTXCONF_HOST_PREFIX))/bin:$$PATH

#
# same as PTXCONF_GNU_TARGET, but w/o -linux
# e.g. i486 instead of i486-linux
#
SHORT_TARGET		:= `echo $(PTXCONF_GNU_TARGET) | $(PERL) -i -p -e 's/(.*?)-.*/$$1/'`
SHORT_HOST		:= `echo $(GNU_HOST) | $(PERL) -i -p -e 's/(.*?)-.*/$$1/'`


# ----------------------------------------------------------------------------
# Environment
# ----------------------------------------------------------------------------

#
# CFLAGS / CXXFLAGS
#
# TARGET_CFLAGS and TARGET_CXXFLAGS are included from the architecture
# depended config file that is specified in .config. So here we have to 
# extend it with the stuff we need. 
#
# The option in the .config is called 'TARGET_CONFIG_FILE'
#
#

# FIXME: this is not really consistent any more; we want the arch specific 
#        stuff separate from other options, so we can do NATIVE builds. 

ifdef NATIVE
TARGET_CFLAGS		=
TARGET_CXXFLAGS		=
TARGET_CPPFLAGS		=
TARGET_LDFLAGS		=
endif
TARGET_CFLAGS		+= $(PTXCONF_TARGET_EXTRA_CFLAGS)
TARGET_CXXFLAGS		+= $(PTXCONF_TARGET_EXTRA_CXXFLAGS)
TARGET_CPPFLAGS		+= $(PTXCONF_TARGET_EXTRA_CPPFLAGS)
TARGET_LDFLAGS		+= $(PTXCONF_TARGET_EXTRA_LDFLAGS)

##
## if we use an external crosschain set include and lib dirs correctly: 
## 
## - don't use system standard include paths
## - find out the compiler's sysincludedir
##
ifndef $(PTXCONF_CROSSTOOL)
TARGET_CXXFLAGS		+= -isystem $(PTXCONF_PREFIX)/$(PTXCONF_GNU_TARGET)/include
TARGET_CXXFLAGS		+= -isystem $(PTXCONF_PREFIX)/$(PTXCONF_GNU_TARGET)/usr/include
TARGET_CPPFLAGS		+= -isystem $(PTXCONF_PREFIX)/$(PTXCONF_GNU_TARGET)/include
TARGET_CPPFLAGS		+= -isystem $(PTXCONF_PREFIX)/$(PTXCONF_GNU_TARGET)/usr/include
TARGET_LDFLAGS		+= -L$(PTXCONF_PREFIX)/$(PTXCONF_GNU_TARGET)/lib 
TARGET_LDFLAGS		+= -L$(PTXCONF_PREFIX)/$(PTXCONF_GNU_TARGET)/usr/lib 
endif


# Environment variables for toolchain components
#
# FIXME: Consolidate a bit more
#
ifndef NATIVE
COMPILER_PREFIX		:= $(call remove_quotes,$(PTXCONF_COMPILER_PREFIX))
endif
CROSS_AR		:= $(COMPILER_PREFIX)ar
CROSS_AS		:= $(COMPILER_PREFIX)as
CROSS_LD		:= $(COMPILER_PREFIX)ld
CROSS_NM		:= $(COMPILER_PREFIX)nm
CROSS_CC		:= $(COMPILER_PREFIX)gcc
CROSS_CXX		:= $(COMPILER_PREFIX)g++
CROSS_RANLIB		:= $(COMPILER_PREFIX)ranlib
CROSS_OBJCOPY		:= $(COMPILER_PREFIX)objcopy
CROSS_OBJDUMP		:= $(COMPILER_PREFIX)objdump
CROSS_STRIP		:= $(COMPILER_PREFIX)strip

CROSS_ENV_AR		:= AR=$(CROSS_AR)
CROSS_ENV_AS		:= AS=$(CROSS_AS)
CROSS_ENV_LD		:= LD=$(CROSS_LD)
CROSS_ENV_NM		:= NM=$(CROSS_NM)
CROSS_ENV_CC		:= CC=$(CROSS_CC)
CROSS_ENV_CXX		:= CXX=$(CROSS_CXX)
CROSS_ENV_RANLIB	:= RANLIB=$(CROSS_RANLIB)
CROSS_ENV_OBJCOPY	:= OBJCOPY=$(CROSS_OBJCOPY)
CROSS_ENV_OBJDUMP	:= OBJDUMP=$(CROSS_OBJDUMP)
CROSS_ENV_STRIP		:= STRIP=$(CROSS_STRIP)
CROSS_ENV_CC_FOR_BUILD	:= CC_FOR_BUILD=$(call remove_quotes,$(HOSTCC))
CROSS_ENV_CPP_FOR_BUILD	:= CPP_FOR_BUILD=$(call remove_quotes,$(HOSTCC))
CROSS_ENV_LINK_FOR_BUILD:= LINK_FOR_BUILD=$(call remove_quotes,$(HOSTCC))

# FIXME: check if we have to add quotes for grouping here

CROSS_CFLAGS		= $(call remove_quotes,$(TARGET_CFLAGS))
CROSS_CXXFLAGS		= $(call remove_quotes,$(TARGET_CXXFLAGS))
CROSS_CPPFLAGS		= $(call remove_quotes,$(TARGET_CPPFLAGS))
CROSS_LDFLAGS		= $(call remove_quotes,$(TARGET_LDFLAGS))

ifneq ('','$(strip $(CROSS_CFLAGS))')
CROSS_ENV_CFLAGS		= CFLAGS='$(strip $(CROSS_CFLAGS))'
CROSS_ENV_CFLAGS_FOR_TARGET	= CFLAGS_FOR_TARGET='$(strip $(CROSS_CFLAGS))'
endif

ifneq ('','$(strip $(CROSS_CXXFLAGS))')
CROSS_ENV_CXXFLAGS		= CXXFLAGS='$(strip $(CROSS_CXXFLAGS))'
CROSS_ENV_CXXFLAGS_FOR_TARGET	= CXXFLAGS_FOR_TARGET='$(strip $(CROSS_CXXFLAGS))'
endif

ifneq ('','$(strip $(CROSS_CPPFLAGS))')
CROSS_ENV_CPPFLAGS		= CPPFLAGS='$(strip $(CROSS_CPPFLAGS))'
CROSS_ENF_CPPFLAGS_FOR_TARGET	= CPPFLAGS_FOR_TARGET='$(strip $(CROSS_CPPFLAGS))'
endif

ifneq ('','$(strip $(CROSS_LDFLAGS))')
CROSS_ENV_LDFLAGS		= LDFLAGS='$(strip $(CROSS_LDFLAGS))'
CROSS_ENV_LDFLAGS_FOR_TARGET	= LDFLAGS_FOR_TARGET='$(strip $(CROSS_LDFLAGS))'
endif

# 
# CROSS_ENV is the environment usually set for all configure and compile
# calls in the packet makefiles. 
#
# The ac_cv_* variables are needed to tell configure scripts not to use
# AC_TRY_RUN and run cross compiled things on the development host
# 
CROSS_ENV_PROGS := \
	$(CROSS_ENV_AR) \
	$(CROSS_ENV_AS) \
	$(CROSS_ENV_CXX) \
	$(CROSS_ENV_CC) \
	$(CROSS_ENV_CC_FOR_BUILD) \
	$(CROSS_ENV_CPP_FOR_BUILD) \
	$(CROSS_ENV_LINK_FOR_BUILD) \
	$(CROSS_ENV_LD) \
	$(CROSS_ENV_NM) \
	$(CROSS_ENV_OBJCOPY) \
	$(CROSS_ENV_OBJDUMP) \
	$(CROSS_ENV_RANLIB) \
	$(CROSS_ENV_STRIP)

#
# prepare to use pkg-config with wrapper which takes care of $(SYSROOT). 
# The wrapper's magic doesn't work when pkg-config strips out /usr/lib
# and other system libs/cflags, so we leave them in; the wrapper
# replaces them by proper $(SYSROOT) correspondees. 
#

CROSS_ENV_PKG_CONFIG := \
	SYSROOT=$(SYSROOT) \
	PKG_CONFIG_PATH=$(SYSROOT)/lib/pkgconfig:$(SYSROOT)/usr/lib/pkgconfig

CROSS_ENV_FLAGS := \
	$(CROSS_ENV_CFLAGS) \
	$(CROSS_ENV_CPPFLAGS) \
	$(CROSS_ENV_LDFLAGS) \
	$(CROSS_ENV_CXXFLAGS)

CROSS_ENV_FLAGS_FOR_TARGET := \
	$(CROSS_ENV_CFLAGS_FOR_TARGET) \
	$(CROSS_ENV_CXXFLAGS_FOR_TARGET) \
	$(CROSS_ENV_CPPFLAGS_FOR_TARGET) \
	$(CROSS_ENV_LDFLAGS_FOR_TARGET)

CROSS_ENV_AC := \
	ac_cv_sizeof_long_long=8 \
	ac_cv_sizeof_long_double=8 \
	ac_cv_func_getpgrp_void=yes \
	ac_cv_func_setpgrp_void=yes \
	ac_cv_func_memcmp_clean=yes \
	ac_cv_func_setvbuf_reversed=no \
	ac_cv_func_getrlimit=yes \
	ac_cv_type_uintptr_t=yes \
	ac_cv_func_dcgettext=yes \
	gt_cv_func_gettext_libintl=yes \
	ac_cv_sysv_ipc=yes

CROSS_ENV_DESTDIR := \
	DESTDIR=$(SYSROOT)

#
# We want to use DESTDIR and --prefix=/usr, to get no build paths in our
# binaries. Unfortunately, not all packages support this, especially
# libtool based packets seem to be broken. See for example: 
# 
# https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=58664
#
# for a longer discussion [RSC]
#

CROSS_AUTOCONF_SYSROOT_USR := \
	$(call remove_quotes,--prefix=/usr --sysconfdir=/etc)

CROSS_AUTOCONF_SYSROOT_ROOT := \
	$(call remove_quotes,-prefix=/)

CROSS_AUTOCONF_ARCH := \
	$(call remove_quotes,--build=$(GNU_HOST) --host=$(PTXCONF_GNU_TARGET))

CROSS_AUTOCONF_BROKEN_USR := \
	$(call remove_quotes,--build=$(GNU_HOST) --host=$(PTXCONF_GNU_TARGET) --prefix=$(SYSROOT))

ifndef NATIVE

CROSS_ENV := \
	$(CROSS_ENV_PROGS) \
	$(CROSS_ENV_FLAGS) \
	$(CROSS_ENV_PKG_CONFIG) \
	$(CROSS_ENV_AC) \
	$(CROSS_ENV_DESTDIR)

CROSS_AUTOCONF_USR  := $(CROSS_AUTOCONF_SYSROOT_USR) $(CROSS_AUTOCONF_ARCH)
CROSS_AUTOCONF_ROOT := $(CROSS_AUTOCONF_SYSROOT_ROOT) $(CROSS_AUTOCONF_ARCH)

else

CROSS_ENV := \
	$(CROSS_ENV_PROGS) \
	$(CROSS_ENV_FLAGS) \
	$(CROSS_ENV_PKG_CONFIG) \
	$(CROSS_ENV_DESTDIR)

CROSS_AUTOCONF_USR  := $(CROSS_AUTOCONF_SYSROOT_USR) 
CROSS_AUTOCONF_ROOT := $(CROSS_AUTOCONF_SYSROOT_ROOT) 

endif

HOST_AUTOCONF  := --prefix=$(PTXCONF_HOST_PREFIX)

# ----------------------------------------------------------------------------
# Convenience macros
# ----------------------------------------------------------------------------


#
# compilercheck
#
# Test if a given compiler has the right version, as specified in
# PTXCONF_CROSSCHAIN_CHECK. This lets you test if an external compiler
# fulfills the requirements for a configuration. 
#
compilercheck =											\
	TOOLCHAIN="$(strip $(call remove_quotes, $(PTXCONF_BUILD_TOOLCHAIN)))";			\
	NATIVE="$(strip $(call remove_quotes, $(NATIVE)))";					\
												\
	if test "$${TOOLCHAIN}" = "y" -o "$${NATIVE}" = "1" -o "$${NATIVE}" = "y"; then		\
		echo > /dev/null;								\
	else											\
		echo -n "compiler check...";							\
		if test \! -x "`which $(CROSS_CC)`"; then					\
			echo;									\
			echo;									\
			echo "No compiler installed!";						\
			echo "Specified: $(CROSS_CC)";						\
			echo;									\
			exit -1;								\
		fi;										\
		if test "$(PTXCONF_CROSSCHAIN_CHECK)" != `$(CROSS_CC) -dumpversion`; then	\
			echo;									\
			echo;									\
			echo "Please use the specified compiler!";				\
			echo;									\
			echo "Specified: $(PTXCONF_CROSSCHAIN_CHECK)";				\
			echo "Found:     "`$(CROSS_CC) -dumpversion`;				\
			echo;									\
			exit -1;								\
		fi;										\
		echo "ok";									\
	fi;

#
# check_prog_exists
#
# $1: Find out if this program does exist. If not, execution stops
#     with an error message. 
#
check_prog_exists = 				\
	@if [ ! -x `which $(1)` ]; then		\
		echo "$(1) not found";		\
		echo "please install $(1)"; 	\
		exit -1;			\
	fi;


#
# check_prog_version
#
# $1: Call program with args $2 (-V, ...) and extract version number from the output;
#     the result is compared to the first argument. 
#
check_prog_version = 				\
	@if [ "`$(1) $(2) | $(AWK) 'BEGIN {count = 0;} {count += match($$0,"$(3)");} END {print $$count;}'`" == "0" ]; then \
		echo "need $(1) version $(3)";	\
		echo "please install";		\
		exit -1;			\
	fi;

#
# check_file_exists
#
# $1: Test if a file exists and exit with an error message if not. 
#
check_file_exists = 				\
	@if [ ! -e $(1) ]; then			\
		echo "$(1) not found";		\
		exit -1;			\
	fi;


#
# targetinfo
#
# Print out the targetinfo line on the terminal and perform the compiler
# check to make sure we are using the right toolchain in case we want
# to perform compile or prepare stages. 
# 
# $1: name of the target to be printed out
# $2: normally empty; if "n", don't run compilercheck (FIXME: obsolete)
#
targetinfo = 							\
	echo;							\
	TG=`echo $(1) | sed -e "s,/.*/,,g"`; 			\
	NOCHECK=$(strip $(2));					\
	LINE=`echo target: $$TG |sed -e "s/./-/g"`;		\
	echo $$LINE;						\
	echo target: $$TG;					\
	echo $$LINE;						\
	echo;							\
	echo $@ : $^ | sed 					\
		-e "s@$(SRCDIR)@@g"				\
		-e "s@$(STATEDIR)@@g"				\
		-e "s@$(RULESDIR)@@g"				\
		-e "s@$(PROJECTRULESDIR)@@g"			\
		-e "s@$(PTXDIST_WORKSPACE)@@g"			\
		-e "s@$(PTXDIST_TOPDIR)@@g" 			\
		-e "s@/@@g" >> $(DEP_OUTPUT)

#
# touch with prefix-creation
#
# $1: name of the target to be touched
# 
touch =								\
	@mkdir -p $(shell dirname $1);				\
	touch $1;						\
	echo "Finished target $(shell basename $1)";

#
# extract 
#
# Extract a source archive into a directory. 
#
# $1: filename to extract
# $2: dir to extract into; if $2 is not given we extract to $(BUILDDIR)
#
extract =							\
	PACKET="$(strip $(1))";					\
	if [ "$$PACKET" = "" ]; then				\
		echo;						\
		echo Error: empty parameter to \"extract\(\)\";	\
		echo;						\
		exit -1;					\
	fi;							\
	DEST="$(strip $(2))";					\
	DEST=$${DEST:-$(BUILDDIR)};				\
	echo "extract: archive=$$PACKET";			\
	echo "extract: dest=$$DEST";				\
	case "$$PACKET" in					\
	*gz)							\
		EXTRACT=$(GZIP)					\
		;;						\
	*bz2)							\
		EXTRACT=$(BZIP2)				\
		;;						\
	*)							\
		echo;						\
		echo Unknown format, cannot extract!;		\
		echo;						\
		exit -1;					\
		;;						\
	esac;							\
	[ -d $$DEST ] || $(MKDIR) -p $$DEST;			\
	echo $$(basename $$PACKET) >> $(STATEDIR)/packetlist; 	\
	$$EXTRACT -dc $$PACKET | $(TAR) -C $$DEST -xf -;	\
	[ $$? -eq 0 ] || {					\
		echo;						\
		echo "Could not extract packet!";		\
		echo "File: $$PACKET";				\
		echo;						\
		exit -1;					\
	};


#
# get
#
# Download a package from a given URL. This macro has some magic
# to handle different URLs; as wget is not able to transfer
# file URLs this case is being handed over to cp.  
#
# $1: URL of the packet
# $2: source directory
#
get =								\
	URL="$(strip $(1))";					\
	if [ "$$URL" = "" ]; then				\
		echo;						\
		echo Error: empty parameter to \"get\(\)\";	\
		echo;						\
		exit -1;					\
	fi;							\
	SRC="$(strip $(2))";					\
	SRC=$${SRC:-$(SRCDIR)};					\
	[ -d $$SRC ] || $(MKDIR) -p $$SRC;			\
	case $$URL in 						\
	http*)							\
		$(WGET) -P $$SRC $$URL;				\
		[ $$? -eq 0 ] || {				\
			echo;					\
			echo "Could not get packet via http!";	\
			echo "URL: $$URL";			\
			echo;					\
			exit -1;				\
			};					\
		;;						\
	ftp*)							\
		$(WGET) -P $$SRC $$URL;				\
		[ $$? -eq 0 ] || {				\
			echo;					\
			echo "Could not get packet via ftp!";	\
			echo "URL: $$URL";			\
			echo;					\
			exit -1;				\
			};					\
		;;						\
	file*)							\
		FILE="$$(echo $$URL | sed s-file://-/-g)";	\
		$(CP) -av $$FILE $$SRC;				\
		[ $$? -eq 0 ] || {				\
			echo;					\
			echo "Could not copy packet!";		\
			echo "File: $$FILE";			\
			echo;					\
			exit -1;				\
			};					\
		;;						\
	*)							\
		echo;						\
		echo "Unknown URL Type!";			\
		echo "URL: $$URL";				\
		echo;						\
		exit -1;					\
		;;						\
	esac;								


#
# get_options
# 
# Returns an options from the ptxconfig file
#
# $1: regex, that's applied to the ptxconfig file
#     format: 's/foo/bar/'
#
# $2: default option, this value is returned if the regex outputs nothing
#
get_option =										\
	$(shell										\
		REGEX="$(strip $(1))";							\
		DEFAULT="$(strip $(2))";						\
		if [ -f $(PTXDIST_WORKSPACE)/ptxconfig ]; then				\
			VALUE=`$(CAT) $(PTXDIST_WORKSPACE)/ptxconfig | sed -n -e "$${REGEX}p"`;	\
		fi;									\
		echo $${VALUE:-$$DEFAULT}						\
	)


#
# get_option_ext
# 
# Returns an options from the .config file
#
# $1: regex, that's applied to the .config file
#     format: 's/foo/bar/'
# $2: command that get in STDIN the output from the regex magic
#     should return something in STDOUT
#
get_option_ext =									\
	$(shell										\
		REGEX="$(strip $(1))";							\
		if [ -f $(PTXDIST_WORKSPACE)/.config ]; then				\
			$(CAT) $(PTXDIST_WORKSPACE)/.config | sed -n -e "$${REGEX}p" | $(2);	\
		fi;									\
	)


#
# install
#
# Perform standard install actions
#
# $1: label of the packet
# $2: optional: alternative directory
# $3: optional: "h" = install as a host tool
# $4: optional: args to pass to make install call
#
# FIXME: if we don't use --install=no we can make one packet.
#
ifdef PTXCONF_IMAGE_HOST_DEB
install = \
	BUILDDIR="$($(strip $(1)_DIR))";				\
	[ "$(strip $(2))" != ""  ] && BUILDDIR="$(strip $(2))";		\
	[ "$(strip $(3))" != "h" ] && DESTDIR="$(SYSROOT)";		\
	cd $$BUILDDIR && 						\
		$($(strip $(1))_ENV) 					\
		$($(strip $(1))_PATH) 					\
		INSTALLWATCH_PREFIX=$(PTXCONF_PREFIX)			\
		$(HOST_CHECKINSTALL_DIR)/checkinstall			\
		-D -y -pakdir=$(IMAGEDIR) --install=no -nodoc		\
		make install $(4) 					\
		$($(strip $(1))_MAKEVARS)				\
		DESTDIR=$$DESTDIR;					\
	#dpkg-deb -x blablabla $(PTXCONF_PREFIX)/$(PTXCONF_GNU_TARGET)
else
install = \
	BUILDDIR="$($(strip $(1))_DIR)";				\
	[ "$(strip $(2))" != ""  ] && BUILDDIR="$(strip $(2))";		\
	[ "$(strip $(3))" != "h" ] && DESTDIR="$(SYSROOT)";		\
	mkdir -p $$DESTDIR;						\
	cd $$BUILDDIR &&						\
		echo "$($(strip $(1))_ENV)				\
		$($(strip $(1))_PATH)					\
		make install $(4)					\
		$($(strip $(1))_MAKEVARS)				\
		DESTDIR=$$DESTDIR;"					\
		| $(FAKEROOT) --
endif


#
# clean
# 
# Cleanup the given directory or file. 
#
clean =								\
	DIR="$(strip $(1))";					\
	if [ -e $$DIR ]; then					\
		$(RM) -rf $$DIR;				\
	fi

# 	if [ "$$DIR" = "" ]; then				\
# 		echo;						\
# 		echo Error: empty parameter to \"clean\(\)\";	\
# 		echo;						\
# 		exit -1;					\
# 	fi;							\


#
# enable_c
# 
# Enables a define, removes /* */
#
# (often found in .c or .h files)
#
# $1: file
# $2: parameter
#
enable_c =											\
	FILENAME="$(strip $(1))";								\
	PARAMETER="$(strip $(2))";								\
	$(PERL) -p -i -e									\
		"s,^\s*(\/\*)?\s*(\#\s*define\s+$$PARAMETER)\s*(\*\/)?$$,\$$2\n,"		\
		$$FILENAME

#
# disable_c
# 
# Disables a define with, adds /* */
#
# (often found in .c or .h files)
#
# $1: file
# $2: parameter
#
disable_c =											\
	FILENAME="$(strip $(1))";								\
	PARAMETER="$(strip $(2))";								\
	$(PERL) -p -i -e									\
		"s,^\s*(\/\*)?\s*(\#\s*define\s+$$PARAMETER)\s*(\*\/)?$$,\/\*\$$2\*\/\n,"	\
		$$FILENAME

#
# enable_sh
# 
# Enabled something, removes #
#
# often found in shell scripts, Makefiles
#
# $1: file
# $2: parameter
#
enable_sh =						\
	FILENAME="$(strip $(1))";			\
	PARAMETER="$(strip $(2))";			\
	$(PERL) -p -i -e				\
		"s,^\s*(\#)?\s*($$PARAMETER),\$$2,"	\
		$$FILENAME


#
# disable_sh
# 
# Disables a comment, adds #
#
# often found in shell scripts, Makefiles
#
# $1: file
# $2: parameter
#
disable_sh =						\
	FILENAME="$(strip $(1))";			\
	PARAMETER="$(strip $(2))";			\
	$(PERL) -p -i -e				\
		"s,^\s*(\#)?\s*($$PARAMETER),\#\$$2,"	\
		$$FILENAME

#
# patchin
# 
# Go into a directory and apply all patches from there into a
# sourcetree. 
#
# $1: $(PACKET_NAME) -> identifier
# $2: path to source tree 
#     if this parameter is omitted, the path will be derived
#     from the packet name
#
patchin =									\
	PACKET_NAME="$(strip $(1))";						\
	echo "patchin: packet=$$PACKET_NAME";					\
	if [ "$$PACKET_NAME" = "" ]; then					\
		echo;								\
		echo Error: empty parameter to \"patchin\(\)\";			\
		echo;								\
		exit -1;							\
	fi;									\
	PACKET_DIR="$(strip $(2))";						\
	PACKET_DIR=$${PACKET_DIR:-$(BUILDDIR)/$$PACKET_NAME};			\
	echo "patchin: dir=$$PACKET_DIR";					\
	for PATCH_NAME in							\
	    $(PATCHDIR)/$$PACKET_NAME/generic/*.diff				\
	    $(PATCHDIR)/$$PACKET_NAME/generic/*.patch				\
	    $(PATCHDIR)/$$PACKET_NAME/generic/*.gz				\
	    $(PATCHDIR)/$$PACKET_NAME/generic/*.bz2				\
	    $(PATCHDIR)/$$PACKET_NAME/$(PTXCONF_ARCH)/*.diff			\
	    $(PATCHDIR)/$$PACKET_NAME/$(PTXCONF_ARCH)/*.patch			\
	    $(PATCHDIR)/$$PACKET_NAME/$(PTXCONF_ARCH)/*.gz			\
	    $(PATCHDIR)/$$PACKET_NAME/$(PTXCONF_ARCH)/*.bz2			\
	    $(PROJECTPATCHDIR)/$$PACKET_NAME/generic/*.diff			\
	    $(PROJECTPATCHDIR)/$$PACKET_NAME/generic/*.patch			\
	    $(PROJECTPATCHDIR)/$$PACKET_NAME/generic/*.gz			\
	    $(PROJECTPATCHDIR)/$$PACKET_NAME/generic/*.bz2			\
	    $(PROJECTPATCHDIR)/$$PACKET_NAME/$(PTXCONF_ARCH)/*.diff		\
	    $(PROJECTPATCHDIR)/$$PACKET_NAME/$(PTXCONF_ARCH)/*.patch		\
	    $(PROJECTPATCHDIR)/$$PACKET_NAME/$(PTXCONF_ARCH)/*.gz		\
	    $(PROJECTPATCHDIR)/$$PACKET_NAME/$(PTXCONF_ARCH)/*.bz2;		\
	    do									\
		if [ -f $$PATCH_NAME ]; then					\
			case `basename $$PATCH_NAME` in				\
			*.gz)							\
				CAT=$(ZCAT)					\
				;;						\
			*.bz2)							\
				CAT=$(BZCAT)					\
				;;						\
			*.diff|diff*|*.patch|patch*)				\
				CAT=$(CAT)					\
				;;						\
			*)							\
				echo;						\
				echo Unknown patch format, cannot apply!;	\
				echo;						\
				exit -1;					\
				;;						\
			esac;							\
			echo "patchin: name=$$PATCH_NAME ...";			\
			$$CAT $$PATCH_NAME | $(PATCH) -Np1 -d $$PACKET_DIR || exit -1;	\
		fi;								\
	    done


#
# patch_apply
# 
# Apply a patch to a directory. 
#
# $1: the name of the patch to apply
# $2: apply patch to that directory
#
patch_apply =								\
	PATCH_NAME="$(strip $(1))";					\
	if [ "$$PATCH_NAME" = "" ]; then				\
		echo;							\
		echo Error: empty parameter to \"patch_apply\(\)\";	\
		echo;							\
		exit -1;						\
	fi;								\
	PACKET_DIR="$(strip $(2))";					\
	if [ -f $$PATCH_NAME ]; then					\
		case `basename $$PATCH_NAME` in				\
		*.gz)							\
			CAT=$(ZCAT)					\
			;;						\
		*.bz2)							\
			CAT=$(BZCAT)					\
			;;						\
		*.diff|diff*|*.patch|patch*)				\
			CAT=$(CAT)					\
			;;						\
		*)							\
			echo;						\
			echo Unknown patch format, cannot apply!;	\
			echo;						\
			exit -1;					\
			;;						\
		esac;							\
		echo "patchin' $$PATCH_NAME ...";			\
		$$CAT $$PATCH_NAME | $(PATCH) -Np1 -d $$PACKET_DIR || exit -1;	\
	fi;								\
	true;

#
# install_copy
# 
# Installs a file with user/group ownership and permissions via
# fakeroot. 
#
# $1: packet label
# $2: UID
# $3: GID
# $4: permissions (octal)
# $5: source (for files); directory (for directories)
# $6: destination (for files); empty (for directories). Prefixed with $(ROOTDIR), 
#     so it needs to have a leading /
# $7: strip (for files; y|n); default is to strip
#
install_copy = 											\
	PACKET=$(strip $(1));									\
	OWN=$(strip $(2));									\
	GRP=$(strip $(3));									\
	PER=$(strip $(4));									\
	SRC=$(strip $(5));									\
	DST=$(strip $(6));									\
	STRIP="$(strip $(7))";									\
	if [ -z "$(6)" ]; then									\
		echo "install_copy:";								\
		echo "  dir=$$SRC";								\
		echo "  owner=$$OWN";								\
		echo "  group=$$GRP";								\
		echo "  permissions=$$PER";							\
		if [ "$(PTXCONF_IMAGE_IPKG)" != "" ]; then					\
			$(INSTALL) -d $(IMAGEDIR)/$$PACKET/ipkg/$$SRC;				\
			if [ $$? -ne 0 ]; then							\
				echo "Error: install_copy failed!";				\
				exit -1;							\
			fi;									\
		fi;										\
		$(INSTALL) -m $$PER -d $(ROOTDIR)/$$SRC;					\
		if [ $$? -ne 0 ]; then								\
			echo "Error: install_copy failed!";					\
			exit -1;								\
		fi;										\
		mkdir -p $(IMAGEDIR)/$$PACKET;							\
		echo "f:$$SRC:$$OWN:$$GRP:$$PER" >> $(STATEDIR)/$$PACKET.perms;		\
	else											\
		echo "install_copy:";								\
		echo "  src=$$SRC";								\
		echo "  dst=$$DST";								\
		echo "  owner=$$OWN";								\
		echo "  group=$$GRP";								\
		echo "  permissions=$$PER"; 							\
		if [ "$(PTXCONF_IMAGE_IPKG)" != "" ]; then					\
			rm -fr $(IMAGEDIR)/$$PACKET/ipkg/$$DST; 				\
			$(INSTALL) -D $$SRC $(IMAGEDIR)/$$PACKET/ipkg/$$DST;			\
			if [ $$? -ne 0 ]; then							\
				echo "Error: install_copy failed!";				\
				exit -1;							\
			fi;									\
		fi; 										\
		$(INSTALL) -m $$PER -D $$SRC $(ROOTDIR)$$DST;					\
		if [ $$? -ne 0 ]; then								\
			echo "Error: install_copy failed!";					\
			exit -1;								\
		fi;										\
		case "$$STRIP" in								\
		(0 | n | no)									\
			;;									\
		(*)										\
			if [ "$(PTXCONF_IMAGE_IPKG)" != "" ]; then				\
				$(CROSS_STRIP) -R .note -R .comment $(IMAGEDIR)/$$PACKET/ipkg/$$DST;	\
			fi;									\
			$(CROSS_STRIP) -R .note -R .comment $(ROOTDIR)$$DST;			\
			;;									\
		esac;										\
		mkdir -p $(IMAGEDIR)/$$PACKET;							\
		echo "f:$$DST:$$OWN:$$GRP:$$PER" >> $(STATEDIR)/$$PACKET.perms;		\
	fi

#
# install_copy_toolchain_lib
#
# $1: packet label
# $2: source
# $3: destination
# $4: strip (y|n)	default is to strip
#
install_copy_toolchain_lib =									\
	PACKET=$(strip $(1));									\
	LIB="$(strip $2)";									\
	DST="$(strip $3)";									\
	STRIP="$(strip $4)";									\
												\
	LIB_DIR=`$(CROSS_CC) -print-file-name=$${LIB} | sed -e "s,/$${LIB}\$$,,"`;		\
												\
	if test \! -d "$${LIB_DIR}"; then							\
		echo "install_copy_toolchain_lib: $${LIB_DIR} not found";			\
		exit -1;									\
	fi;											\
												\
	LIB="$(strip $2)";									\
	for FILE in `find $${LIB_DIR} -maxdepth 1 -type l -name "$${LIB}*"`; do			\
		LIB=`basename $${FILE}`;							\
		while test -n "$${LIB}"; do							\
			echo "install_copy_toolchain_lib lib=$${LIB} dst=$${DST}";		\
			rm -fr $(ROOTDIR)$${DST}/$${LIB};					\
			mkdir -p $(ROOTDIR)$${DST};						\
			if [ "$(PTXCONF_IMAGE_IPKG)" != "" ]; then				\
				mkdir -p $(IMAGEDIR)/$$PACKET/ipkg/$${DST};			\
			fi;									\
			if test -h $${LIB_DIR}/$${LIB}; then					\
				cp -d $${LIB_DIR}/$${LIB} $(ROOTDIR)$${DST}/;			\
				if [ "$(PTXCONF_IMAGE_IPKG)" != "" ]; then			\
					cp -d $${LIB_DIR}/$${LIB} $(IMAGEDIR)/$$PACKET/ipkg/$${DST}/;	\
				fi;								\
			elif test -f $${LIB_DIR}/$${LIB}; then					\
				$(INSTALL) -D $${LIB_DIR}/$${LIB} $(ROOTDIR)$${DST}/$${LIB};	\
				if [ "$(PTXCONF_IMAGE_IPKG)" != "" ]; then			\
					$(INSTALL) -D $${LIB_DIR}/$${LIB} $(IMAGEDIR)/$$PACKET/ipkg/$${DST}/$${LIB};\
				fi; 								\
				case "$${STRIP}" in						\
				0 | n | no)							\
					;;							\
				*)								\
					$(CROSS_STRIP) $(ROOTDIR)$${DST}/$${LIB};		\
					if [ "$(PTXCONF_IMAGE_IPKG)" != "" ]; then		\
						$(CROSS_STRIP) $(IMAGEDIR)/$$PACKET/ipkg/$${DST}/$${LIB};\
					fi;							\
					;;							\
				esac;								\
				mkdir -p $(IMAGEDIR)/$$PACKET;					\
				echo "f:$${DST}/$${LIB}:0:0:755" >> $(STATEDIR)/$$PACKET.perms;	\
			else									\
				echo "error: found $${LIB}, but no file or link";		\
				echo;								\
				exit -1;							\
			fi;									\
			LIB="`readlink $${LIB_DIR}/$${LIB} | sed s,^\\\\.,$${LIB_DIR}/\.,`";	\
			if [ -n "$$LIB" ]; then							\
				if [ "`dirname $$LIB`" != "." ]; then				\
					LIB_DIR=`dirname $$LIB`;				\
				fi;								\
				LIB=`basename $$LIB`;						\
			fi;									\
		done;										\
	done;											\
												\
	echo -n

#
# install_copy_toolchain_dl
#
# $1: packet label
# $2: destination
# $3: strip (y|n)	default is to strip
#
install_copy_toolchain_dl =									\
	PACKET=$(strip $(1));									\
	DST="$(strip $2)";									\
	STRIP="$(strip $3)";									\
												\
	LIB="`echo 'int main(void){return 0;}' | 						\
		$(CROSS_CC) -x c -o /dev/null -v - 2>&1 | 					\
		grep dynamic-linker | 								\
		perl -n -p -e 's/.* -dynamic-linker ([^ ]*).*/\1/'`";				\
												\
	LIB="`basename $${LIB}`";								\
												\
	LIB_DIR=`$(CROSS_CC) -print-file-name=$${LIB} | sed -e "s,/$${LIB}\$$,,"`;		\
												\
	if test \! -d "$${LIB_DIR}"; then							\
		echo "copy_toolchain_ld_root: lib=$${LIB} not found";				\
		exit -1;									\
	fi;											\
												\
	for FILE in `find $${LIB_DIR} -maxdepth 1 -type l -name "$${LIB}*"`; do			\
		LIB=`basename $${FILE}`;							\
		while test -n "$${LIB}"; do							\
			echo "copy_toolchain_ld_root lib=$${LIB} dst=$${DST}";			\
			rm -fr $(ROOTDIR)$${DST}/$${LIB};					\
			mkdir -p $(ROOTDIR)$${DST};						\
			if [ "$(PTXCONF_IMAGE_IPKG)" != "" ]; then				\
				rm -fr $(IMAGEDIR)/$$PACKET/ipkg/$${DST}/$${LIB};		\
				mkdir -p $(IMAGEDIR)/$$PACKET/ipkg/$${DST};			\
			fi;									\
			if test -h $${LIB_DIR}/$${LIB}; then					\
				cp -d $${LIB_DIR}/$${LIB} $(ROOTDIR)$${DST}/;			\
				if [ "$(PTXCONF_IMAGE_IPKG)" != "" ]; then			\
					cp -d $${LIB_DIR}/$${LIB} $(IMAGEDIR)/$$PACKET/ipkg/$${DST}/;	\
				fi;								\
			elif test -f $${LIB_DIR}/$${LIB}; then					\
				$(INSTALL) -D $${LIB_DIR}/$${LIB} $(ROOTDIR)$${DST}/$${LIB};	\
				if [ "$(PTXCONF_IMAGE_IPKG)" != "" ]; then			\
					$(INSTALL) -D $${LIB_DIR}/$${LIB} $(IMAGEDIR)/$$PACKET/ipkg/$${DST}/$${LIB};\
				fi;								\
				case "$${STRIP}" in						\
				0 | n | no)							\
					;;							\
				*)								\
					$(CROSS_STRIP) $(ROOTDIR)$${DST}/$${LIB};		\
					if [ "$(PTXCONF_IMAGE_IPKG)" != "" ]; then		\
						$(CROSS_STRIP) $(ROOTDIR)$${DST}/$${LIB};	\
					fi;							\
					;;							\
				esac;								\
				mkdir -p $(IMAGEDIR)/$$PACKET;					\
				echo "f:$${DST}/$${LIB}:0:0:755" >> $(STATEDIR)/$$PACKET.perms;	\
			else									\
				exit -1;							\
			fi;									\
			LIB="`readlink $${LIB_DIR}/$${LIB}`";					\
		done;										\
	done;											\
												\
	echo -n

#
# install_link
# 
# Installs a soft link in root directory in an ipkg packet. 
#
# $1: packet label
# $2: source
# $3: destination
#
install_link =									\
	PACKET=$(strip $(1));							\
	SRC=$(strip $(2));							\
	DST=$(strip $(3));							\
	rm -fr $(ROOTDIR)$$DST;							\
	echo "install_link: src=$$SRC dst=$$DST "; 				\
	mkdir -p `dirname $(ROOTDIR)$$DST`;					\
	$(LN) -sf $$SRC $(ROOTDIR)$$DST; 					\
	if [ "$(PTXCONF_IMAGE_IPKG)" != "" ]; then				\
		mkdir -p `dirname $(IMAGEDIR)/$$PACKET/ipkg$$DST`;		\
		$(LN) -sf $$SRC $(IMAGEDIR)/$$PACKET/ipkg/$$DST;		\
	fi

#
# install_node
#
# Installs a device node in root directory in an ipkg packet.
#
# $1: packet label
# $2: UID
# $3: GID
# $4: permissions (octal)
# $5: type
# $6: major
# $7: minor
# $8: device node name
#
install_node =				\
	PACKET=$(strip $(1));		\
	OWN=$(strip $(2));		\
	GRP=$(strip $(3));		\
	PER=$(strip $(4));		\
	TYP=$(strip $(5));		\
	MAJ=$(strip $(6));		\
	MIN=$(strip $(7));		\
	DEV=$(strip $(8));		\
	echo "install_node:";		\
	echo "  owner=$$OWN";		\
	echo "  group=$$GRP";		\
	echo "  permissions=$$PER";	\
	echo "  type=$$TYP";		\
	echo "  major=$$MAJ";		\
	echo "  minor=$$MIN";		\
	echo "  name=$$DEV";		\
	mkdir -p $(IMAGEDIR)/$$PACKET;		\
	echo "n:$$DEV:$$OWN:$$GRP:$$PER:$$TYP:$$MAJ:$$MIN" >> $(STATEDIR)/$$PACKET.perms

#
# install_fixup
#
# Replaces @...@ sequences in rules/*.ipkg files
#
# $1: packet label
# $2: sequence to be replaced
# $3: replacement
#
install_fixup = 									\
	if [ "$(PTXCONF_IMAGE_IPKG)" != "" ]; then					\
		PACKET=$(strip $(1));							\
		REPLACE_FROM=$(strip $(2));						\
		REPLACE_TO=$(strip $(3));						\
		echo -n "install_fixup:  @$$REPLACE_FROM@ -> $$REPLACE_TO ... "; 	\
		perl -i -p -e "s,\@$$REPLACE_FROM@,$$REPLACE_TO,g" $(IMAGEDIR)/$$PACKET/ipkg/CONTROL/control;	\
		echo "done.";								\
	fi

#
# install_init
#
# Deletes $(IMAGEDIR)/$$PACKET/ipkg and prepares for new ipkg package creation
#
# $1: packet label
#
install_init =											\
	if [ "$(PTXCONF_IMAGE_IPKG)" != "" ]; then						\
		PACKET=$(strip $(1));								\
		echo "install_init: preparing for image creation...";				\
		rm -fr $(IMAGEDIR)/$$PACKET/*;							\
		mkdir -p $(IMAGEDIR)/$$PACKET/ipkg/CONTROL; 					\
		cp -f $(RULESDIR)/default.ipkg $(IMAGEDIR)/$$PACKET/ipkg/CONTROL/control;	\
		if [ -z $(PTXCONF_IMAGE_IPKG_ARCH) ]; then					\
			echo "Error: please specify an architecure name for ipkg!";		\
			exit -1;								\
		fi;										\
		REPLACE_FROM="ARCH";								\
		REPLACE_TO=$(PTXCONF_IMAGE_IPKG_ARCH);						\
		echo -n "install_init:   @$$REPLACE_FROM@ -> $$REPLACE_TO ... ";	 	\
		perl -i -p -e "s,\@$$REPLACE_FROM@,$$REPLACE_TO,g" $(IMAGEDIR)/$$PACKET/ipkg/CONTROL/control;	\
		echo "done";									\
	fi

#
# install_finish
#
# Finishes ipkg packet creation
#
# $1: packet label
#
install_finish = 													\
	export LANG=C; 													\
	if [ "$(PTXCONF_IMAGE_IPKG)" != "" ]; then									\
		PACKET=$(strip $(1));											\
		if [ ! -f $(STATEDIR)/$$PACKET.perms ]; then								\
			echo "Packet $$PACKET is empty. not generating";						\
			rm -rf $(IMAGEDIR)/$$PACKET;									\
			exit 0;												\
		fi;													\
		echo -n "install_finish: writing ipkg packet ... ";							\
		(echo "pushd $(IMAGEDIR)/$$PACKET/ipkg;"; $(AWK) -F: $(DOPERMISSIONS) $(STATEDIR)/$$PACKET.perms; echo "popd;"; 	\
		echo "$(PTXCONF_HOST_PREFIX)/usr/bin/ipkg-build $(PTXCONF_IMAGE_IPKG_EXTRA_ARGS) $(IMAGEDIR)/$$PACKET/ipkg $(IMAGEDIR)") |\
			$(FAKEROOT) -- 2>&1;										\
		rm -rf $(IMAGEDIR)/$$PACKET;										\
		echo "done."; 												\
	fi

# ----------------------------------------------------
#  autogeneration of dependencies
# ----------------------------------------------------

package_depfile=\
	$(STATEDIR)/$(shell basename $(patsubst %.make,%.dep,$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))))

# vim: syntax=make
