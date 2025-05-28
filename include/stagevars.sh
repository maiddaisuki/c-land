#!/bin/sh

##
# The stagevars() functions
#
# This function is to set following variables used during the build of
# a specific package:
#
# - srcdir
# - builddir
# - prefix
# - statedir
# - logdir
# - destdir
# - pkgdir
#

##
# $1: package name
# $2: srcdir
# $3: builddir
#
stagevars() {
	local buildroot=

	case $2 in
	/*)
		srcdir=$2
		;;
	*)
		srcdir=${SRCDIR}/$2
		;;
	esac

	if test ! -d "${srcdir}"; then
		die "$1: srcdir: ${srcdir}: directory does not exist"
	fi

	case ${stage} in
	1)
		buildroot=${stage1_buildroot}

		case $1 in
		linux | linux_headers | libc)
			prefix=${libc_prefix}
			;;
		binutils | gcc)
			prefix=${tools_prefix}
			;;
		*)
			prefix=${libs_prefix}
			;;
		esac

		;;
	2)
		buildroot=${stage2_buildroot}
		prefix=${PREFIX}
		;;
	3)
		buildroot=${stage3_buildroot}
		prefix=${PREFIX}
		;;
	*)
		die "stage: ${stage}: invalid value"
		;;
	esac

	test -d "${prefix}" || install -d "${prefix}" || exit

	builddir=${buildroot}/builddir/$3
	test -d "${builddir}" || install -d "${builddir}" || exit

	statedir=${buildroot}/state/$1
	test -d "${statedir}" || install -d "${statedir}" || exit

	logdir=${buildroot}/logs/$1
	test -d "${logdir}" || install -d "${logdir}" || exit

	pkgdir=${buildroot}/packages
	test -d "${pkgdir}" || install -d "${pkgdir}" || exit

	destdir=${buildroot}/destdir
	test -d "${destdir}" || install -d "${destdir}" || exit

	return 0
}
