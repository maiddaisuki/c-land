#!/bin/sh

##
# Build options
#

# Whether to build static libraries
ENABLE_STATIC=true

# If true:
#
# 1. GCC will be configure to generate PIE code by default
# 2. All static libraries will be built with -fPIC, when possible
#
ENABLE_PIC=true

# If true:
#
# configure glibc and gcc with --enable-bind-now
# This will link programs with `-z now`
#
ENABLE_BIND_NOW=true

# [x86 targets only]
# If true:
#
# configure glibc and gcc with --enable-cet
# This will build libraries with -fcf-protection enabled
#
# You may want to add -fcf-protection to C[XX]FLAGS in `config/flags.sh`.
#
ENABLE_CET=true

##
# make
#

# Options to pass to `make`
# WARNING: do not use plain -j, use -jN instead
MAKE_JOBS= #'-jN -Otarget --no-print-directory'

# Whether to run testsuite after a package is built
MAKE_CHECK=true

# Whether to run testsuite for C Library (if supported)
MAKE_CHECK_LIBC=true

# Whether to run testsuite for gcc (takes hours)
MAKE_CHECK_GCC=false

##
# meson
#

# Options to pass to `meson compile`
MESON_JOBS= #'-j N'

# Whether to run `meson test` for built packages
MESOB_TEST=true

##
# cmake
#

# CMake generator to use
export CMAKE_GENERATOR='Ninja'

# Whether to run `ctest` for built packages
CMAKE_TEST=true
