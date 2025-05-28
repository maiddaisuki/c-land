#!/bin/sh

# if true, abort
error=false

# Verify directories set in `config/dirs.sh`

if test -z "${PREFIX-}"; then
	error=true
	error "PREFIX is not set"
fi

if test -z "${SRCDIR-}"; then
	error=true
	error "SRCDIR is not set"
elif test ! -d "${SRCDIR}"; then
	error=true
	die "SRCDIR: ${SRCDIR}: directory does not exist"
fi

if test -z "${BUILDDIR-}"; then
	error=true
	error "BUILDDIR is not set"
fi

# Verify dependencies

if ${WITH_READLINE-false}; then
	if ! ${WITH_NCURSES-false}; then
		error=true
		error "readline: missing dependency: ncurses"
	fi
fi

if ${WITH_EXPECT-false}; then
	if ! ${WITH_TCL-false}; then
		error=true
		error "expect: missing dependency: tcl"
	fi
fi

if ${WITH_BASH-false}; then
	if ! ${WITH_READLINE-false}; then
		error=true
		error "bash: missing dependency: readline"
	fi
fi

if ${WITH_BISON-false}; then
	if ! ${WITH_M4-false}; then
		error=true
		error "bison: missing dependency: m4"
	fi
fi

if ${WITH_FLEX-false}; then
	if ! ${WITH_M4-false}; then
		error=true
		error "flex: missing dependency: m4"
	fi
fi

if ${WITH_GETTEXT-false}; then
	if ! ${WITH_NCURSES-false}; then
		error=true
		error "gettext: missing dependency: ncurses"
	fi
	if ! ${WITH_LIBUNISTRING-false}; then
		error=true
		error "gettext: missing dependency: libunistring"
	fi
	if ! ${WITH_LIBXML2-false}; then
		error=true
		error "gettext: missing dependency: libxml2"
	fi
fi

if ${WITH_AUTOCONF-false}; then
	if ! ${WITH_M4-false}; then
		error=true
		error "autoconf: missing dependency: m4"
	fi
fi

if ${WITH_LIBTOOL-false}; then
	if ! ${WITH_M4-false}; then
		error=true
		error "libtool: missing dependency: m4"
	fi
fi

if ${WITH_AUTOMAKE-false}; then
	if ! ${WITH_PERL-false}; then
		error=true
		error "automake: missing dependency: perl"
	fi
	if ! ${WITH_M4-false}; then
		error=true
		error "automake: missing dependency: m4"
	fi
	if ! ${WITH_AUTOCONF-false}; then
		error=true
		error "automake: missing dependency: autoconf"
	fi
	if ! ${WITH_LIBTOOL-false}; then
		error=true
		error "automake: missing dependency: libtool"
	fi
fi

if ${WITH_DEJAGNU-false}; then
	if ! ${WITH_EXPECT-false}; then
		error=true
		error "dejagnu: missing dependency: expect"
	fi
fi

if ${WITH_GUILE2-false} || ${WITH_GUILE3-false}; then
	if ! ${WITH_BDWGC-false}; then
		error=true
		error "guile: missing dependency: bdwgc"
	fi
	if ! ${WITH_LIBFFI-false}; then
		error=true
		error "guile: missing dependency: libffi"
	fi
	if ! ${WITH_LIBTOOL-false}; then
		error=true
		error "guile: missing dependency: libtool (libltdl)"
	fi
	if ! ${WITH_LIBUNISTRING-false}; then
		error=true
		error "guile: missing dependency: libuinstring"
	fi
	if ! ${WITH_READLINE-false}; then
		error=true
		error "guile: missing dependency: readline"
	fi
fi

if ${WITH_AUTOGEN-false}; then
	if ! ${WITH_GUILE2-false}; then
		error=true
		error "autogen: missing dependency: guile2"
	fi
	if ! ${WITH_LIBXML2-false}; then
		error=true
		error "autogen: missing dependency: libxml2"
	fi
fi

if ${WITH_HELP2MAN-false}; then
	if ! ${WITH_PERL-false}; then
		error=true
		error "hrlp2man: missing dependency: perl"
	fi
fi

if ${WITH_GDB-false}; then
	# readline implies ncurses
	if ! ${WITH_READLINE-false}; then
		error=true
		error "gdb: missing dependency: readline"
	fi
fi

if ${error}; then
	die "invalid configuration"
fi

# Make sure following variables are not empty

if test -z "${MAKE_CHECK}"; then
	MAKE_CHECK=false
fi

if test -z "${MAKE_CHECK_LIBC}"; then
	MAKE_CHECK_LIBC=false
fi

if test -z "${MAKE_CHECK_GCC}"; then
	MAKE_CHECK_GCC=false
fi

if test -z "${MESOB_TEST}"; then
	MESOB_TEST=false
fi

if test -z "${CMAKE_TEST}"; then
	CMAKE_TEST=false
fi
