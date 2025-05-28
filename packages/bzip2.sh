#!/bin/sh

# BUILD_SYSTEM: make

##
# Build bzip2
#

bzip2_configure() {
	log "%s: configuring\n" ${package}

	if test ! -f ${builddir}/Makefile; then
		cp ${srcdir}/* -t ${builddir}
		test $? -eq 0 || die "${package}: failed to copy source files to builddir"
	fi

	rm -f ${logdir}/*

	make -f Makefile clean >/dev/null 2>&1
	make -f Makefile-libbz2_so clean >/dev/null 2>&1
}

bzip2_build() {
	local log_file=${logdir}/build.log
	rm -f ${log_file}

	log "%s: building\n" ${package}

	# build bzlp2 and libbz2.a

	make -f Makefile ${MAKE_JOBS} \
		CC="${cc}" \
		CFLAGS="${cppflags} -fPIC ${cflags} ${ldflags}" \
		>>${log_file} 2>&1

	test $? -eq 0 || die "${package}: building bzip2 has failed"

	# build shared libbz2.so

	if test -n "${dynamic_linker}"; then
		# clean object files
		make -f Makefile-libbz2_so clean >/dev/null 2>&1

		make -f Makefile-libbz2_so ${MAKE_JOBS} \
			CC="${cc}" \
			CFLAGS="${cppflags} -fPIC ${cflags} ${ldflags}" \
			>>${log_file} 2>&1

		test $? -eq 0 || die "${package}: building libbz2.so has failed"
	fi

	touch ${build_stamp}
}

bzip2_check() {
	if ${MAKE_CHECK}; then
		_make_check
	fi
}

bzip2_stage() {
	local log_file=${logdir}/install.log
	log "%s: staging for packaging\n" ${package}

	local destdir=${destdir}${prefix}
	rm -rf ${destdir}

	make -f Makefile install PREFIX=${destdir} >>${log_file} 2>&1

	if test $? -ne 0; then
		rm -rf ${destdir}
		die "${package}: staged installation failed"
	fi

	# install bzlib.h
	test -d ${destdir}/include || install -d ${destdir}/include || exit
	cp -pR bzlib.h -t ${destdir}/include

	# make sure ${libdir} exists
	test -d ${destdir}/${libdir} || install -d ${destdir}/${libdir} || exit

	# install shared library
	if test -n "${dynamic_linker}"; then
		cp -pR libbz2.so* -t ${destdir}/${libdir}
	fi

	local old_pwd=$(pwd)
	cd ${destdir} || exit

	# move man pages to share/man
	if test -d man; then
		test -d share || install -d share || exit
		mv man -t share || exit
	fi

	# make sure libbz2.a in ${libdir}
	if test ${libdir} != lib && test -f lib/libbz2.a; then
		mv lib/libbz2.a ${libdir}/libbz2.a || exit
	fi

	# fix symbolic links in bin by stripping PREFIX from their targets

	local file=
	local link=

	for link in $(dir bin); do
		if test -h bin/${link}; then
			file=$(readlink bin/$link | sed "s|${destdir}|${prefix}|")
			(cd bin && rm ${link} && ln -s ${file} ${link}) || exit
		fi
	done

	# make sure libbz2.so exists and is a symbolic link
	for file in $(dir ${libdir}); do
		case ${file} in
		libbz2.so*)
			if test ! -h ${libdir}/${file}; then
				(cd ${libdir} && ln -s ${file} libbz2.so) || exit
				break
			fi
			;;
		esac
	done

	cd ${old_pwd} || exit
}

bzip2_pack() {
	_make_pack
}

bzip2_install() {
	_make_install
}

bzip2_main() {
	_make_main bzip2 ${BZIP2_SRCDIR}
}
