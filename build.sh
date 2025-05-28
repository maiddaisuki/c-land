#!/bin/env sh

export LC_ALL=C

if test ${BASH_VERSION+y}; then
	shopt -os posix
fi

tab='	'
nl='
'

IFS=" ${tab}${nl}"

self=$(realpath "$0")
selfdir=$(dirname "${self}")

config_guess=${selfdir}/build-aux/config.guess
config_sub=${selfdir}/build-aux/config.sub

build_log=/dev/null

log() {
	printf "$@" | tee -a "${build_log}"
}

note() {
	log "NOTE: %s\n" "$*"
}

warning() {
	log "WARNING: %s\n" "$*" >&2
}

error() {
	log "ERROR: %s\n" "$*" >&2
}

die() {
	error "$*"
	exit 1
}

# Parse options

help_msg="\
Usage: ${self} [OPTION] ...

Options:

  --help                  print this message and exit
  --target=TARGET         target triplet
                          (default=config.guess)
  --toolchain=gnu|llvm    toolchain to use during stage 1
                          (default=gnu)

  --with-arch-libdir      install libraries to lib{32,x32,64} instead of lib
                          subdirectory under PREFIX
  --disable-stage{1|2|3}  disable specified stage
"

enable_stage1=true
enable_stage2=true
enable_stage3=true

# --target
target=
# --toolchain
toolchain=gnu
# --with-arch-libdir
with_arch_libdir=false

while test $# -gt 0; do
	arg=$1 && shift
	eat=false

	case ${arg} in
	--help)
		printf %s "${help_msg}"
		exit 0
		;;
	--target)
		target=$1
		eat=true
		;;
	--target=*)
		target=${arg#--target=}
		;;
	--toolchain)
		toolchain=$1
		eat=true
		;;
	--toolchain=*)
		toolchain=${arg#--toolchain=}
		;;
	--disable-stage1)
		enable_stage1=false
		;;
	--disable-stage2)
		enable_stage2=false
		;;
	--disable-stage3)
		enable_stage3=false
		;;
	--with-arch-libdir)
		with_arch_libdir=true
		;;
	*)
		die "${arg}: unknown command line option"
		;;
	esac

	if ${eat}; then
		eat=false
		shift || die "${arg}: argument is missing"
	fi
done

case ${toolchain} in
[Gg][Nn][Uu] | [Ll][Ll][Vv][Mm])
	:
	;;
*)
	error "--toolchain: ${toolchain}: invalid argument"
	;;
esac

# Directories with support scripts
configs_dir=${selfdir}/config
include_dir=${selfdir}/include
packages_dir=${selfdir}/packages

# Read user configs
. ${configs_dir}/options.sh
. ${configs_dir}/packages.sh
. ${configs_dir}/dirs.sh

# Read internal configs
. ${include_dir}/verify.sh
. ${include_dir}/target.sh
. ${include_dir}/dirs.sh
# functions
. ${include_dir}/functions.sh
# build system specific functions
. ${include_dir}/cmake.sh
. ${include_dir}/make.sh
. ${include_dir}/meson.sh

