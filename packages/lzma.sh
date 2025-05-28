#!/bin/sh

# BUILD_SYSTEM: cmake

##
# Build liblzma (options as of version 5.8.1)
#
# XZ_SMALL=BOOL              [OFF]
# BUILD_TESTING=BOOL         [ON]
#
# XZ_TOOL_XZ=BOOL            [ON]
# XZ_TOOL_XZDEC=BOOL         [ON]
# XZ_TOOL_LZMADEC=BOOL       [ON]
# XZ_TOOL_LZMAINFO=BOOL      [ON]
#
# XZ_TOOL_SCRIPTS=BOOL       [ON]
# XZ_POSIX_SHELL=STRING      [/bin/sh]
#
# XZ_TOOL_SYMLINKS=BOOL      [ON]
# XZ_TOOL_SYMLINKS_LZMA=BOOL [ON]
#
# XZ_NLS=BOOL                [ON]
#
# XZ_SYMBOL_VERSIONING=auto|yes|no|generic|linux [auto]
# XZ_THREADS=yes|no|posix|win95|vista            [yes]
#
# XZ_ASSUME_RAM=STRING                [128]
#
# TUKLIB_FAST_UNALIGNED_ACCESS=BOOL   [ON]
# TUKLIB_USE_UNSAFE_TYPE_PUNNING=BOOL [OFF]
#
## Features
#
# XZ_CHECKS=LIST            [crc32;crc64;sha256]
# XZ_CLMUL_CRC=BOOL         [ON]
#
# XZ_EXTERNAL_SHA256=BOOL   [OFF]
#
# XZ_ENCODERS=LIST          [lzma1;lzma2;delta;x86;arm;armthumb;arm64;powerpc;ia64;sparc;riscv]
# XZ_DECODERS=LIST          [lzma1;lzma2;delta;x86;arm;armthumb;arm64;powerpc;ia64;sparc;riscv]
#
# XZ_MICROLZMA_DECODER=BOOL [ON]
# XZ_MICROLZMA_ENCODER=BOOL [ON]
#
# XZ_LZIP_DECODER=BOOL      [ON]
#
# XZ_MATCH_FINDERS=LIST     [hc3;hc4;bt2;bt3;bt4]
#
# XZ_SANDBOX=STRING         [auto]
#
## Architecture specific
#
# [x86]
#
# XZ_ASM_I386=BOOL [OFF]
#
# [arm64]
#
# XZ_ARM64_CRC32=BOOL[ON]
#
# [longarch]
#
# XZ_LOONGARCH_CRC32=BOOL [ON]
#
## Installation
#
# XZ_INSTALL_CMAKEDIR=STRING [lib/cmake/liblzma]
#
# XZ_DOC=BOOL                [ON]
# XZ_DOXYGEN=BOOL            [OFF]
#

lzma_configure() {
	local log_file=${logdir}/configure.log

	# Misc
	local shell='/bin/sh'

	if ${WITH_BASH}; then
		shell=${PREIFX}/bin/bash
	fi

	local options="
		-DCMAKE_BUILD_TYPE=Release

		-DBUILD_SHARED_LIBS=${build_shared_libs}
		${cmake_position_independent_code}

		-DCMAKE_INSTALL_PREFIX=${prefix}
		-DCMAKE_INSTALL_LIBDIR=${libdir}

		-DXZ_POSIX_SHELL="${shell}"
		-DXZ_THREADS=posix
	"

	log "%s: configuring\n" ${package}

	if test -d CMakeFiles; then
		rm -f ${logdir}/*
	fi

	cmake -S ${srcdir} -B . --fresh \
		-DCMAKE_C_COMPILER="${cmake_c_compiler}" \
		-DCMAKE_C_FLAGS="${cppflags}" \
		-DCMAKE_C_FLAGS_RELEASE="${cflags}" \
		-DCMAKE_CXX_COMPILER="${cmake_cxx_compiler}" \
		-DCMAKE_CXX_FLAGS="${cppflags}" \
		-DCMAKE_CXX_FLAGS_RELEASE="${cxxflags}" \
		-DCMAKE_EXE_LINKER_FLAGS="${ldflags}" \
		-DCMAKE_SHARED_LINKER_FLAGS="${ldflags}" \
		${options} \
		>>${log_file} 2>&1

	test $? -eq 0 || die "${package}: configuration failed"
}

lzma_build() {
	_cmake_build
}

lzma_check() {
	if ${CMAKE_TEST}; then
		_cmake_check
	fi
}

lzma_stage() {
	_cmake_stage
}

lzma_pack() {
	_cmake_pack
}

lzma_install() {
	_cmake_install
}

lzma_main() {
	_cmake_main lzma ${LZMA_SRCDIR}
}
