#!/bin/sh

# BUILD_SYSTEM: autotools (autoconf)

##
# Build gpm (options as of version 1.20.7)
#
# --without-curses
#

gpm_configure() {
	local log_file=${logdir}/configure.log

	if ${ENABLE_PIC}; then
		local cflags="${cflags} -fPIC"
		local cxxflags="${cxxflags} -fPIC"
	fi

	local configure_options="
		--build=${target_triplet}
		--host=${target_triplet}

		--disable-dependency-tracking
		--disable-silent-rules

		${with_static_libs}
		${with_shared_libs}
		--disable-rpath

		--prefix=${prefix}
		--libdir=${prefix}/${libdir}

		--without-curses
	"

	# Out-of-tree builds do not work properly, so copy the source tree
	if test -f ${builddir}/configure; then
		find -type f -exec rm -f \{\} +
		rm -f ${logdir}/*
	fi

	if test ! -f ${builddir}/configure; then
		cp -R ${srcdir}/* -t ${builddir}
		test $? -eq 0 || die "${package}: failed to copy source files for building"
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

gpm_build() {
	_make_build
}

gpm_check() {
	if ${MAKE_CHECK}; then
		: _make_check
	fi
}

gpm_stage() {
	local destdir_var=ROOT
	_make_stage
}

gpm_pack_hook() {
	local file

	if test ! -f lib/libgpm.so; then
		for file in $(dir lib); do
			case ${file} in
			libgpm.so*)
				if test ! -h lib/${file}; then
					(cd lib && ln -s ${file} libgpm.so) || exit
				fi
				;;
			esac
		done
	fi
}

gpm_pack() {
	_make_pack gpm_pack_hook
}

gpm_install() {
	_make_install
}

gpm_main() {
	_make_main gpm ${GPM_SRCDIR}
}