# Packages
. ${packages_dir}/autoconf.sh
. ${packages_dir}/autogen.sh
. ${packages_dir}/automake.sh
. ${packages_dir}/bash.sh
. ${packages_dir}/bdwgc.sh
. ${packages_dir}/binutils.sh
. ${packages_dir}/bison.sh
. ${packages_dir}/brotli.sh
. ${packages_dir}/bzip2.sh
. ${packages_dir}/dejagnu.sh
. ${packages_dir}/expat.sh
. ${packages_dir}/expect.sh
. ${packages_dir}/flex.sh
. ${packages_dir}/gcc.sh
. ${packages_dir}/gdb.sh
. ${packages_dir}/gdbm.sh
. ${packages_dir}/gengen.sh
. ${packages_dir}/gengetopt.sh
. ${packages_dir}/gettext.sh
. ${packages_dir}/gperf.sh
. ${packages_dir}/gpm.sh
. ${packages_dir}/guile2.sh
. ${packages_dir}/guile3.sh
. ${packages_dir}/help2man.sh
. ${packages_dir}/indent.sh
. ${packages_dir}/jansson.sh
. ${packages_dir}/libasprintf.sh
. ${packages_dir}/libb2.sh
. ${packages_dir}/libc.sh
. ${packages_dir}/libffi.sh
. ${packages_dir}/libgmp.sh
. ${packages_dir}/libiconv.sh
. ${packages_dir}/libintl.sh
. ${packages_dir}/libisl.sh
. ${packages_dir}/libmpc.sh
. ${packages_dir}/libmpfr.sh
. ${packages_dir}/libsigsegv.sh
. ${packages_dir}/libtextstyle.sh
. ${packages_dir}/libtool.sh
. ${packages_dir}/libunistring.sh
. ${packages_dir}/libunwind.sh
. ${packages_dir}/libxcrypt.sh
. ${packages_dir}/libxml2.sh
. ${packages_dir}/linux-headers.sh
. ${packages_dir}/lz4.sh
. ${packages_dir}/lzma.sh
. ${packages_dir}/m4.sh
. ${packages_dir}/make.sh
. ${packages_dir}/mpdecimal.sh
. ${packages_dir}/ncurses.sh
. ${packages_dir}/openssl.sh
. ${packages_dir}/perl.sh
. ${packages_dir}/pkgconf.sh
. ${packages_dir}/python.sh
. ${packages_dir}/readline.sh
. ${packages_dir}/sqlite3.sh
. ${packages_dir}/tcl.sh
. ${packages_dir}/tzdata.sh
. ${packages_dir}/xxhash.sh
. ${packages_dir}/zlib.sh
. ${packages_dir}/zstd.sh

##
# Stage 1
#

if ${enable_stage1}; then
	stage=1
	. ${include_dir}/tools.sh

	# Dependencies of Binutils and GCC
	libgmp_main
	libmpfr_main
	libmpc_main
	libisl_main

	# Linux header files and target C Library
	linux_headers_main
	libc_main

	if test -n "${dynamic_linker}"; then
		cat <<-EOF >${libc_prefix}/${ldconf}
			${libc_prefix}/${arch_libdir}
			${libc_prefix}/lib
		EOF

		if test -n "${ldconfig}"; then
			${libc_prefix}/${ldconfig} || exit
		fi
	fi

	binutils_main
	gcc_main
fi

##
# Stage 2
#

if ${enable_stage2}; then
	stage=2
	. ${include_dir}/tools.sh

	linux_headers_main
	libc_main

	if test -n "${dynamic_linker}"; then
		# Make GCC use dynamic linker in PREFIX instead of libc_prefix
		sed -i "s|${libc_prefix}|${PREFIX}|g" "${tools_prefix}/${libdir}/site.spec"

		cat <<-EOF >${PREFIX}/${ldconf}
			${PREFIX}/${arch_libdir}
			${PREFIX}/lib
			${tools_prefix}/${target_triplet}/${arch_libdir}
			${tools_prefix}/${target_triplet}/lib
			${tools_prefix}/${arch_libdir}
			${tools_prefix}/lib
		EOF

		if test -n "${ldconfig}"; then
			${PREFIX}/${ldconfig} || exit
		fi
	fi

	if ${need_tzdata}; then
		tzdata_main
	fi

	if ${WITH_LIBICONV} || ${need_libiconv} || ${need_iconv}; then
		libiconv_main
	fi

	libintl_main

	if ${need_libxcrypt} || ${WITH_LIBXCRYPT}; then
		libxcrypt_main
	fi

	zlib_main
	${WITH_ZSTD} && zstd_main

	${WITH_JANSSON} && jansson_main
	${WITH_LIBUNWIND} && libunwind_main
	${WITH_XXHASH} && xxhash_main

	libgmp_main
	libmpfr_main
	libmpc_main
	libisl_main

	binutils_main
	gcc_main

	# At this point we have gcc libraries in PREFIX, use them

	if test -n "${dynamic_linker}"; then
		cat <<-EOF >${PREFIX}/${ldconf}
			${PREFIX}/${arch_libdir}
			${PREFIX}/lib
		EOF

		if test -n "${ldconfig}"; then
			${PREFIX}/${ldconfig} || exit
		fi
	fi
fi

##
# Stage 3
#

