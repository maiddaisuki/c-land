#!/bin/sh

# BUILD_SYSTEM: autotools

##
# Build libsigsegv (options as of version 2.14)
#
# --disable-stackvma
#

libsigsegv_configure() {
	local log_file=${logdir}/configure.log

	local configure_options="
		--build=${target_triplet}
		--host=${target_triplet}

		--disable-dependency-tracking
		--disable-silent-rules

		${with_static_libs}
		${with_shared_libs}
		${with_pic}
		--disable-rpath

		--prefix=${prefix}
		--libdir=${prefix}/${libdir}
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

libsigsegv_build() {
	_make_build
}

libsigsegv_check() {
	if ${MAKE_CHECK}; then
		_make_check
	fi
}

libsigsegv_stage() {
	_make_stage
}

libsigsegv_pack() {
	_make_pack
}

libsigsegv_install() {
	_make_install
}

libsigsegv_main() {
	_make_main libsigsegv ${LIBSIGSEGV_SRCDIR}
}
