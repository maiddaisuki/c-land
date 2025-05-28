#!/bin/sh

# BUILD_SYSTEM: autotools (autoconf)

##
# Build help2man (options as of version 1.49.3)
#
# --enable-nls
#

help2man_configure() {
	local log_file=${logdir}/configure.log

	#	--enable-nls

	local configure_options="
		--build=${target_triplet}
		--host=${target_triplet}

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

help2man_build() {
	_make_build
}

help2man_check() {
	if ${MAKE_CHECK}; then
		: _make_check
	fi
}

help2man_stage() {
	_make_stage install
}

help2man_pack() {
	_make_pack
}

help2man_install() {
	_make_install
}

help2man_main() {
	_make_main help2man ${HELP2MAN_SRCDIR}
}
