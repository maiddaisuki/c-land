#!/bin/sh

# BUILD_SYSTEM: autotools

# Build libb2 (options as of version 0.98.1)
#
# --disable-openmp
#
# --enable-native
# --enable-fat
#
# --with-pkgconfigdir=DIRNAME [default=$libdir/pkgconfig]
#

libb2_configure() {
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

		--disable-native
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

libb2_build() {
	_make_build
}

libb2_check() {
	if ${MAKE_CHECK}; then
		_make_check
	fi
}

libb2_stage() {
	_make_stage
}

libb2_pack() {
	_make_pack
}

libb2_install() {
	_make_install
}

libb2_main() {
	_make_main libb2 ${LIBB2_SRCDIR}
}
