#!/bin/sh

# BUILD_SYSTEM: cmake

##
# Build jansson (options as of version 2.14.1)
#
# JANSSON_LIBRARIES=STRING               [jansson]
# JANSSON_BUILD_SHARED_LIBS=BOOL         [OFF]
#
# JANSSON_EXAMPLES=BOOL                  [ON]
#
## Features
#
# JANSSON_INITIAL_HASHTABLE_ORDER=STRING [3]
#
# USE_DTOA=BOOL                          [ON]
#
# USE_URANDOM=BOOL                       [ON]
# USE_WINDOWS_CRYPTOAPI=BOOL             [ON]
#
## Build
#
# JANSSON_INCLUDE_DIRS=PATH
# JANSSON_WITHOUT_TESTS=BOOL             [OFF]
#
## Installation
#
# JANSSON_INSTALL=BOOL                   [ON]
#
# JANSSON_BUILD_DOCS=BOOL                [ON]
# Sphinx_DIR=PATH
#
# JANSSON_INSTALL_BIN_DIR=STRING         [bin]
# JANSSON_INSTALL_INCLUDE_DIR=STRING     [include]
# JANSSON_INSTALL_LIB_DIR=STRING         [lib]
# JANSSON_INSTALL_CMAKE_DIR=STRING       [lib/cmake/jansson]
#
## Developer Options
#
# JANSSON_COVERAGE=BOOL                  [OFF]
# JANSSON_TEST_WITH_VALGRIND=BOOL        [OFF]
#

jansson_configure() {
	local log_file=${logdir}/configure.log

	local options="
		-DCMAKE_BUILD_TYPE=Release

		-DJANSSON_BUILD_SHARED_LIBS=${build_shared_libs}
		${cmake_position_independent_code}

		-DCMAKE_INSTALL_PREFIX=${prefix}
		-DCMAKE_INSTALL_LIBDIR=${libdir}

		-DJANSSON_EXAMPLES=OFF
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

jansson_build() {
	_cmake_build
}

jansson_check() {
	if ${CMAKE_TEST}; then
		_cmake_check
	fi
}

jansson_stage() {
	_cmake_stage
}

jansson_pack() {
	_cmake_pack
}

jansson_install() {
	_cmake_install
}

jansson_main() {
	_cmake_main jansson ${JANSSON_SRCDIR}
}
