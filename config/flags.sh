#!/bin/sh

##
# Set any flags you wish, e.g. optimizations
#
# Do not place -D_FORTIFY_SOURCE=N alone in CPPFLAGS, place it in
# C[XX]FLAGS together with optimization flags.
#
# If generated code is expected to run only on a specific machine,
# consider using -march=CPU for gcc, g++ and as.
#
# Pass -march=CPU to {CC,CXX,AS}_ARCH below, we will pass them in a way
# suitable for `configure`, `meson` and `cmake`.
#

#CC_ARCH=-march=
#CXX_ARCH=-march=
#AS_ARCH=-march=

CPPFLAGS="-DNDEBUG"
CFLAGS="-D_FORTIFY_SOURCE=3 -O3"
CXXFLAGS="${CFLAGS}"
ASFLAGS=
LDFLAGS="-shared-libgcc"

##
# Uncomment following lines to use LTO
#
# Following packages fail to build with LTO:
#
# - libsigsegv
# - make (pass -Wno-error)
#

# if test ${stage} -eq 3; then
# 	CFLAGS="${CFLAGS} -flto -ffat-lto-objects"
# 	CXXFLAGS="${CXXFLAGS} -flto -ffat-lto-objects"
# 	LDFLAGS="${LDFLAGS} -fuse-linker-plugin"
# fi
