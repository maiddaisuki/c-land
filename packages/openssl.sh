#!/bin/sh

# BUILD_SYSTEM: make (Configure)

##
# Build openssl (options as of version 3.5.0)
#
# --w
# --banner=TEXT
#

## Library and Dynamic Loading
#
# no-shared
# no-pinshared
#
# no-pic | enable-pie
# no-dso
#
# no-err
# no-filenames
#

## Dependencies
#
# zlib[-dynamic]
# --with-zlib-include=DIR
# --with-zlib-lib=DIR
#
# enable-zstd[-dynamic]
# --with-zstd-include=DIR
# --with-zstd-lib=DIR
#
# enable-brotli[-dynamic]
# --with-brotli-include=DIR
# --with-brotli-lib=DIR
#
# enable-jitter
# --with-jitter-include=DIR
# --with-jitter-lib=DIR
#

## Features
#
# no-ui-console
#
# no-async
# no-atexit
# no-cached-fetch
# no-multiblock
#
# no-autoalginit (forces static library)
# no-autoerrinit
#
# no-autoload-config
#
# enable-sslkeylog
#
# [API]
#
# --api=VERSION
# no-deprecated
#
# enable-trace
# no-ssl-trace
#
# [Threads]
#
# no-threads | threads
# no-thread-pool | thread-pool
# no-default-thread-pool | default-thread-pool
#
# [I/O]
#
# no-posix-io
# no-stdio (disables build of programs)
#
# [Other]
#
# enable-ktls
#

## Random Seed
#
# --with-random-seed=SEED,...
#
#	where SEED is any of:
#
#	 - none
#	 - os
#	 - getrandom
#	 - devrandom
#	 - egd
#	 - rdcpu
#	 - jitter
#

## Algorithms
#
# enable-{algorithm}
#
#	where algorithm:
#
#	- md2
#	- rc5
#
# no-{algorithm}
#
#	where algorithm:
#
#	- aria
#	- bf
#	- blake2
#	- camellia
#	- cast
#	- chacha
#	- cmac
#	- des
#	- dh
#	- dsa
#	- ecdh
#	- ecdsa
#	- idea
#	- md4
#	- mdc2
#	- ocb
#	- poly1305
#	- rc2
#	- rc4
#	- rmd160 (ripemd is a deprecated alias)
#	- scrypt
#	- seed
#	- siphash
#	- siv
#	- sm2
#	- sm3
#	- sm4
#	- whirlpool
#

## Engines
#
# no-engine
#
# no-module
# no-dynamic-engine
# no-static-engine
#
# no-afalgeng
# no-capieng
# no-nextprotoeng
# no-padlockeng (no-hw-padlock is a deprecated synonym)
#
# enable-devcryptoeng
#

## Protocols
#
# no-{protocol}
#
#	where protocol:
#
#	- ssl
#	- ssl3
#	- tls
#	- tls1
#	- tls1_1
#	- tls1_2
#	- tls1_3
#	- dtls
#	- dtls1
#	- dtls1_2
#
# no-{protocol}-method
#
#	where protocol:
#
#	- ssl3
#	- tls1
#	- tls1_1
#	- tls1_2
#	- dtls1
#	- dtls1_2
#
# no-tls-deprecated-ec
#

## Providers
#
# no-legacy
#

## FIPS Provider
#
# enable-fips
# enable-fips-jitter
#
# no-fips-securitychecks
# no-fips-posr
#
# enable-acvp-tests
#
# --fips-key=HEX_STRING
#

## Other Features
#
# no-cmp
# no-cms
# no-comp
# no-ct
# no-dgram
# no-ec
# no-ec2m
# no-gost
# no-http
# no-ml-dsa
# no-ml-kem
# no-oscp
# no-psk
# no-rfc3779
# no-slh-dsa
# no-sock
# no-srp
# no-srtp
# no-quic
# no-ts
# no-uplink
# no-integrity-only-ciphers
#
# enable-ec_nistp_64_gcc_128
# enable-edg
# enable-tfo
# enable-weak-ssl-ciphers
# enable-unstable-qlog
# sctp
#

