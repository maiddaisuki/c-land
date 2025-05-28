#!/bin/sh

# BUILD_SYSTEM: autotools

##
# Build libisl (options are as of version 0.27)
#
# --enable-portable-binary
#
# --with-gcc-arch=ARCH
#
## Dependencies
#
# --wit-int=gmp|imath|imath-32
#
# --with-gmp=system|build
# --with-gmp-prefix=DIR
# --with-gmp-exec-prefix=DIR
# --with-gmp-builddir=DIR
#
# --with-clang=system|no
# --with-clang-prefix=DIR
# --with-clang-exec-prefix=DIR
#
# --with-python-sys-prefix
# --with-python-prefix
# --wtth-python-exec_prefix
#

libisl_configure() {
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

		--with-gmp-prefix=${prefix}
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

libisl_build() {
	_make_build
}

libisl_check() {
	if ${MAKE_CHECK}; then
		_make_check
	fi
}

libisl_stage() {
	_make_stage
}

libisl_pack() {
	_make_pack
}

libisl_install() {
	_make_install
}

libisl_main() {
	_make_main libisl ${LIBISL_SRCDIR}
}
