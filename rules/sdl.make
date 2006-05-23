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
PACKAGES-$(PTXCONF_SDL) += sdl

#
# Paths and names
#
SDL_VERSION	:= 1.2.9
SDL		:= SDL-$(SDL_VERSION)
SDL_SUFFIX	:= tar.gz
SDL_URL	:= http://www.libsdl.org/release//$(SDL).$(SDL_SUFFIX)
SDL_SOURCE	:= $(SRCDIR)/$(SDL).$(SDL_SUFFIX)
SDL_DIR	:= $(BUILDDIR)/$(SDL)

-include $(call package_depfile)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

sdl_get: $(STATEDIR)/sdl.get

$(STATEDIR)/sdl.get: $(sdl_get_deps_default)
	@$(call targetinfo, $@)
	@$(call touch, $@)

$(SDL_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, SDL)

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

sdl_extract: $(STATEDIR)/sdl.extract

$(STATEDIR)/sdl.extract: $(sdl_extract_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(SDL_DIR))
	@$(call extract, SDL)
	@$(call patchin, SDL)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

sdl_prepare: $(STATEDIR)/sdl.prepare

SDL_PATH	:=  PATH=$(CROSS_PATH)
SDL_ENV 	:=  $(CROSS_ENV)

#
# autoconf
#
SDL_AUTOCONF := $(CROSS_AUTOCONF_USR)
ifdef PTXCONF_SDL_SHARED
SDL_AUTOCONF += --enable-shared
else
SDL_AUTOCONF += --disable-shared
endif
ifdef PTXCONF_SDL_STATIC
SDL_AUTOCONF += --enable-static
else
SDL_AUTOCONF += --disable-static
endif

ifdef PTXCONF_SDL_AUDIO
SDL_AUTOCONF += --enable-audio      

 ifdef PTXCONF_SDL_OSS
 SDL_AUTOCONF += --enable-oss
 else
 SDL_AUTOCONF += --disable-oss
 endif

 ifdef PTXCONF_SDL_ALSA
 SDL_AUTOCONF += --enable-alsa     
 SDL_AUTOCONF += --disable-alsatest 
 #SDL_AUTOCONF += --with-alsa-prefix=PFX 
 #SDL_AUTOCONF += --with-alsa-inc-prefix=PFX 
  ifdef PTXCONF_SDL_ALSA_SHARED
  SDL_AUTOCONF += --enable-alsa-shared  
  else
  SDL_AUTOCONF += --disable-alsa-shared
  endif
 else
 SDL_AUTOCONF += --disable-alsa
 endif

 ifdef PTXCONF_SDL_ESD
 SDL_AUTOCONF += --enable-esd   
 SDL_AUTOCONF += --disable-esdtest
 #SDL_AUTOCONF += --with-esd-prefix=PFX 
 #SDL_AUTOCONF += --with-esd-exec-prefix=PFX 
  ifdef PTXCONF_SDL_ESD_SHARED
  SDL_AUTOCONF += --enable-esd-shared   
  else
  SDL_AUTOCONF += --disable-esd-shared
  endif
 else
 SDL_AUTOCONF += --disable-esd
 endif

 ifdef PTXCONF_SDL_ARTS
 SDL_AUTOCONF += --enable-arts         
  ifdef PTXCONF_SDL_ARTS_SHARED
  SDL_AUTOCONF += --enable-arts-shared  
  else
  SDL_AUTOCONF += --disable-arts-shared
  endif
 else
 SDL_AUTOCONF += --disable-arts
 endif

 ifdef PTXCONF_SDL_NAS
 SDL_AUTOCONF += --enable-nas       
 else
 SDL_AUTOCONF += --disable-nas
 endif

 ifdef PTXCONF_SDL_DISKAUDIO
 SDL_AUTOCONF += --enable-diskaudio   
 else
 SDL_AUTOCONF += --disable-diskaudio
 endif

else
DL_LIB_AUTOCONF += --disable-audio
endif

ifdef PTXCONF_SDL_VIDEO
SDL_AUTOCONF += --enable-video  

 ifdef PTXCONF_SDL_NANOX
 SDL_AUTOCONF += \
	--enable-video-nanox \
	--enable-nanox-debug \
	--enable-nanox-share-memory \
	--enable-nanox-direct-fb
 else
 SDL_AUTOCONF += --disable-video-nanox
 endif

 ifdef PTXCONF_SDL_XORG
 SDL_AUTOCONF += \
	--with-x \
	--enable-video-x11 \
	--enable-video-x11-vm \
	--enable-dga \
	--enable-video-x11-dgamouse \
	--enable-video-x11-xv \
	--enable-video-x11-xinerama \
	--enable-video-x11-xme \
	--enable-video-dga \
	--x-includes=$(SYSROOT)/usr/include \
	--x-libraries=$(SYSROOT)/usr/lib
 else
 SDL_AUTOCONF += --without-x
 endif

 ifdef PTXCONF_SDL_FBCON
 SDL_AUTOCONF += --enable-video-fbcon 
 else
 SDL_AUTOCONF += --disable-video-fbcon
 endif

 ifdef PTXCONF_SDL_DIRECTFB
 SDL_AUTOCONF += --enable-video-directfb 
 else
 SDL_AUTOCONF += --disable-video-directfb
 endif

 ifdef PTXCONF_SDL_AALIB
 SDL_AUTOCONF += --enable-video-aalib 
 else
 SDL_AUTOCONF += --disable-video-aalib
 endif

 ifdef PTXCONF_SDL_OPENGL
 SDL_AUTOCONF += \
	--enable-video-opengl \
	--enable-osmesa-shared
 else
 SDL_AUTOCONF += --disable-video-opengl
 endif

 ifdef PTXCONF_SDL_QTOPIA
 SDL_AUTOCONF += --enable-video-qtopia 
 else
 SDL_AUTOCONF += --disable-video-qtopia
 endif

