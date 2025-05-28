#!/bin/sh

# BUILD_SYSTEM: cmake

##
# Build zstd (options as of version 1.5.7)
#
# ZSTD_BUILD_SHARED=BOOL         [ON]
# ZSTD_BUILD_STATIC=BOOL         [ON]
#
# ZSTD_PROGRAMS_LINK_SHARED=BOOL [OFF]
#
# (requires ZSTD_BUILD_STATIC=ON)
# ZSTD_BUILD_TESTS=BOOL          [OFF]
#
# ZSTD_LEGACY_SUPPORT=BOOL       [ON]
# ZSTD_LEGACY_LEVEL=STRING       [5]
#
## Build
#
# ZSTD_BUILD_PROGRAMS=BOOL      [ON]
#
# ZSTD_BUILD_COMPRESSION=BOOL   [ON]
# ZSTD_BUILD_DECOMPRESSION=BOOL [ON]
# ZSTD_BUILD_DICTBUILDER=BOOL   [ON]
#
# ZSTD_BUILD_DEPRECATED=BOOL    [OFF]
#
# ZSTD_BUILD_CONTRIB=BOOL       [OFF]
#
## API visibility
#
# ZSTDLIB_VISIBLE=STRING
# ZSTDLIB_STATIC_API=STRING
#
# ZDICTLIB_STATIC_API=STRING
# ZDICTLIB_VISIBLE=STRING
#
# ZSTDERRORLIB_VISIBLE=STRING
#
## Optional dependencies
#
# ZSTD_LZ4_SUPPORT=BOOL
# ZSTD_LZMA_SUPPORT=BOOL
# ZSTD_ZLIB_SUPPORT=BOOL
#

zstd_configure() {
	local log_file=${logdir}/configure.log

	# Optional dependencies
	local with_zlib=OFF
	local with_lzma=OFF
	local with_lz4=OFF

	# Features
	local build_programs=OFF

	if test ${stage} -gt 2 || ${CMAKE_TEST}; then
		# tests require static library
		local build_static_libs=ON
	fi

	if test ${stage} -gt 2; then
		# programs require static library
		build_programs=ON

		${WITH_LZ4} && with_lz4=ON
		${WITH_LZMA} && with_lzma=ON
		${WITH_ZLIB} && with_zlib=ON
	fi

	local options="
		-DCMAKE_BUILD_TYPE=Release

		-DZSTD_BUILD_STATIC=${build_static_libs}
		-DZSTD_BUILD_SHARED=${build_shared_libs}
		${cmake_position_independent_code}

		-DCMAKE_INSTALL_PREFIX=${prefix}
		-DCMAKE_INSTALL_LIBDIR=${libdir}

		-DZSTD_BUILD_PROGRAMS=${build_programs}
		-DZSTD_BUILD_TESTS=${build_static_libs}

		-DZSTD_ZLIB_SUPPORT=${with_zlib}
		-DZSTD_LZMA_SUPPORT=${with_lzma}
		-DZSTD_LZ4_SUPPORT=${with_lz4}
	"

	log "%s: configuring\n" ${package}

	if test -d CMakeFiles; then
		rm -f ${logdir}/*
	fi

	cmake -S ${srcdir}/build/cmake -B . --fresh \
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

zstd_build() {
	_cmake_build
}

zstd_check() {
	if ${CMAKE_TEST}; then
		_cmake_check
	fi
}

zstd_stage() {
	_cmake_stage
}

zstd_pack() {
	_cmake_pack
}

zstd_install() {
	_cmake_install
}

zstd_main() {
	_cmake_main zstd ${ZSTD_SRCDIR}
}