if ${enable_stage3}; then
	stage=3
	. ${include_dir}/tools.sh

	libc_main

	if test -n "${ldconfig}"; then
		${PREFIX}/${ldconfig} || exit
	fi

	if ${need_tzdata}; then
		tzdata_main
	fi

	if ${WITH_LIBICONV} || ${need_libiconv} || ${need_iconv}; then
		libiconv_main
	fi

	libintl_main

	if ${need_libxcrypt} || ${WITH_LIBXCRYPT}; then
		libxcrypt_main
	fi

	# pkgconf/pkg-config
	${WITH_PKGCONF} && pkgconf_main

	if ${WITH_PKGCONF}; then
		export PKG_CONFIG=$(which pkgconf)
	elif ${WITH_PKG_CONFIG-false}; then
		export PKG_CONFIG=$(which pkg-config)
	else
		export PKG_CONFIG=$(which pkgconf || which pkg-config)
	fi

	# ncurses and readline
	${WITH_GPM} && gpm_main
	${WITH_NCURSES} && ncurses_main
	${WITH_READLINE} && readline_main

	# Compression
	zlib_main
	${WITH_BZIP2} && bzip2_main
	${WITH_LZ4} && lz4_main
	${WITH_LZMA} && lzma_main
	${WITH_ZSTD} && zstd_main

	# XML
	${WITH_EXPAT} && expat_main
	${WITH_LIBXML2} && libxml2_main # FIXME: provides python bindings

	# Json
	${WITH_JANSSON} && jansson_main

	# Perl
	${WITH_GDBM} && gdbm_main
	${WITH_PERL} && perl_main

	# Tcl/Tk
	${WITH_TCL} && tcl_main
	# TODO: ${WITH_TK} && tk_main
	${WITH_EXPECT} && expect_main

	# Sqlite
	${WITH_SQLITE3} && sqlite3_main

	# OpenSSL
	${WITH_BROTLI} && brotli_main
	${WITH_OPENSSL} && openssl_main

	# Python
	${WITH_LIBB2} && libb2_main
	${WITH_LIBFFI} && libffi_main
	${WITH_MPDECIMAL} && mpdecimal_main
	${WITH_PYTHON} && python_main

	# (mostly) GNU packages
	${WITH_BASH} && bash_main

	libgmp_main
	libmpfr_main
	libmpc_main
	libisl_main

	${WITH_LIBASPRINTF} && libasprintf_main
	${WITH_LIBSIGSEGV} && libsigsegv_main
	if ${WITH_GETTEXT} || ${WITH_LIBTEXTSTYLE}; then
		libtextstyle_main
	fi
	${WITH_LIBUNISTRING} && libunistring_main

	${WITH_M4} && m4_main
	${WITH_BISON} && bison_main
	${WITH_FLEX} && flex_main
	${WITH_GETTEXT} && gettext_main

	${WITH_AUTOCONF} && autoconf_main
	${WITH_LIBTOOL} && libtool_main
	${WITH_AUTOMAKE} && automake_main
	${WITH_DEJAGNU} && dejagnu_main

	# Guile
	${WITH_BDWGC} && bdwgc_main
	${WITH_GUILE2} && guile2_main
	${WITH_GUILE3} && guile3_main

	# more GNU packages
	${WITH_MAKE} && make_main
	${WITH_GPERF} && gperf_main
	${WITH_GENGEN} && gengen_main
	${WITH_GENGETOPT} && gengetopt_main
	${WITH_AUTOGEN} && autogen_main
	${WITH_INDENT} && indent_main
	${WITH_HELP2MAN} && help2man_main

	# Binutils, GCC and GDB
	${WITH_LIBUNWIND} && libunwind_main
	${WITH_XXHASH} && xxhash_main
	binutils_main
	${WITH_GDB} && gdb_main
	gcc_main

	# run ldconfig
	if test -n "${dynamic_linker}" && test -n "${ldconfig}"; then
		${PREFIX}/${ldconfig} || exit
	fi
fi

##
# Finalize
#

# Make sure info manuals are usable
if test -d ${PREFIX}/share/info; then
	for f in ${PREFIX}/share/info/*.info; do
		install-info $f ${PREFIX}/share/info/dir
	done
fi

# Write PREFIX/devenv.sh
devenv

exit 0