## Build
#
# --release
# --debug
#
# no-apps (also disables tests)
#
# no-tests
# enable-buildtest-c++
#
# no-makedepend
#
# no-asm
# no-rdrand
#
# [x86]
#
# 386
# no-sse2
#
# [aarch64]
#
# no-sm2-precomp
#

## Installation
#
# --prefix=DIRNAME
# --libdir=DIRNAME (under $prefix)
#
# --openssldir=DIRNAME (default=/usr/local/ssl)
#
# no-docs
#

## Developer Options
#
# no-bulk
#
# --strict-warnings
#
# enable-asan
# enable-ubsan
#
# enable-fuzz-libfuzzer
# enable-fuzz-afl
#
# enable-extarnal-tests
# enable-unit-test
#
## Legacy
#
# enable-crypto-mdebug
# enable-crypto-mdebug-backtrace
#

openssl_configure() {
	local log_file=${logdir}/configure.log

	local os=

	case ${target_triplet} in
	x86_64-*)
		os=linux-x86_64
		;;
	i?386-)
		os=linux-x86
		;;
	*)
		die "${package}: please set value for 'os' variable corresponding to '${target_triplet}'"
		;;
	esac

	# Optional dependencies
	local enable_zlib=
	local enable_zstd=no-zstd
	local enable_brotli=no-brotli

	# Library type
	local enable_shared=
	local enable_dynamic=
	local enable_pic=
	local enable_pie=

	# Build options
	local tests=no-tests

	if ${WITH_ZLIB}; then
		if test -n "${dynamic_linker}"; then
			enable_zlib=zlib-dynamic
		else
			enable_zlib=zlib
		fi
	fi

	if ${WITH_ZSTD}; then
		if test -n "${dynamic_linker}"; then
			enable_zstd=enable-zstd-dynamic
		else
			enable_zstd=enable-zstd
		fi
	fi

	if ${WITH_BROTLI}; then
		if test -n "${dynamic_linker}"; then
			enable_brotli=enable-brotli-dynamic
		else
			enable_brotli=enable-brotli
		fi
	fi

	if ${ENABLE_PIC}; then
		enable_pic='enable-pic'

		if test -n "${dynamic_linker}"; then
			enable_pie='enable-pie'
		fi
	fi

	if test -n "${dynamic_linker}"; then
		enable_shared=enable-shared
		enable_dynamic=enable-dynamic-engine
		tests=enable-buildtest-c++
	else
		enable_shared='no-shared no-pinshared no-dso'
		enable_dynamic=no-dynamic-engine
	fi

	local configure_options="
		${os}
		--release

		--prefix=${prefix}
		--libdir=${libdir}
		--openssldir=${prefix}/share/ssl

		${enable_shared}
		${enable_dynamic}
		${enable_pic}
		${enable_pie}

		enable-threads

		${enable_zlib}
		${enable_zstd}
		${enable_brotli}

		${tests}
	"

	if test -f ${builddir}/Makefile; then
		make clean >/dev/null 2>&1
		rm -f ${logdir}/*
	fi

	log "%s: configuring\n" ${package}

	${srcdir}/Configure \
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
		${configure_options} \
		>>${log_file} 2>&1

	test $? -eq 0 || die "${package}: configuration failed"
}

openssl_build() {
	_make_build
}

openssl_check() {
	if ${MAKE_CHECK}; then
		LD_LIBRARY_PATH=${builddir} _make_check test
	fi
}

openssl_stage() {
	_make_stage install
}

openssl_pack() {
	_make_pack
}

openssl_install() {
	_make_install
}

openssl_main() {
	_make_main openssl ${OPENSSL_SRCDIR}
}
