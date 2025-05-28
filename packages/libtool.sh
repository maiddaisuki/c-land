#!/bin/sh

# BUILD_SYSTEM: autotools (autoconf)

##
# Build libtool (options as of 2.5.4)
#
# --enable-cross-guesses={conservative|risky}
#
# --enable-ltdl-install
#

libtool_configure() {
	local log_file=${logdir}/configure.log

	local configure_options="
		--build=${target_triplet}
		--host=${target_triplet}

		--disable-dependency-tracking
		--disable-silent-rules

		${with_static_libs}
		${with_shared_libs}
		${with_pic}

		--prefix=${prefix}
		--libdir=${prefix}/${libdir}

		--enable-ltdl-install
	"

	if test -f ${builddir}/Makefile; then
		make distclean >/dev/null 2>&1
		rm -f ${logdir}/*
	fi

	log "%s: configuring\n" ${package}

	# FC=$(which gfortran) \
	# FCFLAGS='-O2' \

	${srcdir}/configure \
		M4=${PREFIX}/bin/m4 \
		CC="${cc}" \
		CPPFLAGS="${CPPFLAGS}" \
		CFLAGS="${CFLAGS}" \
		CXX="${cxx}" \
		CXXFLAGS="${CXXFLAGS}" \
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

libtool_build() {
	_make_build
}

libtool_check() {
	if ${MAKE_CHECK}; then
		_make_check
	fi
}

libtool_stage() {
	_make_stage
}

libtool_pack() {
	_make_pack
}

libtool_install() {
	_make_install
}

libtool_main() {
	_make_main libtool ${LIBTOOL_SRCDIR}
}
