#
# For a description of the syntax of this configuration file,
# see extra/config/Kconfig-language.txt
#

# mainmenu "uClibc C Library Configuration"

menu "Target Architecture Features and Options"
	depends on UCLIBC && ARCH_SH

config UCLIBC_HAVE_ELF
	bool
	default y

config UCLIBC_ARCH_CFLAGS
	string

config UCLIBC_ARCH_LDFLAGS
	string

config UCLIBC_LIBGCC_CFLAGS
	string

config UCLIBC_HAVE_DOT_HIDDEN
        bool
	default y

config UCLIBC_UCLIBC_COMPLETELY_PIC
        bool
	default y

choice
	prompt "Target Processor Type"
	default UCLIBC_CONFIG_SH4
	help
	  This is the processor type of your CPU. This information is used for
	  optimizing purposes, as well as to determine if your CPU has an MMU,
	  an FPU, etc.  If you pick the wrong CPU type, there is no guarantee
	  that uClibc will work at all....

	  Here are the available choices:
	  - "SH2" Hitachi SH2
	  - "SH3" Hitachi SH3
	  - "SH4" Hitachi SH4
	  - "SH5" Hitachi SH5

config UCLIBC_CONFIG_SH2
	bool "SH2"

config UCLIBC_CONFIG_SH3
	bool "SH3"

config UCLIBC_CONFIG_SH4
	bool "SH4"

config UCLIBC_CONFIG_SH5
	bool "SH5"

endchoice

choice
	prompt "Target Processor Endianness"
	default UCLIBC_ARCH_LITTLE_ENDIAN
	help
	  This is the endianness you wish to build use.  Choose either Big
	  Endian, or Little Endian.

config UCLIBC_ARCH_LITTLE_ENDIAN
	bool "Little Endian"

config UCLIBC_ARCH_BIG_ENDIAN
	bool "Big Endian"

endchoice


config UCLIBC_ARCH_HAS_NO_MMU
	bool
	default y if UCLIBC_CONFIG_SH2

config UCLIBC_ARCH_HAS_NO_FPU
       bool
       default y if UCLIBC_CONFIG_SH2 || UCLIBC_CONFIG_SH3

#
# For a description of the syntax of this configuration file,
# see extra/config/Kconfig-language.txt
#

config UCLIBC_UCLIBC_HAS_MMU
	bool "Target CPU has a memory management unit (MMU)"
	default y
	depends !UCLIBC_ARCH_HAS_NO_MMU
	help
	  If your target CPU does not have a memory management unit (MMU), 
	  then answer N here.  Normally, Linux runs on systems with an MMU.  
	  If you are building a uClinux system, answer N.

	  Most people will answer Y.

config UCLIBC_UCLIBC_HAS_FLOATS
	bool "Enable floating point number support"
	default y
	help
	  This option allows you to entirely omit all floating point number
	  support from uClibc.  This will cause floating point functions like
	  strtod() to be omitted from uClibc.  Other floating point functions, 
	  such as printf() and scanf() will still be included in the library, 
	  but will not contain support for floating point numbers.

	  Answering N to this option can reduce the size of uClibc.  Most people
	  will answer Y.

config UCLIBC_HAS_FPU
	bool "Target CPU has a floating point unit (FPU)"
	depends on UCLIBC_UCLIBC_HAS_FLOATS && !UCLIBC_ARCH_HAS_NO_FPU
	default y
	help
	  If your target CPU does not have a Floating Point Unit (FPU) or a
	  kernel FPU emulator, but you still wish to support floating point
	  functions, then uClibc will need to be compiled with soft floating
	  point support (-msoft-float).  If your target CPU does not have an
	  FPU or an FPU emulator within the Linux kernel, then you should
	  answer N.

	  Most people will answer Y.

config UCLIBC_UCLIBC_HAS_SOFT_FLOAT
	bool
	depends on UCLIBC_UCLIBC_HAS_FLOATS && !UCLIBC_HAS_FPU
	default y

