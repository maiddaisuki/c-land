#!/bin/sh

# BUILD_SYSTEM: autotools (autoconf)

##
# Build expect (options as of version 5.45.4)
#
# --enable-64bit
# --enable-threads
#
# --with-tcl=DIR
# --with-tclinclude=DIR
#
# --with-tk=DIR
# --with-tkinclude=DIR
#
# [windows]
#
# --enable-wince
# --with-celib=DIR
#
# [sparc]
#
# --enable-64bit-vis
#
## Developer Options
#
# --enable-symbols
#

expect_configure() {
	local log_file=${logdir}/configure.log

	# *sigh*
	local cflags="${cflags} -Wno-error=implicit-int -Wno-error=implicit-function-declaration -Wno-error=incompatible-pointer-types"

	local configure_options="
		--build=${target_triplet}
		--host=${target_triplet}

		${with_shared_libs}
		--disable-rpath

		--prefix=${prefix}
		--libdir=${prefix}/${libdir}

		--enable-64bit
		--enable-threads
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

expect_build() {
	_make_build
}

expect_check() {
	if ${MAKE_CHECK}; then
		_make_check test
	fi
}

expect_stage() {
	_make_stage install
}

expect_pack() {
	_make_pack
}

expect_install() {
	_make_install
}

expect_main() {
	_make_main expect ${EXPECT_SRCDIR}
}
