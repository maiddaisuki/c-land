#!/bin/sh

# Installation prefix for built packages
PREFIX=

# Root for relative *_SRCDIR directories
SRCDIR=/src

# Root directory to use for building
BUILDDIR=${TMPDIR-/tmp}

##
# Source code directories
#
# Relative names appended to `SRCDIR`.
# Absolute names used as-is.
#

AUTOCONF_SRCDIR=autoconf         # https://www.gnu.org/software/autoconf/
AUTOGEN_SRCDIR=autogen           # https://www.gnu.org/software/autogen/
AUTOMAKE_SRCDIR=automake         # https://www.gnu.org/software/automake/
BASH_SRCDIR=bash                 # https://www.gnu.org/software/bash/
BDWGC_SRCDIR=bdwgc               # https://www.hboehm.info/gc/
BINUTILS_SRCDIR=binutils         # https://www.gnu.org/software/binutils/
BISON_SRCDIR=bison               # https://www.gnu.org/software/bison/
BROTLI_SRCDIR=brotli             # https://github.com/google/brotli
BZIP2_SRCDIR=bzip2               # https://sourceware.org/bzip2/
DEJAGNU_SRCDIR=dejagnu           # https://www.gnu.org/software/dejagnu/
EXPAT_SRCDIR=libexpat            # https://libexpat.github.io/
EXPECT_SRCDIR=expect             # https://core.tcl-lang.org/expect/index
FLEX_SRCDIR=flex                 # https://github.com/westes/flex
GCC_SRCDIR=gcc                   # https://www.gnu.org/software/gcc/
GDB_SRCDIR=gdb                   # https://www.gnu.org/software/gdb/
GDBM_SRCDIR=gdbm                 # https://www.gnu.org.ua/software/gdbm/
GENGEN_SRCDIR=gengen             # https://www.gnu.org/software/gengen/
GENGETOPT_SRCDIR=gengetopt       # https://www.gnu.org/software/gengetopt/
GETTEXT_SRCDIR=gettext           # https://www.gnu.org/software/gettext/
GLIBC_SRCDIR=glibc               # https://sourceware.org/glibc/
GPERF_SRCDIR=gperf               # https://www.gnu.org/software/gperf/
GPM_SRCDIR=gpm                   # https://github.com/telmich/gpm
GUILE2_SRCDIR=guile-2            # https://www.gnu.org/software/guile/
GUILE3_SRCDIR=guile-3            # https://www.gnu.org/software/guile/
HELP2MAN_SRCDIR=help2man         # https://www.gnu.org/software/help2man/
INDENT_SRCDIR=indent             # https://www.gnu.org/software/indent/
JANSSON_SRCDIR=jansson           # https://github.com/akheron/jansson
LIBB2_SRCDIR=libb2               # https://github.com/BLAKE2/libb2
LIBFFI_SRCDIR=libffi             # https://sourceware.org/libffi/
LIBGMP_SRCDIR=libgmp             # https://gmplib.org/
LIBMPC_SRCDIR=libmpc             # https://www.multiprecision.org/
LIBMPFR_SRCDIR=libmpfr           # https://www.mpfr.org/
LINUX_SRCDIR=linux               # https://kernel.org/
LIBICONV_SRCDIR=libiconv         # https://www.gnu.org/software/libiconv/
LIBISL_SRCDIR=libisl             # https://libisl.sourceforge.io/
LIBSIGSEGV_SRCDIR=libsigsegv     # https://www.gnu.org/software/libsigsegv/
LIBTOOL_SRCDIR=libtool           # https://www.gnu.org/software/libtool/
LIBUNISTRING_SRCDIR=libunistring # https://www.gnu.org/software/libunistring/
LIBUNWIND_SRCDIR=libunwind       # https://www.nongnu.org/libunwind/
LIBXCRYPT_SRCDIR=libxcrypt       # https://github.com/besser82/libxcrypt
LIBXML2_SRCDIR=libxml2           # https://gitlab.gnome.org/GNOME/libxml2
LZ4_SRCDIR=lz4                   # https://github.com/lz4/lz4
LZMA_SRCDIR=xz                   # https://github.com/tukaani-project/xz
M4_SRCDIR=m4                     # https://www.gnu.org/software/m4/
MAKE_SRCDIR=make                 # https://www.gnu.org/software/make/
MPDECIMAL_SRCDIR=mpdecimal       # https://www.bytereef.org/mpdecimal/index.html
MUSL_SRCDIR=musl                 # https://musl.libc.org/
NCURSES_SRCDIR=ncurses           # https://invisible-island.net/ncurses/ncurses.html
OPENSSL_SRCDIR=openssl           # https://github.com/openssl/openssl
PERL_SRCDIR=perl                 # https://github.com/Perl/perl5.git
PKGCONF_SRCDIR=pkgconf           # https://github.com/pkgconf/pkgconf.git
PYTHON_SRCDIR=python             # https://www.python.org/
READLINE_SRCDIR=readline         # https://tiswww.cwru.edu/php/chet/readline/rltop.html
SQLITE3_SRCDIR=sqlite            # https://sqlite.org/index.html
TCL_SRCDIR=tcl                   # https://www.tcl-lang.org/software/tcltk/
TZDATA_SRCDIR=tzdata             # https://www.iana.org/time-zones
UCLIBC_SRCDIR=uclibc-ng          # https://www.uclibc-ng.org/
XXHASH_SRCDIR=xxhash             # https://github.com/Cyan4973/xxHash
ZLIB_SRCDIR=zlib                 # https://www.zlib.net/
ZSTD_SRCDIR=zstd                 # https://github.com/facebook/zstd
