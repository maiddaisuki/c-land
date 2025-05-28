#!/bin/sh

build_triplet=$(${config_guess}) || exit
target_triplet=

test -n "${target}" || target=${build_triplet}

# Name of target C Library
libc=
# Filename of the dynamic linker
dynamic_linker=
# Filename of `ld.so.conf` or equivalent, relative to prefix
ldconf=
# Filename of `ldconfig` or equivalent, relative to prefix
ldconfig=

# true if libc does not provide iconv(1)
need_iconv=false
# true if libc does not provide iconv(3)
need_libiconv=false
# true if libc does not provide crypt.h and crypt(3)
need_libxcrypt=false
# true if tzdata needs to be installed
need_tzdata=false

# name of arch-specific library directory
arch_libdir=
# name of library directory
libdir=

# Figure out C Library

case ${target} in
*-linux-gnu | *-linux)
	libc=glibc
	target_triplet=${target}
	;;
*-linux-musl)
	libc=musl
	target_triplet=${target}
	;;
*-linux-newlib)
	libc=newlib
	target_triplet=${target}
	;;
*-linux-uclibc*)
	libc=uclibc
	target_triplet=${target}
	;;
*-linux-diet)
	libc=diet
	target_triplet=$(printf '%s' "${target}" | sed 's|diet$|gnu|')
	;;
*)
	die "${target}: target is not recognized or supported"
	;;
esac

target_triplet=$(${config_sub} ${target_triplet}) || exit

# Figure out dynamic linker

is_64bit=false
is_x32bit=false # FIXME?: currently always false

case ${libc} in
diet)
	error "dietlibc is not supported yet"
	;;
glibc)
	ldconf=etc/ld.so.conf
	ldconfig=sbin/ldconfig

	# glibc provides iconv(3)
	need_libiconv=false

	# glibc installs iconv(1) utility
	need_iconv=false

	# glibc no longer provides crypt.h and crypt(3)
	need_libxcrypt=true

	# glibc uses tzdata in prefix, unless TZDIR is set
	need_tzdata=true

	case ${target_triplet} in
	x86_64-*)
		is_64bit=true
		dynamic_linker=ld-linux-x86-64.so.2
		;;
	i?86-*)
		dynamic_linker=ld-linux.so.2
		;;
	*)
		error "glibc: ${target_triplet}: do not know filename of the dynamic linker"
		;;
	esac
	;;
musl)
	# musl provides iconv(3)
	need_libiconv=false

	# install iconv(1) from GNU libiconv
	need_iconv=true

	# musl provides crypt.h and crypt(3)
	need_libxcrypt=false

	# musl uses tzdata in /usr/share or /etc, unless TZDIR is set
	need_tzdata=false

	case ${target_triplet} in
	x86_64-*)
		is_64bit=true
		dynamic_linker=ld-musl-x86_64.so.1
		;;
	i?86-*)
		dynamic_linker=ld-musl-i386.so.1
		;;
	*)
		error "musl: ${target_triplet}: do not know filename of the dynamic linker"
		;;
	esac

	ldconf=etc/$(printf %s ${dynamic_linker} | sed 's|so.1$|path|')
	;;
newlib)
	error "newlib is not supported yet"

	case ${target_triplet} in
	x86_64-*)
		is_64bit=true
		dynamic_linker=
		;;
	i?86-*)
		dynamic_linker=
		;;
	*)
		error "newlib: ${target_triplet}: do not know filename of the dynamic linker"
		;;
	esac
	;;
uclibc)
	_uclibc_srcdir=

	case ${UCLIBC_SRCDIR} in
	/*)
		_uclibc_srcdir=${UCLIBC_SRCDIR}
		;;
	*)
		_uclibc_srcdir=${SRCDIR}/${UCLIBC_SRCDIR}
		;;
	esac

	if test ! -d ${_uclibc_srcdir}; then
		die "uclibc: UCLIBC_SRCDIR: ${_uclibc_srcdir}: directory does not exist"
	fi

	_uclibc_config=${_uclibc_srcdir}/.config

	if test ! -f ${_uclibc_config}; then
		die "uclibc: ${_uclibc_config}: file does not exist"
	fi

	if grep '^HAVE_SHARED=y' ${_uclibc_config} >/dev/null 2>&1; then
		ldconfig=sbin/ldconfig

		_ldso_name=$(grep '^TARGET_LDSO_NAME=' ${_uclibc_config} | sed -E 's|^.*="*([^"]+)"*$|\1|')
		_ldso_base=$(grep '^LDSO_BASE_FILENAME=' ${_uclibc_config} | sed -E 's|^.*="*([^"]+)"*$|\1|')

		if test -z "${_ldso_name}"; then
			die "uclibc: failed to extract TARGET_LDSO_NAME"
		fi

		if test -z "${_ldso_base}"; then
			die "uclibc: failed to extract LDSO_BASE_FILENAME"
		fi

		dynamic_linker=${_ldso_name}.so.1
		ldconf=etc/${_ldso_base}.conf

		unset _ldso_name _ldso_base
	fi

	if grep '^UCLIBC_HAS_LIBICONV=y' ${_uclibc_config} >/dev/null 2>&1; then
		need_iconv=false
		need_libiconv=false
	else
		need_iconv=true
		need_libiconv=true
	fi

	if grep '^UCLIBC_HAS_CRYPT_IMPL=y' ${_uclibc_config} >/dev/null 2>&1; then
		need_libxcrypt=false
	else
		need_libxcrypt=true
	fi

	# uclibc-ng uses /etc/TZ with fallback to /etc/localtime
	need_tzdata=false

	case ${target_triplet} in
	x86_64-*)
		is_64bit=true
		;;
	i?86-*) ;;
	*)
		error "uclibc: ${target_triplet}: do not know filename of the dynamic linker"
		;;
	esac
	;;
esac

# Set libdir

if ${is_64bit}; then
	arch_libdir=lib64
elif ${is_x32bit}; then
	arch_libdir=libx32
else
	arch_libdir=lib32
fi

if ${with_arch_libdir}; then
	libdir=${arch_libdir}
else
	libdir=lib
fi
