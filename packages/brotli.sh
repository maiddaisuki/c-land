#!/bin/sh

# BUILD_SYSTEM: cmake

##
# Build brotli (options as of version 1.1.0)
#
# BUILD_TESTING=BOOL [ON]
#

brotli_configure() {
	local log_file=${logdir}/configure.log

	local options="
		-DCMAKE_BUILD_TYPE=Release

		-DBUILD_SHARED_LIBS=${build_shared_libs}
		${cmake_position_independent_code}

		-DCMAKE_INSTALL_PREFIX=${prefix}
		-DCMAKE_INSTALL_LIBDIR=${libdir}

		-DBUILD_TESTING=ON
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

brotli_build() {
	_cmake_build
}

brotli_check() {
	if ${CMAKE_TEST}; then
		_cmake_check
	fi
}

brotli_stage() {
	_cmake_stage
}

brotli_pack() {
	_cmake_pack
}

brotli_install() {
	_cmake_install
}

brotli_main() {
	_cmake_main brotli ${BROTLI_SRCDIR}
}
