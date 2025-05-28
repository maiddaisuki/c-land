# Packages

This file list all packages which can be built with `build.sh`.

## Build System

The `build.sh` can build packages using `autotools`, `cmake` and `meson` build
systems, as well as packages using some sort of `configure`-like scripts.

The following subsections tell which build system is used to build a specific
package, and provide some additional information.

### Packages using make

Following packages use plain `make` as their build system.

| Package |
| ------- |
| bzip2   |
| tzdata  |

### Packages using autotools

The following packages use `autotools` (with or without either `automake` or
`libtool`) as their build system.

If you obtained the source code from VCS, you'll need to bootstrap (generate the
build system for) many of them.

Some GNU packages make use of `gnulib`.
Running package's bootstrap script will usually clone `gnulib` repository as a
`git submodule`.
This may be prevented by cloning <git://git.savannah.gnu.org/gnulib.git> manualy
and setting `GNULIB_SRCDIR` environment variable.
However, a specific version of a package may not work with a specific version of
`gnulib`.
As such, it is **recommended** to obtain source code as tarballs.

The following table summarizes, for each supported package, which bootstrap
command must be run and whether the package uses `gnulib`.

| Package      | Bootstrap command  | Automake | Libtool  | gnulib | Note                 |
| ------------ | ------------------ | -------- | -------- | ------ | -------------------- |
| autoconf     | ./bootstrap        | no       | no       | no     |                      |
| autogen      | ./config/bootstrap | yes      | yes      | no     | Use tarball          |
| automake     | ./bootstrap        | yes      | no       | no     |                      |
| bash         |                    | no       | no       | no     |                      |
| binutils     |                    | yes      | yes      | no     |                      |
| bison        | ./bootstrap        | yes      | yes      | yes    |                      |
| dejagnu      | ./autogen.sh       | yes      | no       | no     |                      |
| expect       |                    | no       | no       | no     |                      |
| flex         | ./autogen.sh       | yes      | yes      | no     |                      |
| gcc          |                    | yes      | yes      | no     |                      |
| gdb          |                    | yes      | yes      | no     |                      |
| gdbm         | ./bootstrap        | yes      | yes      | no     |                      |
| gengen       | ./autogen.sh       | yes      | no       | no     |                      |
| gengetopt    | ./autogen.sh       | yes      | no       | no     |                      |
| gettext      | ./autogen.sh       | yes      | yes      | yes    | Use tarball          |
| gperf        | ./autogen.sh       | yes      | no       | yes    |                      |
| gpm          | ./autogen.sh       | no       | no       | no     |                      |
| guile        | ./autogen.sh       | yes      | yes      | yes    |                      |
| help2man     |                    | no       | no       | no     | no                   |
| indent       | ./bootstrap        | yes      | no       | no     |                      |
| libb2        | ./autogen.sh       | yes      | yes      | no     |                      |
| libffi       | ./autogen.sh       | yes      | yes      | no     |                      |
| libgmp       |                    | yes      | yes      | no     |                      |
| libiconv     | ./autogen.sh       | yes      | yes      | yes    |                      |
| libisl       | ./autogen.sh       | yes      | yes      | no     |                      |
| libmpc       | autoreconf -i      | yes      | yes      | no     |                      |
| libmpfr      | ./autogen.sh       | yes      | yes      | no     | No need to bootstrap |
| libsigsegv   | ./autogen.sh       | yes      | yes      | yes    |                      |
| libtool      | ./bootstrap        | yes      | yes      | yes    |                      |
| libunistring | ./autogen.sh       | yes      | yes      | yes    |                      |
| libunwind    | autoreconf -i      | yes      | yes      | no     |                      |
| libxcrypt    | ./autogen.sh       | yes      | yes      | no     |                      |
| m4           | ./bootstrap        | yes      | yes      | yes    |                      |
| make         | ./bootstrap        | yes      | yes      | yes    |                      |
| mpdecimal    |                    | yes      | no       | no     |                      |
| ncurses      |                    | no       | optional | no     |                      |
| pkgconf      | ./autogen.sh       | yes      | yes      | no     |                      |
| python       |                    | no       | no       | no     |                      |
| readline     |                    | yes      | no       | no     |                      |
| tcl          |                    | no       | no       | no     |                      |

