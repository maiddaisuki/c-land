#!/bin/sh

# BUILD_SYSTEM: autotools (autoconf)

##
# Build indent (options as of version 2.2.13)
#
# --disable-nls
#
# --with-libiconv-prefix=DIR
# --with-libintl-prefix=DIR
#

indent_configure() {
	local log_file=${logdir}/configure.log

	local configure_options="
		--build=${target_triplet}
		--host=${target_triplet}

		--disable-dependency-tracking
		--disable-silent-rules

		--disable-rpath

		--prefix=${prefix}
		--libdir=${prefix}/${libdir}

		--enable-nls
	"

	if test -f ${builddir}/Makefile; then
		rm -f ${logdir}/*
		make distclean >/dev/null 2>&1
	fi

	# out-of-tree build does not work properly

	if test ! -f ${builddir}/configure; then
		cp -Rp ${srcdir}/* -t ${builddir}
		test $? -eq 0 || die "${package}: failed to copy source files to builddir"
	fi

	log "%s: configuring\n" ${package}

	./configure \
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

indent_build() {
	_make_build
}

indent_check() {
	if ${MAKE_CHECK}; then
		_make_check
	fi
}

indent_stage() {
	_make_stage
}

indent_pack() {
	_make_pack
}

indent_install() {
	_make_install
}

indent_main() {
	_make_main indent ${INDENT_SRCDIR}
}