config UCLIBC_DO_C99_MATH
	bool "Enable full C99 math library support"
	depends on UCLIBC_UCLIBC_HAS_FLOATS
	default n
	help
	  If you want the uClibc math library to contain the full set C99
	  math library features, then answer Y.  If you leave this set to
	  N the math library will contain only the math functions that were
	  listed as part of the traditional POSIX/IEEE 1003.1b-1993 standard.
	  Leaving this option set to N will save around 35k on an x86 system.

	  If your applications require the newer C99 math library functions, 
	  then answer Y.

config UCLIBC_WARNINGS
	string "Compiler Warnings"
	default "-Wall"
	help
	  Set this to the set of gcc warnings you wish to see while compiling.

config UCLIBC_KERNEL_SOURCE
	string "Linux kernel header location"
	default "/usr/src/linux"
	help
	  The kernel source you use to compile with should be the same as the
	  Linux kernel you run your apps on.  uClibc doesn't even try to achieve binary
	  compatibility across kernel versions.  So don't expect, for example, uClibc
	  compiled with Linux kernel 2.0.x to implement lchown properly, since 2.0.x
	  can't do that. Similarly, if you compile uClibc vs Linux 2.4.x kernel headers,
	  but then run on Linux 2.0.x, lchown will be compiled into uClibc, but won't
	  work at all.  You have been warned.

config UCLIBC_UCLIBC_UCLINUX_BROKEN_MUNMAP
	bool
	depends on !UCLIBC_UCLIBC_HAS_MMU
	default y

config UCLIBC_EXCLUDE_BRK
	bool
	depends on !UCLIBC_UCLIBC_HAS_MMU
	default y

config UCLIBC_C_SYMBOL_PREFIX
	string
	default "_" if UCLIBC_ARCH_HAS_C_SYMBOL_PREFIX
	default "" if !UCLIBC_ARCH_HAS_C_SYMBOL_PREFIX


endmenu

#
# For a description of the syntax of this configuration file,
# see extra/config/Kconfig-language.txt
#
config UCLIBC_HAVE_DOT_CONFIG
	bool
	default y


menu "General Library Settings"
	depends on UCLIBC && ARCH_SH

config UCLIBC_DOPIC
	bool "Generate Position Independent Code (PIC)"
	default y
	depends !UCLIBC_HAVE_NO_PIC
	help
	  If you wish to build uClibc with support for shared libraries then
	  answer Y here.  If you only want to build uClibc as a static library,
	  then answer N.

config UCLIBC_HAVE_SHARED
	bool "Enable support for shared libraries"
	depends on UCLIBC_DOPIC
	default y
	help
	  If you wish to build uClibc with support for shared libraries then
	  answer Y here.  If you only want to build uClibc as a static library,
	  then answer N.

config UCLIBC_ADD_LIBGCC_FUNCTIONS
	bool "Add unresolved libgcc symbols to uClibc"
	depends on UCLIBC_HAVE_SHARED
	default n
	help
	  If you answer Y here, all unresolved functions provided by the libgcc
	  library that are used by uClibc will be added directly into the
	  uClibc library.  If your gcc compiler only provides a static libgcc
	  library, then enabling this option can reduce the size of your
	  binaries by preventing these functions from being staticly linked
	  into every binary.  If you have compiled uClibc as PIC code, one
	  potential size effect of this option is that you may end up adding
	  non-PIC libgcc code into your shared uClibc library, resulting in a
	  non shareable text segment (thereby wasting a bunch of ram).  If your
	  compiler supports a shared libgcc library, you should certainly leave
	  this option disabled.  Regardless, the safest answer is N.

config UCLIBC_BUILD_UCLIBC_LDSO
	bool "Compile native shared library loader"
	depends on UCLIBC_HAVE_SHARED
	default y
	help
	  uClibc has a native shared library loader for some architectures.
	  If you answer Y here, the uClibc native shared library loader will
	  be built for your target architecture.  If this option is available,
	  to you, then you almost certainly want to answer Y.

