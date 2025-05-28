#!/bin/sh

# BUILD_SYSTEM: autotools

##
# Build libmpc (options are as of version 1.3.1)
#
# --enable-logging
#
## Dependencies
#
# --with-gmp=DIR
# --with-gmp-include=DIR
# --with-gmp-lib=DIR
#
# --with-mpfr=DIR
# --with-mpfr-include=DIR
# --with-mpfr-lib=DIR
#
## Developer Options
#
# --enable-valgrid-tests
#

libmpc_configure() {
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

libmpc_build() {
	_make_build
}

libmpc_check() {
	if ${MAKE_CHECK}; then
		_make_check
	fi
}

libmpc_stage() {
	_make_stage
}

libmpc_pack() {
	_make_pack
}

libmpc_install() {
	_make_install
}

libmpc_main() {
	_make_main libmpc ${LIBMPC_SRCDIR}
}
