#!/bin/sh

# BUILD_SYSTEM: autotools

##
# Build libmpfr (options are as of version 4.2.2)
#
# --enable-logging
# --enable-formally-proven-code
#
# --enable-thread-safe
# --enable-shared-cache
#
# --enable-decimal-point
# --enable-float128
#
# --enable-gmp-internals
#
# --with-mulhigh-size=NU
#
## Dependencies
#
# --with-gmp=DIR
# --with-gmp-include=DIR
# --with-gmp-lib=DIR
# --with-gmp-build=DIR
#
# --with-mini-gmp=DIR
#
## Developer options
#
# --enable-warnings
# --enable-assert
#
# --enable-tune-for-coverage
# --enable-debug-predictions
#
# --enable-test-timeout=NUM
#
# [Experemental]
#
# --enable-lto
#

libmpfr_configure() {
	local log_file=${logdir}/configure.log

	# --build and --host
	local build_host=

	if test ${stage} -eq 1; then
		build_host="--build=${build_triplet} --host=${build_triplet}"
	else
		build_host="--build=${target_triplet} --host=${target_triplet}"
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
	"

	if test ${stage} -gt 1; then
		configure_options="
			${configure_options}

			--enable-thread-safe
		"
	fi

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

libmpfr_build() {
	_make_build
}

libmpfr_check() {
	if ${MAKE_CHECK}; then
		_make_check
	fi
}

libmpfr_stage() {
	_make_stage
}

libmpfr_pack() {
	_make_pack
}

libmpfr_install() {
	_make_install
}

libmpfr_main() {
	_make_main libmpfr ${LIBMPFR_SRCDIR}
}