### Packages using meson

Following packages use `meson` as their build system.

| Package | Note |
| ------- | ---- |

### Packages using cmake

Following packages use `cmake` as their build system.

One issues with `cmake` is that many packages use `BUILD_SHARED_LIBS` variable
to choose the type of libraries to build, which means that we cannot build both
static and shared libraries at the same time.

We always prefer shared libraries over static ones.

However, some packages allow to build both shared and static libraries at the
same time using package-specific variables instead of `BUILD_SHARED_LIBS`.

| Package | Both libraries |
| ------- | -------------- |
| bdwgc   | no             |
| brotli  | no             |
| expat   | no             |
| jansson | no             |
| libxml2 | no             |
| lz4     | yes            |
| lzma    | no             |
| xxhash  | no             |
| zstd    | yes            |

### Packages using other build systems

Following packages use custom a build system. Most of them use `configure`-like
scripts.

| Package | Build system                   |
| ------- | ------------------------------ |
| musl    | Uses custom `configute` script |
| openssl | `Configure` script             |
| perl    | `Configure` script             |
| sqlite3 | Autosetup                      |
| zlib    | Uses simple `configure` script |

NOTE: `zlib` support `cmake`, however, as of the latest stable release (1.3.1),
the `cmake --insatll --prefix DESTDIR` does not work properly.

## Supported Packages

### autoconf

A `config.site` will be generated and installed to `PREFIX/share` to be used
with `configure --preifx=PREFIX`. Feel free to modify this file.

Dependencies:

- m4

### autogen

Dependencies:

- guile2
- libxml2

### automake

Dependencies:

- autoconf
- perl

### bash

Dependencies:

- ncurses
- readline

### bdwgc

No dependencies.

### binutils

Building `gprofng` with `musl` fails.

Dependencies:

- zlib

Optional dependencies:

- jansson
- xxhash
- zstd

If `flex` is built before `binutils`, some programs will use `libfl`.

### bison

Dependencies:

- m4

Optional dependencies:

- libreadline
- libtextstyle (part of `gettext` package)

### brotli

No dependencies.

### bzip2

No dependencies.

### dejagnu

Dependencies:

- expect

### expat

No dependencies.

### expect

Dependencies:

- tcl

Optional dependencies:

- tk (TODO)

### flex

Some `binutils` programs seem to use `libfl2` if it is installed.

Dependencies:

- m4?

### gcc

Dependencies:

- libgmp
- libmpfr
- libmpc
- libisl
- zlib

Optional dependencies:

- libunwind
- zstd

### gdb

Dependencies:

- libgmp
- libmpfr
- ncurses
- readline
- zlib

Optional dependencies:

- libdebuginfod (TODO: part of `elfutils` package)
- expat
- guile
- libunwind
- lzma
- python
- tcl
- tk (TODO)
- x (TODO)
- xxhash
- zstd

### gdbm

Optional dependencies:

- readline

### gengen

No dependencies.

### gengetopt

No dependencies.

### gettext

Some parts of `gettext` are considered separate packages by `build.sh`:

- `libintl` (gettext-runtime)
- `libasprintf`
- `libtextstyle`
- `gettext` (gettext-tools)

Dependencies:

- libunistring
- libxml2
- ncurses

### glibc

Required packages:

- libxcrypt
- tzdata

### gperf

No dependencies.

### gpm

`libgpm` is an optional dependency of `ncurses`.
`libgpm` itself has optional dependency on `ncurses`.

Configuring with `--without-curses` to avoid cyclic dependency.

NOTE: this package has not been updated since 2012, disable this package if you
encounter build errors with newer versions of `gcc`.

### guile

Dependencies:

- bdwgc
- libffi
- libgmp
- libtool (libltdl)
- libunistring

Optional dependencies:

- readline

### help2man

Dependencies:

- perl

### indent

No dependencies.

### Jansson

No dependencies.

### libasprintf

Optional part of `gettext` package.

### libb2

No dependencies.

### libffi

No dependencies.

### libgmp

No dependencies.

### libiconv

All support C Libraries provide `iconv(3)` functions.
`uclibc-ng` may be configured without `iconv(3)`.

By default, we build `libiconv` only when C Library does not provide `iconv(1)`
utility.
In this case we build `libiconv` as a static library and do not install it.

