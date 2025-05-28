#!/bin/sh

# BUILD_SYSTEM: autotools

##
# Build GNU make (options as of version 4.4.1)
#
# --enable-cross-guesses={conservative|risky}
#
# --enable-year2038
# --disable-largefile
#
# --enable-nls
#
# --disable-job-server
# --disable-load
# --disable-posix-spawn
#
# --enable-case-insensitive-file-system
#
# --with-customs=DIR
# --with-dmalloc
#
## Dependencies
#
# --with-libiconv-prefix[=DIR]
# --with-libintl-prefix[=DIR]
#
# --with-guile
#

make_configure() {
	local log_file=${logdir}/configure.log

	local with_guile=--without-guile

	if ${WITH_GUILE2} || ${WITH_GUILE3}; then
		with_guile=--with-guile
	fi

	local configure_options="
		--build=${target_triplet}
		--host=${target_triplet}

		--disable-dependency-tracking
		--disable-silent-rules

		--prefix=${prefix}
		--libdir=${prefix}/${libdir}

		--enable-nls

		${with_guile}
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

make_build() {
	_make_build
}

make_check() {
	if ${MAKE_CHECK}; then
		_make_check
	fi
}

make_stage() {
	_make_stage
}

make_pack() {
	_make_pack
}

make_install() {
	_make_install
}

make_main() {
	_make_main make ${MAKE_SRCDIR}
}
