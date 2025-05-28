#!/bin/sh

# BUILD_SYSTEM: autotools (autoconf + automake)

##
# Build dejagnu (options as of version 1.6.3)
#
# none
#

dejagnu_configure() {
	local log_file=${logdir}/configure.log

	local configure_options="
		--build=${target_triplet}
		--host=${target_triplet}

		--disable-silent-rules
		--disable-dependency-tracking

		--prefix=${prefix}
		--libdir=${prefix}/${libdir}
	"

	if test -f ${builddir}/Makefile; then
		rm -f ${logdir}/*
		make distclean >/dev/null 2>&1
	fi

	log "%s: configuring\n" ${package}

	${srcdir}/configure \
		${configure_options} \
		>>${log_file} 2>&1

	test $? -eq 0 || die "${package}: configuration failed"
}

dejagnu_build() {
	_make_build
}

dejagnu_check() {
	if ${MAKE_CHECK}; then
		_make_check
	fi
}

dejagnu_stage() {
	_make_stage
}

dejagnu_pack() {
	_make_pack
}

dejagnu_install() {
	_make_install
}

dejagnu_main() {
	_make_main dejagnu ${DEJAGNU_SRCDIR}
}