You may explicitly request building of `libiconv` by setting `WITH_LIBICONV=true`
in [config/packages.sh](/config/packages.sh).

`glibc`'s `iconv(3)` is very good and it is descouraged to build `libiconv`
separetely.

### libintl

Part of `gettext` packages.

We always build `libintl`.

The `libintl` will install `libintl.h` and `-lintl` only if `gettext(3)` family
of functions not provided by the C Library.

This always installs `gettext(1)` and `ngettext(1)` utilities.

### libisl

Dependencies:

- libgmp

### libmpc

Dependencies:

- libgmp
- libmpfr

### libmpfr

Dependencies:

- libgmp

### libsigsegv

No dependencies.

### libtextstyle

Part of `gettext` package.

### libtool

Dependencies:

- m4

### libunistring

No dependencies.

### libunwind

Optional dependencies:

- zlib
- lzma

### libxcrypt

Provides `crypt.h` and `crypt(3)` function.

`glibc` no longer provides them.

### libxml2

Optional dependencies:

- lzma
- readline
- zlib

### linux

We need Linux headers. Using the latest available version is recommended.

### lz4

No dependencies.

### lzma

No dependencies.

### m4

Optional dependencies:

- libsigsegv

### make

Optional dependencies:

- guile

### mpdecimal

No dependencies.

### musl

Required packages:

- libiconv (for `iconv(1)`)

### ncurses

Optional dependencies:

- gpm

### openssl

Optional dependencies:

- brotli
- zlib
- zstd

### perl

Optional dependencies:

- gdbm

### pkg-config

TODO

### pkgconf

Preffered over `pkg-config`.

### python

The following packages provide python bindings:

- `libisl`
- `libxml2`

Dependencies:

- mpdecimal

Optional dependencies:

- bzip2
- expat
- gdbm
- libb2
- libffi (TODO: verify)
- ncurses
- openssl
- readline
- zlib
- zstd

### readline

Dependencies:

- ncurses

### sqlite3

Uses `tcl` for testsuite.

Optional dependencies:

- icu (TODO?)
- readline
- tcl

### tcl

No dependencies.

### tk

TODO

Dependencies:

- tcl
- x

### uclibc-ng

Required packages:

- gettext (for `libintl`)

Depending on configuration, you may also need:

- libiconv
- libxcrypt

### xxhash

No dependencies.

### zlib

No dependencies.

### zstd

Optional dependencies:

- zlib
- lz4
- lzma

## Known Issues

### Expect

Expect's `config.sub` is too old and does not recognize `*-linux-{musl,uclibc}`
targets. Replace expect's `config.sub` with `build-aux/config.sub`.

### GCC

Build may fail when building `libstdc++` during

1. stage 2
2. stage 3 if `gettext` is not built (`WITH_GETTEXT=false`)

It result from running `msgfmt` in `${target_triplet}/libstdc++v3/po` which
tries to load newly built `libstdc++.so.6`.

Possible solutions are as follows:

1. configure with `--disable-nls` (should be OK for stage 2)
2. for stage 3 only, build `gettext` with `WITH_GETTEXT=true`
3. follow `build.log` and manually run `make` in `${target_triplet}/libstdc++v3/po`
   before make enters `po` subdirectory

If you choose option 3, you will need to do it three times because of
`--enable-bootstrap`. You can pass `--disable-bootstrap` to `gcc`'s configure
script.

`*-linux-uclibc`:

Sanitizers fail to build and will be disabled.

### GDM

`*-linux-uclibc`:

Building `gdb-16.3` fails.
You may need to explicitly add `-lintl` to `LDFLAGS`.

### GDBM

`*-linux-musl`:

Building `gdbm-1.25` fails.
Solution is to add `#include <sys/types>` on top of `tools/gdbmapp.h`.

`*-linux-uclibc`:

Building `gdbm-1.25` fails.
You may need to explicitly pass `LIBS=-lintl` to `configure`.

### Guile

Building with `uclibc-ng` fails.

### Perl

`Configure` may incorrectly determine filename of C Library.

`*-linux-uclibc`:

You need to explicitly add `-lintl` to list of libraries to link against.

### Readline

Latest stable version `v8.2` is broken and may make programs crash at startup.  
Use `master`, `v8.1` or any later version.
