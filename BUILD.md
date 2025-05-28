# build.sh

How to run `build.sh`.

## Options

The `build.sh` accepts following options:

- `--help`: display help message and exit
- `--target=triplet`: see below
- `--toolchain=gcc|llvm`: see below
- `--with-arch-libdir`: use `lib32` or `lib64` instead of `lib` within `PREFIX`
  as the installation directory for libraries.
- `--disable-stage1`: disable stage 1
- `--disable-stage2`: disable stage 2
- `--disable-stage3`: disable stage 3

### --target

The value passed with `--target` options is used to figure out the following:

- C Library to build
- dynamic library used by the C Library

This value is also used when configuring `gcc` and `binutils`.

The C Libraries are recognied as follows:

| Triplet         | C Library   | Note                              |
| --------------- | ----------- | --------------------------------- |
| \*-linux[-gnu]  | `glibc`     |                                   |
| \*-linux-musl   | `musl`      |                                   |
| \*-linux-uclibc | `uclibc-ng` |                                   |
| \*-linux-newlib | `newlib`    |                                   |
| \*-linux-diet   | `dietlibc`  | Trailing `-diet` will be stripped |

If `--target` option is not used, value returned by `config.guess` will be used.

### --toolchain

This option allows select toolchain to use during stage 1.  
This option accepts the following values:

- `gnu` (this is the default)
- `llvm`

You may specify compiler/linker flags to use in [tools.sh](/config/tools.sh).

Note that selected toolchain should be able to build targeted C Library.

## Overview

### Stage 1

During stage 1 we build:

1. Dependencies of `binutils` and `gcc`:

   - libgmp
   - libmpfr
   - libmpc
   - libisl

2. Targeted C Library, which is inferred from value passed with `--target`.
3. `bintuils` and `gcc` which target just built C Library.

At the end of stage 1, we have a toolchain which builds against targeted
C Library.

NOTE: there is no `libc` in `PREFIX` yet at this point.

### Stage 2

Stage 2 effectively repeats actions from stage 1, with one important detail:
we use just built `binutils` and `gcc` to build all dependencies and eventually
rebuild `binutils` and `gcc`.

In addition to libraries built in stage 1, it also always builds:

- zlib

It may also build the following packages:

- libiconv: if C Library does not provide `iconv(3)` or does not intsall
  `iconv(1)` utility
- libintl: if C Library does not provide `gettext(3)`
- libxcrypt: if C Library does not provide `crypt.h` and `crypt(3)`
- zoneinfo: if C Library expects timezone information in `PREFIX`

If requested, it may also build the following libraries

- jansson: optional dependency for `ld` and `gold`
- libunwind: optional dependency for `gcc`
- xxhash: optional dependency for `ld` (or `gold`)
- zstd: optional dependency for `binutils` and `gcc`

At the end of stage 2, we have completely usable toolchain
(without `gdb` though).

### Stage 3

During stage 3 we build everything else, including rebuilding all packages built
during stage 2.

## Logs and State Files

The `build.sh` keeps track of which packages has been built and installed.
This way, `build.sh` will not try to rebuild packages which are already built
if you run `build.sh` multiple times (for example with `--disable-stageN`).

For details on how the filenames are constructed,
see [dirs.sh](/include/dirs.sh) and [stagevars.sh](/include/stagevars.sh).

### State Files

The `build.sh` used empty files created with `touch` to keep track of built
packages. We refer to these files as **state files**.

Each package produces up to three state files:

- build stamp: package has been configure and built
- test stamp: testsuite has been run (regardless of result)
- install stamp: package has been installed to `PREFIX`

For each package, an archive `{package}.tar.*` is created.

NOTE: archives are created in a way that they expect current directory
to be `PREFIX` during extraction.
For example, `tar -xf {package}.tar.gz -C PREFIX`.

### Logs

The `build.sh` also keeps logs for each package it builds.  
Each package produces up to four logs:

- configure log (e.g. from `configure`)
- build log (e.g. from `make`)
- testsuite log (e.g. from `make check`)
- installation log (e.g. from `make install`)
