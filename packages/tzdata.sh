#/bin/sh

# BUILD_SYSTEM: make

##
# Build tzdata (last tested version is 2025b)
#

tzdata_configure() {
	cp -R ${srcdir}/* -t ${builddir}
	test $? -eq 0 || die "${package}: failed to copy source files to builddir"

	make clean >/dev/null 2>&1
	rm -f ${logdir}/*
}

tzdata_build() {
	_make_build \
		sharp=\# \
		CC="${cc}" \
		CFLAGS="${cppflags} ${cflags}" \
		LDFLAGS="${ldflags}"
}

tzdata_check() {
	if ${MAKE_CHECK}; then
		_make_check
	fi
}

tzdata_stage() {
	_make_stage install \
		TOPDIR=${prefix} \
		BINDIR=${prefix}/bin \
		ZICDIR=${prefix}/sbin \
		LIBDIR=${prefix}/${libdir} \
		USRDIR= \
		USRSHAREDIR=share
}

tzdata_pack() {
	_make_pack
}

tzdata_install() {
	_make_install
}

tzdata_main() {
	_make_main tzdata ${TZDATA_SRCDIR}
}