config UCLIBC_FORCE_SHAREABLE_TEXT_SEGMENTS
	bool "Only load shared libraries which can share their text segment"
	depends on UCLIBC_BUILD_UCLIBC_LDSO && UCLIBC_UCLIBC_COMPLETELY_PIC && !UCLIBC_ADD_LIBGCC_SYMBOLS
	default n
	help
	  If you answer Y here, the uClibc native shared library loader will
	  only load shared libraries, which do not need to modify any non-writable
	  segments. These libraries haven't set the DT_TEXTREL tag in the dynamic
	  section (==> objdump). So all your libraries must be compiled with
	  -fPIC or -fpic, and all assembler function must be written as position
	  independent code (PIC). 
	  Enabling this option will makes uClibc's shared library loader a
	  little bit smaller and guarantee that no memory will be wasted by badly
	  coded shared libraries.

config UCLIBC_LDSO_LDD_SUPPORT
	bool "Native shared library loader 'ldd' support"
	depends on UCLIBC_BUILD_UCLIBC_LDSO
	default y
	help
	  Enable this to enable all the code needed to support traditional ldd,
	  which executes the shared library loader to resolve all dependencies
	  and then provide a list of shared libraries that are required for an
	  application to function.  Disabling this option will makes uClibc's
	  shared library loader a little bit smaller.  Most people will answer Y.

config UCLIBC_UCLIBC_CTOR_DTOR
	bool "Support global constructors and destructors"
	default y
	help
	  If you wish to build uClibc with support for global constructor
	  (ctor) and global destructor (dtor) support, then answer Y here.
	  When ctor/dtor support is enabled, binaries linked with uClibc must
	  also be linked with crtbegin.o and crtend.o which are provided by gcc
	  (the "*startfile:" and "*endfile:" settings in your gcc specs file
	  may need to be adjusted to include these files).  This support will
	  also add a small amount of additional size to each binary compiled vs
	  uClibc.  If you will be using uClibc with C++, or if you need the gcc
	  __attribute__((constructor)) and __attribute__((destructor)) to work,
	  then you definitely want to answer Y here.  If you don't need ctors
	  or dtors and want your binaries to be as small as possible, then
	  answer N.

config UCLIBC_UCLIBC_PROFILING
	bool "Support gprof profiling"
	default y
	help
	  If you wish to build uClibc with support for application profiling
	  using the gprof tool, then you should enable this feature.  Then in
	  addition to building uClibc with profiling support, you will also
	  need to recompile all your shared libraries with the profiling
	  enabled version of uClibc.  To add profiling support to your
	  applications, you must compile things using the gcc options
	  "-fprofile-arcs  -pg".  Then when you run your applications, a
	  gmon.out file will be generated which can then be analyzed by
	  'gprof'.  

	  These exist a number of less invasive alternatives that do not
	  require your to specially instrument your application, and recompile
	  and relink everything.  
	  
	  Many people have had good results using the combination of Valgrind 
	  to generate profiling information and KCachegrind for analysis:
		  http://developer.kde.org/~sewardj/
		  http://kcachegrind.sourceforge.net/

	  The OProfile system-wide profiler is another alternative:
		  http://oprofile.sourceforge.net/

	  Prospect is another alternative based on OProfile:
		  http://prospect.sourceforge.net/

	  And the Linux Trace Toolkit (LTT) is also a fine tool:
		http://www.opersys.com/LTT/

	  If none of these tools do what you need, you can of course enable
	  this option, rebuild everything, and use 'gprof'.  There is both a
	  size and performance penelty to profiling your applications this way,
	  so most people should answer N.

config UCLIBC_UCLIBC_HAS_THREADS
	bool "POSIX Threading Support"
	default y
	help
	  If you want to compile uClibc with pthread support, then answer Y.  
	  This will increase the size of uClibc by adding a bunch of locking
	  to critical data structures, and adding extra code to ensure that
	  functions are properly reentrant.

	  If your applications require pthreads, answer Y.

config UCLIBC_PTHREADS_DEBUG_SUPPORT
	bool "Build pthreads debugging support"
	default n
	depends on UCLIBC_UCLIBC_HAS_THREADS
	help
	  Say Y here if you wish to be able to debug applications that use
	  uClibc's pthreads library.  By enabling this option, a library 
	  named libthread_db will be built.  This library will be dlopen()'d
	  by gdb and will allow gdb to debug the threads in your application.

	  IMPORTANT NOTE!  Because gdb must dlopen() the libthread_db library,
	  you must compile gdb with uClibc in order for pthread debugging to
	  work properly.

	  If you are doing development and want to debug applications using
	  uClibc's pthread library, answer Y.  Otherwise, answer N.

