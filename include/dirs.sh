#!/bin/sh

##
# Build directories
#

# Build root for stage 1, 2 and 3
stage1_buildroot=${BUILDDIR}/${target}.stage1
stage2_buildroot=${BUILDDIR}/${target}.stage2
stage3_buildroot=${BUILDDIR}/${target}.stage3

##
# Installation directories
#

# Prefix used for stage 1 GCC and Binutils
tools_prefix=${BUILDDIR}/${target}.tools

# Prefix used for host (stage 1) libraries
libs_prefix=${tools_prefix}/${target}.libs

# Prefix used for stage 1 C Library.
libc_prefix=${tools_prefix}/${target}.libc
