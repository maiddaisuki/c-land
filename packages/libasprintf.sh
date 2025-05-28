#!/bin/sh

# BUILD_SYSTEM: autotools

##
# Build libasprintf (options as of gettext 0.24.1)
#
# --enable-cross-guesses={conservative|risky}
#
## Developer Options
#
# --enable-more-warnings
#

libasprintf_configure() {
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

	${srcdir}/gettext-runtime/libasprintf/configure \
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

libasprintf_build() {
	_make_build
}

libasprintf_check() {
	if ${MAKE_CHECK}; then
		_make_check
	fi
}

libasprintf_stage() {
	_make_stage
}

libasprintf_pack() {
	_make_pack
}

libasprintf_install() {
	_make_install
}

libasprintf_main() {
	_make_main libasprintf ${GETTEXT_SRCDIR} gettext/gettext-runtime/libasprintf
}