config UCLIBC_UCLIBC_HAS_LFS
	bool "Large File Support"
	default y
	help
	  If you wish to build uClibc with support for accessing large files 
	  (i.e. files greater then 2 GiB) then answer Y.  Do not enable this 
	  if you are using an older UCLIBC_Linux kernel (UCLIBC_2.UCLIBC_0.x) that lacks large file 
	  support.  Enabling this option will increase the size of uClibc.

choice
	prompt "Malloc Implementation"
	default malloc-930716
	help
	  "malloc" use mmap for all allocations and so works very well on MMU-less
	  systems that do not support the brk() system call.   It is pretty smart
	  about reusing already allocated memory, and minimizing memory wastage.

	  "malloc-930716" is derived from libc-5.3.12 and uses the brk() system call
	  for all memory allocations.  This makes it very fast.  It is also pretty
	  smart about reusing already allocated memory, and minimizing memory wastage.
	  Because this uses brk() it will not work on uClinux MMU-less systems.

	  If unsure, answer "malloc".

config UCLIBC_MALLOC
	bool "malloc"

config UCLIBC_MALLOC_930716
	bool "malloc-930716"
	depends on UCLIBC_UCLIBC_HAS_MMU

endchoice

config UCLIBC_UCLIBC_DYNAMIC_ATEXIT
	bool "Dynamic atexit() Support"
	default y
	help

	  When this option is enabled, uClibc will support an infinite number,
	  of atexit() and on_exit() functions, limited only by your available
	  memory.  This can be important when uClibc is used with C++, since
	  global destructors are implemented via atexit(), and it is quite
	  possible to exceed the default number when this option is disabled.
	  Enabling this option adds a few bytes, and more significantly makes
	  atexit and on_exit depend on malloc, which can be bad when compiling 
	  static executables.

	  Unless you use uClibc with C++, you should probably answer N.


config UCLIBC_HAS_SHADOW
	bool "Shadow Password Support"
	default y
	help
	  Answer N if you do not need shadow password support.  
	  Most people will answer Y.

config UCLIBC_UCLIBC_HAS_REGEX
	bool "Regular Expression Support"
	default y
	help
	  POSIX regular expression code is really big -- 27k all by itself.
	  If you don't use regular expressions, turn this off and save space.
	  Of course, if you only staticly link, leave this on, since it will
	  only be included in your apps if you use regular expressions.

config UCLIBC_UNIX98PTY_ONLY
	bool "Support only Unix 98 PTYs"
	default y
	help
	  If you want to support only Unix 98 PTYs enable this.  Some older
	  applications may need this disabled.  For most current programs, 
	  you can generally answer Y.

config UCLIBC_ASSUME_DEVPTS
	bool "Assume that /dev/pts is a devpts or devfs file system"
	default y
	help
	  Enable this if /dev/pts is on a devpts or devfs filesystem.  Both
	  these filesystems automatically manage permissions on the /dev/pts 
	  devices.  You may need to mount your devpts or devfs filesystem on
	  /dev/pts for this to work.

	  Most people should answer Y.

config UCLIBC_UCLIBC_HAS_TM_EXTENSIONS
	bool "Support 'struct tm' timezone extension fields"
	default y
	help
	  Enabling this option adds fields to 'struct tm' in time.h for
	  tracking the number of seconds east of UTC, and an abbreviation for
	  the current timezone.  These fields are not specified by the SuSv3
	  standard, but they are commonly used in both GNU and BSD application
	  code.

	  To strictly follow the SuSv3 standard, leave this disabled.
	  Most people will probably want to answer Y.

endmenu



menu "Networking Support"
	depends on UCLIBC && ARCH_SH

config UCLIBC_UCLIBC_HAS_IPV6
	bool "IP version 6 Support"
	default n
	help
	  If you want to include support for the next version of the Internet
	  Protocol (IP version 6) then answer Y.
	  
	  Most people should answer N.

