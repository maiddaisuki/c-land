#!/bin/sh

# BUILD_SYSTEM: autotools (autoconf + automake)

##
# Build automake (options as of version 1.17)
#
## Variables
#
# AM_TEST_RUNNER_SHELL
#

automake_configure() {
	local log_file=${logdir}/configure.log

	local cc=$({ clang=$(which clang) && printf %s "${clang} -fgnuc-version=0"; } || which cc || which gcc)
	local cxx=$({ clang=$(which clang++) && printf %s "${clang} -fgnuc-version=0"; } || which c++ || which g++)

	local configure_options="
		--build=${target_triplet}
		--host=${target_triplet}

		--disable-silent-rules

		--prefix=${prefix}
		--libdir=${prefix}/${libdir}
	"

	if test -f ${builddir}/Makefile; then
		make distclean >/dev/null 2>&1
		rm -f ${logdir}/*
	fi

	log "%s: configuring\n" ${package}

	#	F77=
	#	GNU_F77=
	#	FC=$(which flang || which f95 || which gfortran)
	#	GNU_FC=$(which gfortran)
	#	FCFLAGS=-O2
	#	GNU_GCJ=

	${srcdir}/configure \
		${configure_options} \
		CC="${cc}" \
		CFLAGS=-O2 \
		GNU_CC=${PREFIX}/bin/gcc \
		CXX="${cxx}" \
		CXXFLAGS=-O2 \
		GNU_CXX=${PREFIX}/bin/g++ \
		>>${log_file} 2>&1

	test $? -eq 0 || die "${package}: configuration failed"
}

automake_build() {
	_make_build
}

automake_check() {
	if ${MAKE_CHECK}; then
		_make_check
	fi
}

automake_stage() {
	_make_stage
}

automake_pack() {
	_make_pack
}

automake_install() {
	_make_install
}

automake_main() {
	_make_main automake ${AUTOMAKE_SRCDIR}
}
