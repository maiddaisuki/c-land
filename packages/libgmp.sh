#!/bin/sh

# BUILD_SYSTEM: autotools

##
# Build libgmp (options are as of version 6.3.0)
#
# --enable-assembly
# --enable-cxx
#
# --enable-fft
# --enable-old-fft-full
#
# --enable-alloca
#
# --with-readline
#
## ???
#
# --enable-fake-cpuid
# --enable-nails
#
## Build
#
# --enable-fat
#
## Developer Options
#
# --enable-assert
# --enable-profiling
#
# --enable-minithres
#

libgmp_configure() {
	local log_file=${logdir}/configure.log

	# --build and --host
	local build_host=

	if test ${stage} -eq 1; then
		build_host="--build=${build_triplet} --host=${build_triplet}"
	else
		build_host="--build=${target_triplet} --host=${target_triplet}"
	fi

	# features
	local enable_cxx=--disable-cxx
	local enable_assembly=
	local enable_alloca=

	if test ${stage} -eq 3; then
		enable_cxx=--enable-cxx
		enable_assembly=--enable-assembly
		enable_alloca=--enable-alloca
	fi

	local configure_options="
		${build_host}

		--disable-dependency-tracking
		--disable-silent-rules

		${with_static_libs}
		${with_shared_libs}
		${with_pic}

		--prefix=${prefix}
		--libdir=${prefix}/${libdir}

		${enable_cxx}

		${enable_alloca}
		${enable_assembly}
	"

	if test -f ${builddir}/Makefile; then
		make distclean >/dev/null 2>&1
		rm -f ${logdir}/*
	fi

	log "%s: configuring\n" ${package}

	${srcdir}/configure \
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

libgmp_build() {
	_make_build
}

libgmp_check() {
	if ${MAKE_CHECK}; then
		_make_check
	fi
}

libgmp_stage() {
	_make_stage
}

libgmp_pack() {
	_make_pack
}

libgmp_install() {
	_make_install
}

libgmp_main() {
	_make_main libgmp ${LIBGMP_SRCDIR}
}
