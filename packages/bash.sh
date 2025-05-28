#!/bin/sh

# BUILD_SYSTEM: autotools (autoconf)

##
# Build bash (options as of version 5.2)
#
# --enable-static-link
#
# --disable-largefile
#
# --disable-nls
# --enable-threads=posix|solaris|pth|windows
#
## Features
#
# --enable-readline
#
# --enable-minimal-config
#
# --enable-strict-posix-default
# --enable-usg-echo-default | --enable-xpg-echo-default
#
# --enable-alt-array-implementation
# --enable-direxpand-default
# --enable-disabled-builtins
#
# --with-bash-malloc | --with-gnu-malloc
# --enable-mem-scramble
#
## Dependencies
#
# --with-afs
#
# --with-curses
# --with-installed-readline
#
# --with-libiconv-prefix[=DIR]
# --without-libiconv-prefix
#
# --with-included-gettext
# --with-libintl-prefix[=DIR]
# --without-libintl-prefix
#
# --with-libpth-prefix[=DIR]
# --without-libpth-prefix
#
## Developer Options
#
# --enable-debugger
# --enable-profiling
#

## Features which are usually enabled by default, if supported
#
# --enable-alias
# --enable-arith-for-command
# --enable-array-variables
# --enable-bang-history
# --enable-brace-expansion
# --enable-casemod-attributes
# --enable-casemod-expansions
# --enable-command-timing
# --enable-cond-command
# --enable-cond-regexp
# --enable-coprocesses
# --enable-dev-fd-stat-broken
# --enable-directory-stack
# --enable-dparen-arithmetic
# --enable-extended-glob
# --enable-extended-glob-default
# --enable-function-import
# --enable-glob-asciiranges-default
# --enable-help-builtin
# --enable-history
# --enable-job-control
# --enable-multibyte
# --enable-net-redirections
# --enable-process-substitution
# --enable-progcomp
# --enable-prompt-string-decoding
# --enable-restricted
# --enable-select
# --enable-translatable-strings
#
## Help builtin
#
# --enable-separate-helpfiles (disabled)
# --enable-single-help-strings (default)
#

bash_configure() {
	local log_file=${logdir}/configure.log

	# Dependencies
	local with_readline=--without-installed-readline

	if ${WITH_READLINE}; then
		with_readline=--with-installed-readline
	fi

	# Features
	local static_link=

	if test -n "${dynamic_linker}"; then
		static_link=--enable-static-link
	fi

	local configure_options="
		--build=${target_triplet}
		--host=${target_triplet}

		${static_link}
		--disable-rpath

		--prefix=${prefix}
		--libdir=${prefix}/${libdir}

		--enable-nls
		--enable-threads=posix

		--without-bash-malloc
		--with-curses
		${with_readline}
	"

	if test -f ${builddir}/Makefile; then
		make distclean >/dev/null 2>&1
		rm -f ${logdir}/*
	fi

	log "%s: configuring\n" ${package}

	${srcdir}/configure \
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

bash_build() {
	_make_build
}

bash_check() {
	if ${MAKE_CHECK}; then
		_make_check
	fi
}

bash_stage() {
	_make_stage
}

bash_pack_hook() {
	if test ! -f bin/sh; then
		(cd bin && ln -s bash sh) || exit
	fi
}

bash_pack() {
	_make_pack bash_pack_hook
}

bash_install() {
	_make_install
}

bash_main() {
	_make_main bash ${BASH_SRCDIR}
}
