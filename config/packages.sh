#!/bin/sh

##
# Select optional packages to build.
#
# See `PACKAGES.md` for more details.
#

WITH_AUTOCONF=false
WITH_AUTOGEN=false
WITH_AUTOMAKE=false
WITH_BASH=false
WITH_BDWGC=false
WITH_BISON=false
WITH_BROTLI=false
WITH_BZIP2=false
WITH_DEJAGNU=false
WITH_EXPAT=false
WITH_EXPECT=false
WITH_FLEX=false
WITH_GDB=false
WITH_GDBM=false
WITH_GENGEN=false
WITH_GENGETOPT=false
WITH_GETTEXT=false
WITH_GOLD=false
WITH_GPERF=false
WITH_GPM=false
WITH_GPROFNG=false
WITH_GUILE2=false
WITH_GUILE3=false
WITH_HELP2MAN=false
WITH_INDENT=false
WITH_JANSSON=false
WITH_LIBB2=false
WITH_LIBASPRINTF=false
WITH_LIBFFI=false
WITH_LIBICONV=false
WITH_LIBSIGSEGV=false
WITH_LIBTEXTSTYLE=false
WITH_LIBTOOL=false
WITH_LIBUNISTRING=false
WITH_LIBUNWIND=false
WITH_LZ4=false
WITH_LZMA=false
WITH_LIBXCRYPT=false
WITH_LIBXML2=false
WITH_M4=false
WITH_MAKE=false
WITH_MPDECIMAL=false
WITH_NCURSES=false
WITH_OPENSSL=false
WITH_PERL=false
WITH_PKGCONF=false
WITH_PYTHON=false
WITH_READLINE=false
WITH_SQLITE3=false
WITH_TCL=false
WITH_XXHASH=false
WITH_ZLIB=false
WITH_ZSTD=false

##
# Package-specific options
#

# glibc

# --enable-kernel=VERSION
#glibc_kernel=
# --enable-profile
glibc_profile=true
# --enable-fortify-source and --enable-stack-protector
glibc_fortify=true

# binutils

# --enable-compressed-debug-sections=all|gas|ld|none
binutils_compressed_debug_sections=all
# --enable-default-compressed-debug-sections=zlib|zstd
binutils_default_compressed_debug_sections=zlib

# gcc

# extra languages to pass with --enable-languages
#gcc_languages=
# --with-glibc-version=VERSION
#gcc_glibc_version=
# --enable-vtable-verify
gcc_vtable_verify=false

# libxcrypt

# --enable-obsolute-api=all|alt|glibc|owl|suse|no
#libxcrypt_obsolete_api=
# --enable-obsolete-api-enosys
libxcrypt_obsolete_api_enosys=false
