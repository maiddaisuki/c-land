#!/bin/sh

# BUILD_SYSTEM: make (Configure)

##
# Build perl (options as of version 5.42.2)
#
# Each -D{option} may be disabled with -U{option}
#

## Library
#
# -Dusedl
# -Duseshrplib
#

## Features
#
# [LFS]
#
# -Duselargefiles
#
# [Threads]
#
# -Dusethreads
#
# -DPERL_REENTRANT_MAXSIZE=SIZE
#
# [malloc]
#
# -Dusemymalloc
#
# -DPERL_POLLUTE_MALLOC
# -DPERL_DEBUGGING_MSTATS
#
# [integers and floats]
#
# -Dusemorebits
# -Duse64bitint
# -Duse64bitall
#
# -Duselongdouble
# -Dusequadmath
#
# [Taint]
#
# -Accflags=-DNO_TAINT_SUPPORT
# -Accflags=-DSILENT_NO_TAINT_SUPPORT
#
# [SOCKS]
#
# -Dusesocks
#

## Experemental Features
#
# -Accflags=-DPERL_MAX_NESTED_EVAL_BEGIN_BLOCKS_DEFAULT=N [default=1000]
#
# [Hashes]
#
# -Accflags=-DPERL_HASH_SIPHASH
# -Accflags=-DPERL_HASH_SIPHASH13
# -Accflags=-DPERL_HASH_ZAPHOD32
#
# -Accflags=-DPERL_HASH_USE_SBOX32_ALSO=0|1
# -Accflags=-DPERL_HASH_NO_SBOX32
# -Accflags=-DSBOX_MAX_LEN=N [default=24]
#
# -Accflags=-DPERL_PERTURB_KEYS_RANDOM
# -Accflags=-DPERL_PERTURB_KEYS_DETERMINISTIC
# -Accflags=-DPERL_PERTURB_KEYS_DISABLED
#
# -Accflags=-DNO_HASH_SEED
# -Accflags=-DNO_PERL_HASH_SEED_DEBUG
# -Accflags=-DNO_PERL_HASH_ENV
#
## Other
#
# -Accflags=-DNO_MATHOMS
# -Accflags=-DNO_PERL_INTERNAL_RAND_SEED
# -Accflags=-DNO_PERL_RAND_SEED
#

## Installation
#
# -Dinstallusrbinperl
# -Dversiononly
#
# -Dprefix=
# -Dbin=
# -Dscriptdir=
# -Dprivlib=
# -Darchlib=
# -Dman1dir=
# -Dman3dir=
# -Dhtml1dir=
# -Dhtml3dir=
#
# -Dsite{dir}=
# -Dvendor{dir}=
#
# where dir is any of:
#
# - prefix
# - bin
# - script
# - lib
# - arch
# - man1dir
# - man3dir
# - html1dir
# - html3dir
#
# -Dman3ext=EXT
#
# -Dinstallprefix=DESTDIR
#
## Include
#
# -Dotherlibdirs=DIRNAME[:...]
# -Accfalgs=-DAPPLLIB="DIRNAME[:...]"
#
# -Ddefault_inc_exclude_dot
#
# -Dinc_version_list={LIST|none}
#
# -Duserelocatableinc
#
## Customization
#
# -Dusesitecustomize
#

## Build
#
# -Dmksymlinks
#
# -Dlocincpth=LIST
# -Dloclibpth=LIST
#
# -Dsysroot=ROOT
#
# -Dusenm
#
## Extensions
#
# -Donlyextension=LIST
# -Dnoextension=LIST
#
## Modules
#
# -Dextras=LIST
#
## Cross-compilation
#
# -Dusecrosscompile
#
# -Dtargetarch=ARCH
# -Dtargethost=HOST
# -Dtargetport=PORT [default=22]
# -Dtargetuser=USERNAME [default=root]
# -Dtargetdir=DIRNAME
# -Dtargetenv=CMD
#
# -Dusrinc=DIRNAME
# -Dincpth=DIRNAME
# -Dlibpth=DIRNAME
#
# -Dtargetrun=PROG
# -Dtargetro=PROG
# -Dtargetfrom=PROG
#
# -Dhostperl=FILENAME
# -Dhostgenerate=FILENAME
#

## Developer Options
#
# -Dusedevel
#
## Debugging
#
# -DDEBUGGING | -DEBUGGING[=both]
# (equivalent to ccflags='-DDEBUGGING' and optimize=-g)
#
# -DEBUGGING=-g
# (equivalent to optimize=-g)
#
## DTrace
#
# -Dusedtrace
#

perl_configure() {
	local log_file=${logdir}/configure.log

	local useshrplib=
	local usedl=
	local usenm=

	if test -n "${dynamic_linker}"; then
		usedl=-Dusedl
	else
		usedl=-Uusedl
	fi

	case ${with_shared_libs} in
	*enable*)
		useshrplib=-Duseshrplib
		;;
	*)
		useshrplib=-Uuseshrplib
		;;
	esac

	case ${libc} in
	glibc)
		usenm=-Uusenm
		;;
	*)
		usenm=-Dusenm
		;;
	esac

	local configure_options="
		-Dmksymlinks
		-Dsysroot=${prefix}

		-Dprefix=${prefix}
		-Dman1dir=${prefix}/share/man/man1
		-Dman3dir=${prefix}/share/man/man3
		-Dhtml1dir=${prefix}/share/doc/perl5/html1
		-Dhtml3dir=${prefix}/share/doc/perl5/html3

		-Dusesitecustomize

		${useshrplib}
		${usedl}
		${usenm}

		-Uusemymalloc
		-Dusethreads
		-Dusequadmath
	"

	if test ! -f ${builddir}/Makefile; then
		rm -f ${logdir}/*

		cat <<-EOF >${builddir}/configure.sh
			#!/bin/sh

			PATH=${PREFIX}/bin:${PREFIX}/sbin:\${PATH}
			export PATH

			${srcdir}/Configure \\
				-Dcc="${cc}" \\
				-Dccflags="${cppflags} ${cflags}" \\
				-Doptimize="${cflags}" \\
				-Dld="${cc}" \\
				-Dldflags="${ldflags}" \\
				-Dar="${AR}" \\
				-Dranlib="${RANLIB}" \\
				-Dnm="${NM}" \\
				$(printf '%s \\\n' ${configure_options})
				2>&1 | tee ${log_file}
		EOF

		chmod +x ${builddir}/configure.sh

		note "${package}: manual configuration is required"
		note "${package}: please cd into '${builddir}' and run ./configure.sh"
		note "${package}: run ${self} once again when finished to build"

		exit 0
	fi
}

perl_build() {
	_make_build
}

perl_check() {
	if ${MAKE_CHECK}; then
		_make_check test
	fi
}

perl_stage() {
	_make_stage
}

perl_pack() {
	_make_pack
}

perl_install() {
	_make_install
}

perl_main() {
	_make_main perl ${PERL_SRCDIR}
}
