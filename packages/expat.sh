#!/bin/sh

# BUILD_SYSTEM: cmake

##
# Build expat (options as of version 2.7.1)
#
# EXPAT_SHARED_LIBS=BOOL     [ON]
#
# EXPAT_BUILD_EXAMPLES=BOOL  [ON]
# EXPAT_BUILD_PKGCONFIG=BOOL [ON]
# EXPAT_BUILD_TESTS=BOOL     [ON]
# EXPAT_BUILD_TOOLS=BOOL     [ON]
#
# EXPAT_BUILD_FUZZERS=BOOL   [OFF]
# EXPAT_OSSFUZZ_BUILD=BOOL   [OFF]
#
## Features
#
# EXPAT_CHAR_TYPE=char|uint16_t|wchar_t [char]
#
# EXPAT_WITH_GETRANDOM=AUTO
# EXPAT_WITH_SYS_GETRANDOM=AUTO
#
# EXPAT_WITH_LIBBSD=BOOL [OFF]
#
## Build
#
# EXPAT_WARNINGS_AS_ERRORS=BOOL [OFF]
#
## Installation
#
# EXPAT_ENABLE_INSTALL=BOOL [ON]
#
# EXPAT_BUILD_DOCS=BOOL     [OFF]
# DOCBOOK_TO_MAN=STRING     [DOCBOOK_TO_MAN-NOTFOUND]
#

expat_configure() {
	local log_file=${logdir}/configure.log

	local options="
		-DCMAKE_BUILD_TYPE=Release

		-DEXPAT_SHARED_LIBS=${build_shared_libs}
		${cmake_position_independent_code}

		-DCMAKE_INSTALL_PREFIX="${prefix}"
		-DCMAKE_INSTALL_LIBDIR=${libdir}

		-DEXPAT_BUILD_TESTS=ON

		-DEXPAT_BUILD_EXAMPLES=OFF
		-DEXPAT_BUILD_PKGCONFIG=ON
	"

	log "%s: configuring\n" ${package}

	if test -d CMakeFiles; then
		rm -f ${logdir}/*
	fi

	cmake -S ${srcdir}/expat -B . --fresh \
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

expat_build() {
	_cmake_build
}

expat_check() {
	if ${CMAKE_TEST}; then
		_cmake_check
	fi
}

expat_stage() {
	_cmake_stage
}

expat_pack() {
	_cmake_pack
}

expat_install() {
	_cmake_install
}

expat_main() {
	_cmake_main expat ${EXPAT_SRCDIR}
}
