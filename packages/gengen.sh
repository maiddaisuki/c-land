#!/bin/sh

# BUILD_SYSTEM: autotools

##
# Build gengen (options as of version 2.23)
#
# --enable-warnings
#

gengen_configure() {
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
	# Fix for out-of-tree builds
	test -d tests || cp -Rp ${srcdir}/tests -t ${builddir} || exit
}

gengen_build() {
	_make_build
}

gengen_check() {
	if ${MAKE_CHECK}; then
		_make_check
	fi
}

gengen_stage() {
	_make_stage
}

gengen_pack() {
	_make_pack
}

gengen_install() {
	_make_install
}

gengen_main() {
	_make_main gengen ${GENGEN_SRCDIR}
}
