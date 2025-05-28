#!/bin/sh

##
# Generic functions for packages using make-based build systems
#

# Build package by running `make ${MAKE_JOBS}`.
# Any arguments are passed to `make`.
#
_make_build() {
	local log_file=${logdir}/build.log
	log "%s: building\n" ${package}

	make ${MAKE_JOBS} "$@" >>${log_file} 2>&1
	test $? -eq 0 || die "${package}: build failed"

	touch ${build_stamp}
}

# Run testsuite.
#
# For automake-based packages this is `make check`.
# Some packages use `make test` instead.
#
# Any arguments are passed to `make`.
#
_make_check() {
	local log_file=${logdir}/check.log
	log "%s: running testsuite\n" ${package}

	if test $# -eq 0; then
		make -k check >>${log_file} 2>&1
	else
		make -k "$@" >>${log_file} 2>&1
	fi

	test $? -eq 0 || warning "${package}: testsuite failed"
	touch ${check_stamp}
}

# Perform staged installation.
#
# This is usually `make install DESTDIR=...`.
# We will use `install-strip` target by default.
#
# Run 'make install DESTDIR=${destdir}' to prepare built package for packing.
#
# If any arguments are passed to this function, they must also include name of
# the target to run.
#
# Some packages use variables other than DESTDIR for the same purpose,
# the variable `destdir_var` may be set to name of that variable.
#
_make_stage() {
	local log_file=${logdir}/install.log
	log "%s: staging for packaging\n" ${package}

	test -d ${destdir} && rm -rf ${destdir}

	if test $# -eq 0; then
		make install-strip ${destdir_var-DESTDIR}=${destdir} >>${log_file} 2>&1
	else
		make "$@" ${destdir_var-DESTDIR}=${destdir} >>${log_file} 2>&1
	fi

	if test $? -ne 0; then
		rm -rf ${destdir}
		die "${package}: staged installation failed"
	fi
}

# Create archive from files installed by `_make_stage`.
#
# One optional argument is name of command to run before creating the archive.
#
_make_pack() {
	local old_pwd=$(pwd)
	cd ${destdir}/${prefix} || exit

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
_make_install() {
	log "%s: extracting %s\n" ${package} ${package_tarx}

	tar -x -f ${pkgfile} -C ${prefix} || exit
	touch ${install_stamp}
}

# *main* function used to build a package
#
# $1: name of the package
# $2: source directory
# (optional) $3: last component for `builddir` variable
#
_make_main() {
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

	stagevars ${package} $2 ${3-${package}}

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
