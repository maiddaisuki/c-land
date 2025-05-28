#!/bin/sh

# BUILD_SYSTEM: autotools

##
# Build gengetopt (options as of version 2.23)
#
# --with-gengen=NAME
# --with-gengetopt=NAME
#
# --enable-warnings
#

gengetopt_configure() {
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
		rm -f ${logdir}/*
		make distclean >/dev/null 2>&1
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

gengetopt_build() {
	_make_build
}

gengetopt_check() {
	if ${MAKE_CHECK}; then
		_make_check
	fi
}

gengetopt_stage() {
	_make_stage
}

gengetopt_pack() {
	_make_pack
}

gengetopt_install() {
	_make_install
}

gengetopt_main() {
	_make_main gengetopt ${GENGETOPT_SRCDIR}
}
