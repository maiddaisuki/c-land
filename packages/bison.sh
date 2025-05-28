#!/bin/sh

# BUILD_SYSTEM: autotools

##
# Build bison (options as of version 3.8.2)
#
# --enable-cross-guesses=conservative|risky
# --enable-relocatable
#
# --disable-largefile
# --disable-year2038
#
# --enable-threads=posix|isoc|isoc+posix|windows
#
# --disable-nls
# --disable-yacc
#
## Dependencies
#
# --with-libiconv-prefix=DIR
# --with-libintl-prefix=DIR
# --with-libreadline-prefix=DIR
# --with-libtextstyle-prefix=DIR
#
## Developer options
#
# --enable-gcc-warnings
# --disable-assert
#

bison_configure() {
	local log_file=${logdir}/configure.log

	local configure_options="
		--build=${target_triplet}
		--host=${target_triplet}

		--disable-dependency-tracking
		--disable-silent-rules

		${with_static_libs}
		${with_shared_libs}
		--disable-rpath

		--prefix=${prefix}
		--libdir=${prefix}/${libdir}

		--enable-nls
		--enable-threads=posix
		--enable-yacc
	"

	if test -f ${builddir}/Makefile; then
		make distclean >/dev/null 2>&1
		rm -f ${logdir}/*
	fi

	log "%s: configuring\n" ${package}

	${srcdir}/configure \
		M4=${PREFIX}/bin/m4 \
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
	test -d examples || cp -Rp ${srcdir}/examples -t ${builddir}
}

bison_build() {
	_make_build
}

bison_check() {
	if ${MAKE_CHECK}; then
		_make_check
	fi
}

bison_stage() {
	_make_stage
}

bison_pack() {
	_make_pack
}

bison_install() {
	_make_install
}

bison_main() {
	_make_main bison ${BISON_SRCDIR}
}
