#!/bin/sh

##
# Generic functions for packages using meson build systems
#

meson_args() {
	local arg args
	for arg in "$@"; do
		if test -z "${args}"; then
			args="'${arg}'"
		else
			args="${args}, '${arg}'"
		fi
	done
	printf "[%s]" "${args}"
}

# Build package by running `meson build`.
#
_meson_build() {
	local log_file=${logdir}/build.log
	log "%s: building\n" ${package}

	meson build --verbose ${MESON_JOBS} >>${log_file} 2>&1
	test $? -eq 0 || die "${package}: build failed"

	touch ${build_stamp}
}

# Run testsuite by running 'meson test'
#
_meson_check() {
	local log_file=${logdir}/check.log
	log "%s: running testsuite\n" ${package}

	meson test --verbose >>${log_file} 2>&1

	test $? -eq 0 || warning "${package}: testsuite failed"
	touch ${check_stamp}
}

# Run `meson install` to prepare built package for packing
#
_meson_stage() {
	local log_file=${logdir}/install.log
	log "%s: staging for packaging\n" ${package}

	test -d ${destdir} && rm -rf ${destdir}
	meson install --destdir ${destdir} >>${log_file} 2>&1

	if test $? -ne 0; then
		rm -rf ${destdir}
		die "${package}: staged installation failed"
	fi
}

# Create archive from files installed by `_meson_stage`.
#
# One optional argument is name of command to run before creating the archive.
#
_meson_pack() {
	local old_pwd=$(pwd)
	cd ${destdir} || exit

	test ${1+y} && $1

	log "%s: creating %s\n" ${package} ${package_tarx}

	tar -c -f ${package_tar} $(dir) &&
		xz -9 ${package_tar} &&
		mv ${package_tarx} -t ${pkgdir}

	test $? -eq 0 || exit
	cd ${old_pwd} || exit

	rm -rf ${destdir}
}

# Extract ${pkgfile} to ${prefix}
#
_meson_install() {
	_make_install
}

# *main* function used to build a package
#
# $1: name of the package
# $2: source directory (value of {PACKAGE}_SRCDIR)
#
_meson_main() {
	local package=$1
	local package_tar=${package}.tar
	local package_tarx=${package_tar}.xz

	local srcdir=
	local builddir=
	local prefix=
	local statedir=
	local logdir=
	local destdir=
	local pkgdir=

	stagevars ${package} $2 ${package}

	local pkgfile=${pkgdir}/${package_tarx}

	local build_stamp=${statedir}/build-stamp
	local check_stamp=${statedir}/test-stamp
	local install_stamp=${statedir}/install-stamp

	local old_pwd=${pwd}
	cd ${builddir} || exit

	if test ! -f ${build_stamp}; then
		${package}_configure
		${package}_build
	fi

	if test ! -f ${check_stamp} || test ${build_stamp} -nt ${check_stamp}; then
		${package}_check
	fi

	if test ! -f ${pkgfile} || test ${build_stamp} -nt ${pkgfile}; then
		${package}_stage
		${package}_pack
	fi

	if test ! -f ${install_stamp} || test ${pkgfile} -nt ${install_stamp}; then
		${package}_install
	fi

	cd ${old_pwd} || exit
}
