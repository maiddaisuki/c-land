#!/bin/sh

# BUILD_SYSTEM: cmake

##
# Build xxhash (options as of version 0.8.3)
#
# XXHASH_BUILD_XXHSUM=BOOL [ON]
#

xxhash_configure() {
	local log_file=${logdir}/configure.log

	# Tools
	local build_xxhsum=OFF

	if test ${stage} -gt 2; then
		build_xxhsum=ON
	fi

	local options="
		-DCMAKE_BUILD_TYPE=Release

		-DBUILD_SHARED_LIBS=${build_shared_libs}
		${cmake_position_independent_code}

		-DCMAKE_INSTALL_PREFIX="${prefix}"
		-DCMAKE_INSTALL_LIBDIR=${libdir}

		-DXXHASH_BUILD_XXHSUM=${build_xxhsum}
	"

	log "%s: configuring\n" ${package}

	if test -d CMakeFiles; then
		rm -f ${logdir}/*
	fi

	cmake -S ${srcdir}/cmake_unofficial -B . --fresh \
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

xxhash_build() {
	_cmake_build
}

xxhash_check() {
	if ${CMAKE_TEST}; then
		: _cmake_check
	fi
}

xxhash_stage() {
	_cmake_stage
}

xxhash_pack() {
	_cmake_pack
}

xxhash_install() {
	_cmake_install
}

xxhash_main() {
	_cmake_main xxhash ${XXHASH_SRCDIR}
}
