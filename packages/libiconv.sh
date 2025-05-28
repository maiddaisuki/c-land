#!/bin/sh

# BUILD_SYSTEM: autotools

##
# Build libiconv (options as of version 1.18)
#
# --enable-cross-guesses={conservative|risky}
# --enable-year2038
#
# --enable-relocatable
#
# --disable-nls
# --enable-extra-encodings
#
# --with-libiconv-prefix
# --with-libintl-prefix
# --with-gnulib-prefix
#

libiconv_configure() {
	local log_file=${logdir}/configure.log

	local shared=
	local static=

	if ${WITH_LIBICONV} || ${need_libiconv}; then
		shared=${with_shared_libs}
		static=${with_static_libs}
	else # need_iconv
		shared=--disable-shared
		static=--enable-static
	fi

	local configure_options="
		--build=${target_triplet}
		--host=${target_triplet}

		--disable-dependency-tracking
		--disable-silent-rules

		${static}
		${shared}
		${with_pic}
		--disable-rpath

		--prefix=${prefix}
		--libdir=${prefix}/${libdir}

		--enable-nls
		--enable-extra-encodings
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

libiconv_build() {
	_make_build
}

libiconv_check() {
	if ${MAKE_CHECK}; then
		_make_check
	fi
}

libiconv_stage() {
	_make_stage
}

libiconv_pack_hook() {
	local dir

	if ${WITH_LIBICONV} || ${need_libiconv}; then
		:
	else
		for dir in include lib ${arch_libdir}; do
			test -d ${dir} && rm -rf ${dir}
		done
	fi
}

libiconv_pack() {
	_make_pack libiconv_pack_hook
}

libiconv_install() {
	_make_install
}

libiconv_main() {
	_make_main libiconv ${LIBICONV_SRCDIR}
}
