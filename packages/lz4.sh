#!/bin/sh

# BUILD_SYSTEM: cmake

##
# Build liblz4 (options as of version 1.9.4)
#
# BUILD_SHARED_LIBS=BOOL     [ON]
# BUILD_STATIC_LIBS=BOOL     [OFF]
#
# LZ4_BUILD_CLI=BOOL         [ON]
# LZ4_BUILD_LEGACY_LZ4C=BOOL [ON]
#
# LZ4_POSITION_INDEPENDENT_LIB=BOOL [ON]
#

lz4_configure() {
	local log_file=${logdir}/configure.log

	# Build options
	local pic=

	if ${ENABLE_PIC}; then
		pic="-DLZ4_POSITION_INDEPENDENT_LIB=ON"
	fi

	local options="
		-DCMAKE_BUILD_TYPE=Release

		-DBUILD_STATIC_LIBS=${build_static_libs}
		-DBUILD_SHARED_LIBS=${build_shared_libs}
		${cmake_position_independent_code}
		${pic}

		-DCMAKE_INSTALL_PREFIX=${prefix}
		-DCMAKE_INSTALL_LIBDIR=${libdir}
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

lz4_build() {
	_cmake_build
}

lz4_check() {
	if ${CMAKE_TEST}; then
		: _cmake_check
	fi
}

lz4_stage() {
	_cmake_stage
}

lz4_pack() {
	_cmake_pack
}

lz4_install() {
	_cmake_install
}

lz4_main() {
	_cmake_main lz4 ${LZ4_SRCDIR}
}
