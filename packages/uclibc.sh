#!/bin/sh

# BUILD_SYSTEM: make

##
# Build uclibc (options as of version 1.0.52)
#
## Host tools
#
# HOSTCC
#
# BUILD_CFLAGS
# BUILD_LDFLAGS
#
## Target tools
#
# CC
# AR
#
# UCLIBC_EXTRA_CPPFLAGS
# UCLIBC_EXTRA_CFLAGS
#

uclibc_configure() {
	local log_file=${logdir}/configure.log

	cp -Rp ${srcdir}/* -t ${builddir}
	test $? -eq 0 || die "${package}: failed to copy source files to builddir"

	rm -f ${logdir}/*
	make distclean >/dev/null 2>&1

	log "%s: configuring\n" ${package}

	cp ${srcdir}/.config -t ${builddir} &&
		sed -E -i "s|^(KERNEL_HEADERS=)(.*)|\1\"${prefix}/include\"|" .config &&
		sed -E -i "s|^(RUNTIME_PREFIX=)(.*)|\1\"${prefix}\"|" .config &&
		sed -E -i "s|^(DEVEL_PREFIX=)(.*)|\1\"${prefix}\"|" .config &&
		sed -E -i "s|^(MULTILIB_DIR=)(.*)|\1\"${libdir}\"|" .config &&
		make oldconfig V=1 HOSTCC="${host_cc}" >${log_file} 2>&1 </dev/null

	test $? -eq 0 || die "${package}: configuration failed"
}

uclibc_build() {
	_make_build V=1 \
		HOSTCC="${host_cc}" \
		CC="${cc}" \
		UCLIBC_EXTRA_CPPFLAGS="${CPPFLAGS}" \
		UCLIBC_EXTRA_CFLAGS="${CFLAGS}" \
		AS="${as}" \
		LD="${LD}" \
		LDFLAGS="${LDFLAGS}" \
		AR="${AR}" \
		RANLIB="${RANLIB}" \
		NM="${NM}" \
		OBJDUMP="${OBJDUMP}" \
		OBJCOPY="${OBJCOPY}" \
		STRIP="${STRIP}"
	#	ASFLAGS="${ASFLAGS}" \
}

uclibc_check() {
	if test ${stage} -gt 1 && ${MAKE_CHECK_LIBC}; then
		: _make_check
	fi
}

uclibc_stage() {
	local destdir_var=PREFIX
	_make_stage install install_utils V=1 \
		HOSTCC="${host_cc}" \
		CC="${cc}" \
		UCLIBC_EXTRA_CPPFLAGS="${CPPFLAGS}" \
		UCLIBC_EXTRA_CFLAGS="${CFLAGS}" \
		AS="${as}" \
		LD="${LD}" \
		LDFLAGS="${LDFLAGS}" \
		AR="${AR}" \
		RANLIB="${RANLIB}" \
		NM="${NM}" \
		OBJDUMP="${OBJDUMP}" \
		OBJCOPY="${OBJCOPY}" \
		STRIP="${STRIP}"
	#	ASFLAGS="${ASFLAGS}" \
}

uclibc_pack_hook() {
	test -d etc || install -d etc || exit
	test -d lib || install -d lib || exit
	test -d ${arch_libdir} || install -d ${arch_libdir} || exit

	if test ! -f include/ucontext.h && test -f include/sys/ucontext.h; then
		cat <<-EOF >>include/ucontext.h
			#include <sys/ucontext.h>
		EOF
	fi

	# ${libdir}/libc.so is a linker script
	if test -f ${libdir}/libc.so; then
		sed -i "s|${prefix}||g" ${libdir}/libc.so || exit
	fi

	# remove fake libiconv.a
	local dir

	for dir in ${arch_libdir} lib; do
		if test -f ${dir}/libiconv.a; then
			rm -f ${dir}/libiconv.a ${dir}/libiconv_pic.a
		fi
	done
}

uclibc_pack() {
	_make_pack uclibc_pack_hook
}

uclibc_install() {
	_make_install
}

uclibc_main() {
	local host_cc=

	if test ${stage} = 3; then
		host_cc=${PREFIX}/bin/gcc
	elif test -x /usr/bin/gcc; then
		host_cc=/usr/bin/gcc
	elif test -x /usr/bin/clang; then
		host_cc=/usr/bin/clang
	else
		host_cc=/usr/bin/cc
	fi

	_make_main libc ${UCLIBC_SRCDIR}
}
