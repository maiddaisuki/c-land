#!/bin/sh

# BUILD_SYSTEM: autotools (autoconf)

##
# Build python (options as of version 3.13.2)
#
# --without-static-libpython
#
## Dependencies
#
# --with-pkg-config=yes|no|check
#
# --with-libc=STRING
# --with-libm=STRING
# --with-libs=LIST
#
# --with-system-expat
# --with-system-libmpdec
#
# --with-readline=editline|readline|no
#
# --with-openssl=DIR
# --with-openssl-rpath=DIR|auto|no
#
# --with-dbmliborder=LIST [gdbm:ndbm:bdb]
#
## Features
#
# --enable-big-digits[=15|30]
# --enable-ipv6
# --enable-loadable-sqlite-extensions
#
# --with-builtin-hashlib-hashes=md5,sha1,sha2,sha3,blake2
# --with-hash-algorithm=fnv|siphash13|siphash24
# --with-ssl-default-suites=python|openssl|STRING
#
# --with-c-locale-coercion
# --with-tzpath=LIST
#
# --with-mimalloc
# --with-pymalloc
# --with-freelists
#
## Build
#
# --with-build-python=PYTHON
#
# --with-computed-gotos
# --with-decimal-contextvar
# --with-strict-overflow
#
# --enable-optimizations
# --enable-bolt
#
# --with-lto=full|thin|no|yes
#
# --disable-test-modules
#
## Installation
#
# --with-platlibdir=DIRNAME [default=lib]
# --with-suffix=SUFFIX [yes == .exe]
#
# --with-doc-strings
#
## Developer Options
#
# --with-pydebug
# --with-trace-refs
# --with-assertions
#
# --with-valgrind
# --with-dtrace
#
# --with-address-sinitizer
# --with-memory-sanitizer
# --with-thread-sanitizer
# --with-undefined-behavior-sinitizer
#
# --enable-pystats
# --enable-profiling
#
## Experemntal
#
# --enable-experimental-jit[=no|yes|yes-off|interpreter]
# --disable-gil
#
## ???
#
# --with-ensurepip[=install|upgrade|no]
# --with-wheel-pkg-dir=PATH
#

python_configure() {
	local log_file=${logdir}/configure.log

	# Features
	local enable_loadable_sqlite=--disable-loadable-sqlite-extensions
	local with_static_libpython=--with-static-libpython

	case ${with_static_libs} in
	*disable*)
		with_static_libpython=--without-static-libpython
		;;
	esac

	if test -n "${dynamic_linker}"; then
		enable_loadable_sqlite=--enable-loadable-sqlite-extensions
	fi

	# Optional dependencies
	local with_expat=--without-system-expat
	local with_readline=--without-readline

	if ${WITH_EXPAT}; then
		with_expat=--with-system-expat
	fi

	if ${WITH_READLINE}; then
		with_readline="--with-readline=readline"
	fi

	local configure_options="
		--build=${target_triplet}
		--host=${target_triplet}

		${with_shared_libs}
		${with_static_libpython}

		--prefix=${prefix}
		--libdir=${prefix}/${libdir}
		--with-platlibdir=${libdir}

		${enable_loadable_sqlite}

		${with_expat}
		${with_readline}
		--with-system-libmpdec

		--with-ensurepip=no
	"

	if test -f ${builddir}/Makefile; then
		make distclean >/dev/null 2>&1
		rm -f ${logdir}/*
	fi

	log "%s: configuring\n" ${package}

	${srcdir}/configure \
		CC="${cc}" \
		CPPFLAGS="${cppflags}" \
		CFLAGS="${cflags}" \
		CXX="${cxx}" \
		CXXFLAGS="${cxxflags}" \
		AS="${as}" \
		ASFLAGS="${ASFLAGS}" \
		LD="${LD}" \
		LDFLAGS="${ldflags}" \
		AR="${AR}" \
		RANLIB="${RANLIB}" \
		NM="${NM}" \
		OBJDUMP="${OBJDUMP}" \
		OBJCOPY="${OBJCOPY}" \
		STRIP="${STRIP}" \
		PKG_CONFIG="${PKG_CONFIG}" \
		${configure_options} \
		>>${log_file} 2>&1

	test $? -eq 0 || die "${package}: configuration failed"
}

python_build() {
	_make_build
}

python_check() {
	if ${MAKE_CHECK}; then
		_make_check test
	fi
}

python_stage() {
	_make_stage install
}

python_pack() {
	_make_pack
}

python_install() {
	_make_install
}

python_main() {
	_make_main python ${PYTHON_SRCDIR}
}