config UCLIBC_UCLIBC_HAS_RPC
	bool "Remote Procedure Call (RPC) support"
	default n
	help
	  If you want to include RPC support, enable this.  RPC is rarely used 
	  for anything except for the NFS filesystem.  Unless you plan to use NFS, 
	  you can probably leave this set to N and save some space.  If you need
	  to use NFS then you should answer Y.

config UCLIBC_UCLIBC_HAS_FULL_RPC
	bool "Full RPC support"
	depends on UCLIBC_UCLIBC_HAS_RPC
	default y if !UCLIBC_HAVE_SHARED
	help
	  Normally we enable just enough RPC support for things like rshd and
	  nfs mounts to work.  If you find you need the rest of the RPC stuff, 
	  then enable this option.  Most people can safely answer N.

endmenu


menu "String and Stdio Support"
	depends on UCLIBC && ARCH_SH

config UCLIBC_UCLIBC_HAS_WCHAR
	bool "Wide Character Support"
	default n
	help
	  Answer Y to enable wide character support.  This will make uClibc 
	  much larger.

	  Most people will answer N.

config UCLIBC_UCLIBC_HAS_LOCALE
	bool "Locale Support (experimental/incomplete)"
	depends on UCLIBC_UCLIBC_HAS_WCHAR
	default n
	help
	  Answer Y to enable locale support.  This will make uClibc much
	  bigger.  uClibc's locale support is still under development, and
	  should be finished in the next several weeks (November 2002).

	  Most people will wisely answer N.

config UCLIBC_USE_OLD_VFPRINTF
	bool "Use the old vfprintf implementation"
	default n
	help
	  Set to true to use the old vfprintf instead of the new.  This is roughly
	  C89 compliant, but doesn't deal with qualifiers on %n and doesn't deal with
	  %h correctly or %hh at all on the integer conversions.  But on i386 it is
	  over 1.5k smaller than the new code.  Of course, the new code fixes the
	  above mentioned deficiencies and adds custom specifier support similar to
	  glibc, as well as handling positional args.  This will be rewritten at some 
	  point to bring it to full C89 standards compliance.

	  Most people will answer N.

endmenu

menu "Library Installation Options"
	depends on UCLIBC && ARCH_SH

config UCLIBC_SHARED_LIB_LOADER_PATH
	string "Shared library loader path"
	depends on UCLIBC_BUILD_UCLIBC_LDSO
	default "$(DEVEL_PREFIX)/lib"
	help
	  When using shared libraries, this path is the location where the
	  shared library will be invoked.  This value will be compiled into
	  every binary compiled with uClibc.

	  BIG FAT WARNING:
	  If you do not have a shared library loader with the correct name
	  sitting in the directory this points to, your binaries will not 
	  run.

config UCLIBC_SYSTEM_LDSO
	string "System shared library loader"
	depends on UCLIBC_HAVE_SHARED && !UCLIBC_BUILD_UCLIBC_LDSO
	default "/lib/ld-linux.so.2"
	help
	  If you are using shared libraries, but do not want/have a native
	  uClibc shared library loader, please specify the name of your
	  target system's shared library loader here...

	  BIG FAT WARNING:
	  If you do not have a shared library loader with the correct name
	  sitting in the directory this points to, your binaries will not 
	  run.

config UCLIBC_DEVEL_PREFIX
	string "uClibc development environment directory"
	default "/usr/$(TARGET_ARCH)-linux-uclibc"
	help
	  DEVEL_PREFIX is the directory into which the uClibc development
	  environment will be installed.   The result will look something
	  like the following:
	      $(DEVEL_PREFIX)/
	          lib/            <contains all runtime and static libs>
		  include/        <Where all the header files go>
	  This value is used by the 'make install' Makefile target.  Since this
	  directory is compiled into the uclibc cross compiler spoofer, you
	  have to recompile uClibc if you change this value...

