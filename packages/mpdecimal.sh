#!/bin/sh

# BUILD_SYSTEM: autotools (autoconf + automake)

##
# Build mpdecimal (options as of version 4.0.1)
#
# --enable-cxx
# --enable-pc
# --enable-doc
#

mpdecimal_configure() {
	local log_file=${logdir}/configure.log

	if ${ENABLE_PIC}; then
		local cflags="${cflags} -fPIC"
		local cxxflags="${cxxflags} -fPIC"
	fi

	local configure_options="
		--build=${target_triplet}
		--host=${target_triplet}

		${with_static_libs}
		${with_shared_libs}

		--prefix=${prefix}
		--libdir=${prefix}/${libdir}

		--enable-cxx
		--enable-doc
		--enable-pc
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
		LD="${CC}" \
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

mpdecimal_build() {
	_make_build
}

mpdecimal_check() {
	if ${MAKE_CHECK}; then
		_make_check
	fi
}

mpdecimal_stage() {
	_make_stage install
}

mpdecimal_pack() {
	_make_pack
}

mpdecimal_install() {
	_make_install
}

mpdecimal_main() {
	_make_main mpdecimal ${MPDECIMAL_SRCDIR}
}
