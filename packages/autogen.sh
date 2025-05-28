#!/bin/sh

# BUILD_SYSTEM: autotools

##
# Build autogen (options as of version 5.18.16)
#
# --with-packager
# --with-packager-version
# --with-packager-bug-reports
#
# --enable-snprintfv-install
#
# --disable-nls
# --enable-static-autogen
#
# --disable-shell
# --enable-timeout
# --disable-optional-args
#
# --with-dmalloc
#
## Dependencies
#
# --with-libxml2
# --with-libxml2-cflags
# --with-libxml2-libs
#
# --with-regex-header
# --with-libregex
# --with-libregex-cflags
# --with-libregex-libs
#
## Developer Options
#
# --enable-debug
#

autogen_configure() {
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

autogen_build() {
	_make_build
}

autogen_check() {
	if ${MAKE_CHECK}; then
		_make_check
	fi
}

autogen_stage() {
	_make_stage
}

autogen_pack() {
	_make_pack
}

autogen_install() {
	_make_install
}

autogen_main() {
	_make_main autogen ${AUTOGEN_SRCDIR}
}
