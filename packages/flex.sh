#!/bin/sh

# BUILD_SYSTEM: autotools

##
# Build flex (options as of 2.6.4)
#
# --disable-nls
# --disable-libfl
# --disable-bootstrap
#
## Dependencies
#
# --with-libiconv-prefix=DIR
# --with-libintl-prefix=DIR
#

flex_configure() {
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

		--enable-nls
		--enable-libfl
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

flex_build() {
	_make_build
}

flex_check() {
	if ${MAKE_CHECK}; then
		_make_check
	fi
}

flex_stage() {
	_make_stage
}

flex_pack() {
	_make_pack
}

flex_install() {
	_make_install
}

flex_main() {
	_make_main flex ${FLEX_SRCDIR}
}
