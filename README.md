# C Land

This repository contains shell script `build.sh` which you can use to build
GNU toolchain targeting specific C Library (e.g. `glibc` or `musl`).

The built toolchain has the following properties:

1. It generates dynamic executables which use dynamic linker installed in
   `PREFIX`, which means you can run them on your system regardless of its
   C Library.

   Dynamic executables will be run able to run on any system, as long as
   C Library is installed in `PREFIX` and its dynamic linker is able to find
   dependencies at runtime.

   This also means that system directories are kept intact and you do not need
   special privileges to install and use targeted C Library.

2. The toolchain itself and packages we build are linked against targeted
   C Library.

   This means they are independant of system's C Library.
   The only limitation is kernel version which is required to use targeted
   C Library.

   All you have to do is make sure all built packages are installed to `PREFIX`.
   Note that it can be a symbolic link pointing to any location.

This script may build more than just toolchain and C Library.
For example, it can also build commonly used GNU tools such as `autoconf`,
`automake`, `libtool` and `make`.

## Requirements

First of all, you will need a C/C++ compiler capable of compiling `gcc` and
targeted C Library.

Current stable version of `gcc` is 15.1.0 which requires C++14.

You need the following build tools installed:

- GNU Make
- CMake
- Meson

Some testsuites may require `dejagnu` or other packages to run.

If you are using source code from VCS, you may also need at least the following
tools to bootstrap packages' build systems

- autoconf
- automake
- flex
- bison
- gettext
- help2man
- libtool

Your system's package manager will usually provide them all.

## Getting Started

See [PACKAGES.md](/PACKAGES.md) for details about packages which can be built
with `build.sh`.  
See [BUILD.md](/BUILD.md) for details about running `build.sh` and brief
overview of the build process.  
See [LIBC.md](/LIBC.md) for some important information about supported
C Libraries.

### Configs

The `config` subdirectory contains files to be modified by the user.

You must always set `PREFIX`, `SRCDIR`, `BUILDDIR` and `DESTDIR` in
[config/dirs.sh](/config/dirs.sh).  
You also use this file to specify directories containing packages' source code.

You can set common build options in [config/options.sh](/config/options.sh).  
You can select optional packages to build in [config/packages.sh](/config/packages.sh).  
You can set compiler/linker flags in [config/tools.sh](/config/tools.sh) and
[config/flags.sh](/config/flags.sh).

## Adding New Packages

It should be easy to add support for new packages which use `autotools`,
`cmake` or `meson` as their build system.

See [templates/TEMPLATES.md](/templates/TEMPLATES.md) for more details.

Also see [TODO.md](/TODO.md) if you would like to help.