else
SDL_AUTOCONF += --disable-video 
endif

ifdef PTXCONF_SDL_EVENT
SDL_AUTOCONF += --enable-events  
else
SDL_AUTOCONF += --disable-events
endif

ifdef PTXCONF_SDL_JOYSTICK
SDL_AUTOCONF += --enable-joystick  
else
SDL_AUTOCONF += --disable-joystick
endif

ifdef PTXCONF_SDL_CDROM
SDL_AUTOCONF += --enable-cdrom    
else
SDL_AUTOCONF += --disable-cdrom
endif

ifdef PTXCONF_SDL_THREADS
SDL_AUTOCONF += --enable-threads  
 ifdef PTXCONF_SDL_PTH
 SDL_AUTOCONF += --enable-pth         
 else
 SDL_AUTOCONF += --disable-pth
 endif
else
SDL_AUTOCONF += --disable-threads
endif

ifdef PTXCONF_SDL_TIMERS
SDL_AUTOCONF += --enable-timers  
else
SDL_AUTOCONF += --disable-timers
endif

ifdef PTXCONF_SDL_ENDIAN
SDL_AUTOCONF += --enable-endian 
else
SDL_AUTOCONF += --disable-endian
endif

ifdef PTXCONF_SDL_FILE
SDL_AUTOCONF += --enable-file   
else
SDL_AUTOCONF += --disable-file
endif

ifdef PTXCONF_SDL_CPUINFO
SDL_AUTOCONF += --enable-cpuinfo
else
SDL_AUTOCONF += --disable-cpuinfo
endif

ifdef PTXCONF_SDL_NASM
SDL_AUTOCONF += --enable-nasm    
else
SDL_AUTOCONF += --disable-nasm
endif

SDL_AUTOCONF += \
	--disable-debug \
	--disable-strict-ansi \
	--disable-video-ps2gs \
	--disable-video-ggi \
	--disable-video-svga \
	--disable-video-vgl \
	--disable-video-xbios \
	--disable-video-gem \
	--enable-video-dummy \
	--enable-pthreads \
	--enable-pthread-sem \
	--enable-sigaction \
	--disable-stdio-redirect \
	--disable-directx \
	--disable-video-picogui \
	--enable-sdl-dlopen \
	--disable-atari-ldg \
	--enable-rpath \
	--disable-mintaudio \
	--disable-video-photon \
	--enable-input-events

$(STATEDIR)/sdl.prepare: $(sdl_prepare_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(SDL_DIR)/config.cache)
	cd $(SDL_DIR) && \
		$(SDL_PATH) $(SDL_ENV) \
		./configure $(SDL_AUTOCONF)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

sdl_compile: $(STATEDIR)/sdl.compile

$(STATEDIR)/sdl.compile: $(sdl_compile_deps_default)
	@$(call targetinfo, $@)
	cd $(SDL_DIR) && $(SDL_PATH) make
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

sdl_install: $(STATEDIR)/sdl.install

$(STATEDIR)/sdl.install: $(sdl_install_deps_default)
	@$(call targetinfo, $@)
	@$(call install, SDL)
	# install sdl-config in bin dir
	mkdir -p $(PTXCONF_PREFIX)/bin
	cp $(SDL_DIR)/sdl-config $(PTXCONF_PREFIX)/bin/
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

sdl_targetinstall: $(STATEDIR)/sdl.targetinstall

$(STATEDIR)/sdl.targetinstall: $(sdl_targetinstall_deps_default)
	@$(call targetinfo, $@)

	@$(call install_init, sdl)
	@$(call install_fixup, sdl,PACKAGE,sdl)
	@$(call install_fixup, sdl,PRIORITY,optional)
	@$(call install_fixup, sdl,VERSION,$(SDL_VERSION))
	@$(call install_fixup, sdl,SECTION,base)
	@$(call install_fixup, sdl,AUTHOR,"Erwin Rol <ero\@pengutronix.de>")
	@$(call install_fixup, sdl,DEPENDS,)
	@$(call install_fixup, sdl,DESCRIPTION,missing)

	@$(call install_copy, sdl, 0, 0, 0644, \
		$(SDL_DIR)/src/.libs/libSDL-1.2.so.0.7.2, \
		/usr/lib/libSDL-1.2.so.0.7.2)

	@$(call install_link, sdl, \
		libSDL-1.2.so.0.7.2, \
		/usr/lib/libSDL-1.2.so.0)

	@$(call install_link, sdl, \
		libSDL-1.2.so.0.7.2, \
		/usr/lib/libSDL-1.2.so)

	@$(call install_finish, sdl)

	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

sdl_clean:
	rm -rf $(STATEDIR)/sdl.*
	rm -rf $(IMAGEDIR)/sdl_*
	rm -rf $(SDL_DIR)

# vim: syntax=make
