#!/bin/sh

# BUILD_SYSTEM: autotools

##
# Build libunistring (options as of version 1.3)
#
# --enable-cross-guesses=conservative|risky
#
# --enable-threads=isoc|posix|isoc+posix|windows
# --enable-year2038
#
# --enable-relocatable
#
# --disable-namespacing
#
# --with-libiconv-prefix[=DIR]
# --without-libiconv-prefix
#

libunistring_configure() {
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

		--enable-threads=posix
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

libunistring_build() {
	_make_build
}

libunistring_check() {
	if ${MAKE_CHECK}; then
		_make_check
	fi
}

libunistring_stage() {
	_make_stage
}

libunistring_pack() {
	_make_pack
}

libunistring_install() {
	_make_install
}

libunistring_main() {
	_make_main libunistring ${LIBUNISTRING_SRCDIR}
}
