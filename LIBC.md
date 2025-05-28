# C Library

This file describes how `binutils` and `gcc` are configured in order to use
targeted C Library (referred as `libc` in this file).

This file also provides details specific to a particular C Library.

## Dynamic Linker

When you create a dynamic executable, compiler passes absolute filename of
C Librarys's dynamic linker to the linker (`ld`, `lld` etc.).

The location of the dynamic linker is the same among systems.  
For example, `glibc`'s dynamic linker on `x86_64-*-linux-gnu` hosts is

    /lib64/ld-linux-x86-64.so.2

When you run such executable, dynamic linker is invoked to load shared
libraries, perform relocations, resolve symbol references and so on.

To find an executable's or another shared library's dependencies, dynamic linker
searches number of directories, this may include:

- a few known hardcoded directories (e.g. `/lib`)
- directories listed in files like `/etc/ld.so.conf`
- directories specified with `-rpath` at link time

We do not replace system's dynamic linker with one we just built and we do not
modify system's files like `/etc/ld.so.conf`.
This could result in unusable system, if not worse.

However we want to use our `libc` that we built.

To achieve this, we build `gcc` in way to make it use `libc`'s dynamic linker,
that is, the one installed in `PREFIX` (as set in `config/dirs.sh`).
This also allows to use files like `PREFIX/etc/ld.so.conf` to control
dynamic linker's search path.

## site.spec

This is achieved by configuring `gcc` with the following option:

    --with-specs=%{!specs:-specs=${PREFIX}/${libdir}/site.spec}

This makes `gcc` read additional spec file `PREFIX/${libdir}/site.spec` which
will contain something like this:

    link:
    + %{static|static-pie: -no-dynamic-linker;: -dynamic-linker=PREFIX/lib64/ld-linux-x86-64.so.2}

Which makes `gcc` to pass `-dynamic-linker=PREFIX/lib64/ld-linux-x86-64.so.2`
to the linker, unless `-static` or `-static-pie` is used.

You are free to modify this file to further customize `gcc` behavior.  
Refer to `gcc` documentation for more details.

You can prevent `gcc` from reading this file by using you own spec file
(`-specs=FILENAME`) or `-specs=/dev/null`, which will make `gcc` to use
the default filename for dynamic linker.

This, however, may prevent executables from running during configuration.  
You may need to pretend you're cross-compiling to work around this.

## PREFIX and sysroot

Both `binitils` and `gcc` are configured with:

    --with-sysroot=PREFIX

This will make `ld` and `gcc` search for header files and libraries in `PREFIX`
by default.

## Hacks

If `libc` is different from your system's C Library, you may create a symbolic
link in your system directories which points to dynamic linker in `PREFIX` and
not use `site.spec` at all.

You will need to modify [gcc.sh](/packages/gcc.sh) or explicitly use
`-specs=/dev/null`.

Explicitly using `-specs=/dev/null` may interfere with `gcc`'s testsuite.

## Specific C Library

Depending on C Library, the following packages maybe required:

- libiconv
- libxcrypt
- tzdata

| libc      | tzdata | libiconv | libxcrypt |
| --------- | ------ | -------- | --------- |
| glibc     | yes    | no       | yes       |
| musl      | no     | yes      | no        |
| uclibc-ng | no     | depends  | depends   |

### uclibc-ng

You need to run `make config` or `make menuconfig` in source directory and
save results in file named `.config` (this is the default).

The `build.sh` will copy the whole source tree and `.config` to builddir,
substitute values of some variables in `.config` and run `make oldconfig`
to apply modifications.

There are features you must enable to build some packages.

You should always enable:

- `SUSv3 Legacy Functions`: for `sys/ucontext.h`
- `SUSv4 Legacy Functions`: for `isascii`
- `Extended Locale Support`: for `libstdc++`
- Support for `getopt_long`

The following table lists some cases:

| Package                  | Feature                   |
| ------------------------ | ------------------------- |
| gcc with `--enable-gcov` | `ftw` family of functions |
| expect                   | libutil (for `openpty`)   |
| python                   | libutil (for `openpty`)   |
| gdb                      | IPv6 support              |
| tcl                      | IPv6 support              |

There may be other features required by specific packages.
Generally, you should enable most features, unless you know you don't need them.
