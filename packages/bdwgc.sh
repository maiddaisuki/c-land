#!/bin/sh

# BUILD_SYSTEM: cmake

##
# Build bdwgc (options as of version 8.2.8)
#
## C++
#
# enable_cplusplus=BOOL               [OFF]
# enable_throw_bad_alloc_library=BOOL [ON]
#
## Java
#
# enable_gcj_support=BOOL       [ON]
# enable_java_finalization=BOOL [ON]
#
## Features
#
# build_cord=BOOL  [ON]
# build_tests=BOOL [OFF]
#
# enable_mmap=BOOL   [OFF]
# enable_munmap=BOOL [ON]
#
# without_libatomic_ops=ON|OFF
#
# enable_atomic_uncollectable=BOOL      [ON]
# enable_checksum=BOOL                  [OFF]
# enable_disclaim=BOOL                  [ON]
# enable_dynamic_loading=BOOL           [ON]
# enable_emscripten_asyncify=BOOL       [OFF]
# enable_handle_fork=BOOL               [ON]
# enable_large_config=BOOL              [OFF]
# enable_parallel_mark=BOOL             [ON]
# enable_redirect_malloc=BOOL           [OFF]
# enable_register_main_static_data=BOOL [ON]
# enable_sigrt_signals=BOOL             [OFF]
# enable_thread_local_alloc=BOOL        [ON]
# enable_threads=BOOL                   [ON]
# enable_threads_discovery=ON|OFF
#
## Build
#
# enable_single_obj_compilation=BOOL [OFF]
# enable_werror=BOOL                 [OFF]
#
## Installation
#
# install_headers=BOOL [ON]
# enable_docs=BOOL     [ON]
#
## Developer Options
#
# disable_gc_debug=BOOL     [OFF]
# enable_gc_assertions=BOOL [OFF]
#

bdwgc_configure() {
	local log_file=${logdir}/configure.log

	local options="
		-DCMAKE_BUILD_TYPE=Release

		-DBUILD_SHARED_LIBS=${build_shared_libs}
		${cmake_position_independent_code}

		-DCMAKE_INSTALL_PREFIX=${prefix}
		-DCMAKE_INSTALL_LIBDIR=${libdir}

		-Denable_cplusplus=ON
		-Denable_throw_bad_alloc_library=ON

		-Denable_gcj_support=OFF

		-Dbuild_cord=ON
		-Dbuild_tests=ON

		-Denable_threads=ON
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

bdwgc_build() {
	_cmake_build
}

bdwgc_check() {
	if ${CMAKE_TEST}; then
		_cmake_check
	fi
}

bdwgc_stage() {
	_cmake_stage
}

bdwgc_pack() {
	_cmake_pack
}

bdwgc_install() {
	_cmake_install
}

bdwgc_main() {
	_cmake_main bdwgc ${BDWGC_SRCDIR}
}
