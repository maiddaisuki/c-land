#!/bin/sh

# BUILD_SYSTEM: autotools (autoconf + automake)

##
# Build gperf (options as of version 3.3)
#
# --enable-cross-guesses={conservative|risky}
#
# --disable-largefile
# --enable-year2038
#
# --with-gnulib-prefix=DIR
#

gperf_configure() {
	local log_file=${logdir}/configure.log

	local configure_options="
		--build=${target_triplet}
		--host=${target_triplet}

		--disable-dependency-tracking
		--disable-silent-rules

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

gperf_build() {
	_make_build
}

gperf_check() {
	if ${MAKE_CHECK}; then
		_make_check
	fi
}

gperf_stage() {
	_make_stage install
}

gperf_pack() {
	_make_pack
}

gperf_install() {
	_make_install
}

gperf_main() {
	_make_main gperf ${GPERF_SRCDIR}
}
