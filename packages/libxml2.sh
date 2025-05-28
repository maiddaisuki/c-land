#!/bin/sh

# BUILD_SYSTEM: cmake

##
# Build libxml2 (options as of version 2.14.2)
#
# LIBXML2_WITH_PROGRAMS=BOOL [ON]
# LIBXML2_WITH_TESTS=BOOL    [ON]
#
## Interface
#
# LIBXML2_WITH_PATTERN=BOOL [ON]
# LIBXML2_WITH_PUSH=BOOL    [ON]
# LIBXML2_WITH_READER=BOOL  [ON]
# LIBXML2_WITH_WRITER=BOOL  [ON]
# LIBXML2_WITH_TREE=BOOL    [ON]
#
# LIBXML2_WITH_SAX1=BOOL    [ON]
#
# LIBXML2_WITH_LEGACY=BOOL  [OFF]
#
## Features
#
# LIBXML2_WITH_MODULES=BOOL      [ON]
# LIBXML2_WITH_DEBUG=BOOL        [ON]
#
# LIBXML2_WITH_THREADS=BOOL      [ON]
# LIBXML2_WITH_THREAD_ALLOC=BOOL [OFF]
# LIBXML2_WITH_TLS=BOOL          [OFF]
#
# LIBXML2_WITH_REGEXPS=BOOL      [ON]
#
# LIBXML2_WITH_FTP=BOOL          [OFF]
# LIBXML2_WITH_HTML=BOOL         [ON]
# LIBXML2_WITH_HTTP=BOOL         [OFF]
#
# LIBXML2_WITH_C14N=BOOL         [ON]
# LIBXML2_WITH_CATALOG=BOOL      [ON]
# LIBXML2_WITH_OUTPUT=BOOL       [ON]
# LIBXML2_WITH_RELAXNG=BOOL      [ON]
# LIBXML2_WITH_SCHEMAS=BOOL      [ON]
# LIBXML2_WITH_SCHEMATRON=BOOL   [ON]
# LIBXML2_WITH_VALID=BOOL        [ON]
# LIBXML2_WITH_XINCLUDE=BOOL     [ON]
# LIBXML2_WITH_XPATH=BOOL        [ON]
# LIBXML2_WITH_XPTR=BOOL         [ON]
#
## Dependencies
#
# LIBXML2_WITH_ICONV=BOOL         [ON]
# LIBXML2_WITH_ICU=BOOL           [OFF]
# LIBXML2_WITH_ISO8859X=BOOL      [ON]
#
# LIBXML2_WITH_READLINE=BOOL      [OFF]
#
# LIBXML2_WITH_LZMA=BOOL          [OFF]
# LIBXML2_WITH_ZLIB=BOOL          [OFF]
#
# LIBXML2_WITH_PYTHON=BOOL        [ON]
# LIBXML2_PYTHON_INSTALL_DIR=PATH [/usr/local/python]
#

libxml2_configure() {
	local log_file=${logdir}/configure.log

	# Optional dependencies
	local with_lzma=OFF
	local with_readline=OFF
	local with_zlib=OFF

	${WITH_LZMA} && with_lzma=ON
	${WITH_READLINE} && with_readline=ON
	${WITH_ZLIB} && with_zlib=ON

	# Features
	local with_modules=OFF
	local with_tests=OFF

	if test -n "${dynamic_linker}"; then
		with_modules=ON
	fi

	if ${CMAKE_TEST}; then
		with_tests=ON
	fi

	# Python
	local with_python=OFF
	local python_install_dir=

	# TODO: Where to install Python bindings?
	# if ${WITH_PYTHON}; then
	# 	with_python=ON
	# 	python_install_dir=${libdir}/python3/libxml2
	# fi

	local options="
		-DCMAKE_BUILD_TYPE=Release

		-DBUILD_SHARED_LIBS=${build_shared_libs}
		${cmake_position_independent_code}

		-DCMAKE_INSTALL_PREFIX=${prefix}
		-DCMAKE_INSTALL_LIBDIR=${libdir}

		-DLIBXML2_WITH_THREADS=ON
		-DLIBXML2_WITH_TLS=ON

		-DLIBXML2_WITH_MODULES=${with_modules}
		-DLIBXML2_WITH_TESTS=${with_tests}

		-DLIBXML2_WITH_LZMA=${with_lzma}
		-DLIBXML2_WITH_READLINE=${with_readline}
		-DLIBXML2_WITH_ZLIB=${with_zlib}

		-DLIBXML2_WITH_PYTHON=${with_python}
		-DLIBXML2_PYTHON_INSTALL_DIR=${python_install_dir}
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

libxml2_build() {
	_cmake_build
}

libxml2_check() {
	if ${CMAKE_TEST}; then
		_cmake_check
	fi
}

libxml2_stage() {
	_cmake_stage
}

libxml2_pack() {
	_cmake_pack
}

libxml2_install() {
	_cmake_install
}

libxml2_main() {
	_cmake_main libxml2 ${LIBXML2_SRCDIR}
}
