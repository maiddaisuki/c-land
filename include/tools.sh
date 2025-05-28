#!/bin/sh

case ${stage} in
1)
	test -d "${stage1_buildroot}" || install -d "${stage1_buildroot}" || exit
	build_log=${stage1_buildroot}/build.log
	;;
2)
	test -d "${stage2_buildroot}" || install -d "${stage2_buildroot}" || exit
	build_log=${stage2_buildroot}/build.log
	;;
3)
	test -d "${stage3_buildroot}" || install -d "${stage3_buildroot}" || exit
	build_log=${stage3_buildroot}/build.log
	;;
*)
	die "stage=${stage}: invalid value"
	;;
esac

if test ${save_PATH+y}; then
	PATH=${save_PATH}
fi

save_PATH=${PATH}

if test ${stage} -eq 1; then
	:
elif test ${stage} -eq 2; then
	PATH=${tools_prefix}/sbin:${tools_prefix}/bin:${PATH}
else # stage 3
	PATH=${PREFIX}/sbin:${PREFIX}/bin:${PATH}
fi

# Tools

if test ${stage} -eq 1; then
	. ${configs_dir}/tools.sh
else # stage 2 and 3
	. ${configs_dir}/flags.sh

	CC=$(which gcc)
	CXX=$(which g++)
	AS=$(which as)
	LD=$(which ld)
	if test ${stage} -eq 3 && test -f ${PREFIX}/bin/gcc-ar; then
		AR=$(which gcc-ar)
		RANLIB=$(which gcc-ranlib)
		NM=$(which gcc-nm)
	else
		AR=$(which ar)
		RANLIB=$(which ranlib)
		NM=$(which nm)
	fi
	OBJDUMP=$(which objdump)
	OBJCOPY=$(which objcopy)
	STRIP=$(which strip)
fi

# For use with `configure`
cc="${CC} -std=gnu17"
cxx="${CXX} -std=gnu++17"
as=${AS}

# For use with `cmake`
cmake_c_compiler=${CC}
cmake_cxx_compiler=${CXX}

if test -n "${CC_ARCH}"; then
	cc="${cc} ${CC_ARCH}"
	cmake_c_compiler="${cmake_c_compiler};${CC_ARCH}"
fi

if test -n "${CXX_ARCH}"; then
	cxx="${cxx} ${CXX_ARCH}"
	cmake_cxx_compiler="${cmake_cxx_compiler};${CXX_ARCH}"
fi

if test -n "${AS_ARCH}"; then
	as="${as} ${AS_ARCH}"
fi

# Flags

if test ${stage} -eq 1; then
	cppflags="-I${libs_prefix}/include"
	cflags=-g0
	cxxflags=-g0
	ldflags="-L${libs_prefix}/${arch_libdir} -L${libs_prefix}/lib"

	cppflags="${cppflags} ${CPPFLAGS}"
	cflags="${cflags} ${CFLAGS}"
	cxxflags="${cxxflags} ${CXXFLAGS}"
	ldflags="${ldflags} ${LDFLAGS}"
else
	# some projects try to explicitly use LFS functions with 64 suffix,
	# however at least musl does not expose those symbols by default
	cppflags="-D_GNU_SOURCE -D_LARGEFILE64_SOURCE ${CPPFLAGS}"
	cflags="${CFLAGS}"
	cxxflags="${CXXFLAGS}"
	ldflags="${LDFLAGS}"
fi

# uclibc-ng pretends to be glibc by defining __GLIBC__ and friends,
# make it behave by defining __FORCE_NOGLIBC
if test ${libc} = uclibc; then
	cppflags="-D__FORCE_NOGLIBC ${cppflags}"
	cflags="-D__FORCE_NOGLIBC ${cflags}"
	cxxflags="-D__FORCE_NOGLIBC ${cxxflags}"
fi

# Build systems

if test ${stage} -eq 1; then
	# autotools
	with_static_libs=--enable-static
	with_shared_libs=--disable-shared
	with_pic=

	# cmake
	build_shared_libs=OFF
	build_static_libs=ON
	cmake_position_independent_code=

	# meson
	default_library=static
	b_pie=
	b_staticpic=
else # stage 2 and 3
	if test -n "${dynamic_linker}"; then
		with_shared_libs=--enable-shared
		build_shared_libs=ON

		if ${ENABLE_STATIC}; then
			with_static_libs=--enable-static
			build_static_libs=ON
			default_library=both
		else
			with_static_libs=--disable-static
			build_static_libs=OFF
			default_library=shared
		fi
	else
		with_shared_libs=--disable-shared
		with_static_libs=--enable-static

		build_shared_libs=OFF
		build_static_libs=ON

		default_library=static
	fi

	if ${ENABLE_PIC}; then
		# --with-pic is the old name for --enable-pic
		with_pic='--enable-pic --with-pic'
		cmake_position_independent_code='-DCMAKE_POSITION_INDEPENDENT_CODE=ON'
		b_pie='-Db_pie=true'
		b_staticpic='-Db_staticpic=true'
	else
		# use defaults
		with_pic=
		cmake_position_independent_code=
		b_pie=
		b_staticpic=
	fi

	# Help cmake find dependencies
	export CMAKE_PREFIX_PATH=${PREFIX}

	# Help pkgconf/pkg-config find dependencies
	export PKG_CONFIG_LIBDIR=${PREFIX}/${arch_libdir}/pkgconfig:${PREFIX}/lib/pkgconfig:${PREFIX}/share/pkgconfig
fi
