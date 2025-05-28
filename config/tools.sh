#!/bin/sh

##
# Tools and flags for stage 1
#

case ${toolchain} in
[Gg][Nn][Uu])
	CC=gcc
	CXX=g++
	AS=as
	LD=ld
	AR=ar
	RANLIB=ranlib
	NM=nm
	OBJDUMP=objdump
	OBJCOPY=objcopy
	STRIP=strip
	;;
[Ll][Ll][Vv][Mm])
	CC=clang
	CXX=clang++
	AS=llvm-as
	LD=ld.lld
	AR=llvm-ar
	RANLIB=llvm-ranlib
	NM=llvm-nm
	OBJDUMP=llvm-objdump
	OBJCOPY=llvm-objcopy
	STRIP=llvm-strip
	;;
esac

CPPFLAGS='-DNDEBUG'
CFLAGS='-O2'
CXXFLAGS="${CFLAGS}"

case ${toolchain} in
[Ll][Ll][Vv][Mm])
	ASFLAGS=
	LDFLAGS="-fuse-ld=lld"
	;;
[Gg][Nn][Uu])
	ASFLAGS=
	LDFLAGS=
	;;
esac