config UCLIBC_SYSTEM_DEVEL_PREFIX
	string "uClibc development environment system directory"
	default "$(DEVEL_PREFIX)"
	help
	  SYSTEM_DEVEL_PREFIX is the directory prefix used when installing
	  bin/arch-uclibc-gcc, bin/arch-uclibc-ld, etc.   This is only used by
	  the 'make install' target, and is not compiled into anything.  This
	  defaults to $(DEVEL_PREFIX)/usr, but makers of .rpms and .debs will
	  want to set this to "/usr" instead.

config UCLIBC_DEVEL_TOOL_PREFIX
	string "uClibc development environment tool directory"
	default "$(DEVEL_PREFIX)/usr"
	help
	  DEVEL_TOOL_PREFIX is the directory prefix used when installing
	  bin/gcc, bin/ld, etc.   This is only used by the 'make install'
	  target, and is not compiled into anything.  This defaults to
	  $(DEVEL_PREFIX)/usr, but makers of .rpms and .debs may want to
	  set this to something else.

endmenu

menu "uClibc hacking options"
	depends on UCLIBC && ARCH_SH

config UCLIBC_DODEBUG
	bool "Build uClibc with debugging symbols"
	default n
	help
	  Say Y here if you wish to compile uClibc with debugging symbols.
	  This will allow you to use a debugger to examine uClibc internals
	  while applications are running.  This increases the size of the
	  library considerably and should only be used when doing development.
	  If you are doing development and want to debug uClibc, answer Y.

	  Otherwise, answer N.

config UCLIBC_DOASSERTS
	bool "Build uClibc with run-time assertion testing"
	default n
	help
	  Say Y here to include runtime assertion tests.
	  This enables runtime assertion testing in some code, which can
	  increase the size of the library and incur runtime overhead.
	  If you say N, then this testing will be disabled.

config UCLIBC_SUPPORT_LD_DEBUG
	bool "Build the shared library loader with debugging support"
	depends on UCLIBC_BUILD_UCLIBC_LDSO
	default n
	help
	  Answer Y here to enable all the extra code needed to debug the uClibc
	  native shared library loader.  The level of debugging noise that is
	  generated depends on the LD_DEBUG environment variable...  Just set
	  LD_DEBUG to something like: 'LD_DEBUG=token1,token2,..  prog' to
	  debug your application.  Diagnostic messages will then be printed to
	  the stderr.

	  For now these debugging tokens are available:
	    detail        provide more information for some options
	    move          display copy processing
	    symbols       display symbol table processing
	    reloc         display relocation processing; detail shows the relocation patch
	    nofixups      never fixes up jump relocations
	    bindings      displays the resolve processing (function calls); detail shows the relocation patch
	    all           Enable everything!

	  The additional environment variable:
	    LD_DEBUG_OUTPUT=file
	  redirects the diagnostics to an output file created using
	  the specified name and the process id as a suffix.

	  An excellent start is simply:
	    $ LD_DEBUG=binding,move,symbols,reloc,detail ./appname
	  or to log everything to a file named 'logfile', try this
	    $ LD_DEBUG=all LD_DEBUG_OUTPUT=logfile ./appname

	  If you are doing development and want to debug uClibc's shared library
	  loader, answer Y.  Mere mortals answer N.

config UCLIBC_SUPPORT_LD_DEBUG_EARLY
	bool "Build the shared library loader with early debugging support"
	depends on UCLIBC_BUILD_UCLIBC_LDSO
	default n
	help
	  Answer Y here to if you find the uClibc shared library loader is
	  crashing or otherwise not working very early on.  This is typical
	  only when starting a new port when you haven't figured out how to
	  properly get the values for argc, argv, environ, etc.  This method
	  allows a degree of visibility into the very early shared library
	  loader initialization process.  If you are doing development and want
	  to debug the uClibc shared library loader early initialization,
	  answer Y.  Mere mortals answer N.

config UCLIBC_UCLIBC_MALLOC_DEBUGGING
	bool "Build malloc with debugging support"
	depends UCLIBC_MALLOC
	default n
	help
	  Answer Y here to compile extra debugging support code into malloc.
	  Malloc debugging output may then be enabled at runtime using
	  the MALLOC_DEBUG environment variable.  Because this increases
	  the size of malloc appreciably (due to strings etc), you
	  should say N unless you need to debug a malloc problem.

endmenu


