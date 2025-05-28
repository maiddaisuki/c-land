#!/bin/sh

# BUILD_SYSTEM: meson

##
# Build PACKAGE (options as of version VERSION)
#
# List package-specific options, if any
#

PACKAGE_configure() {
	local log_file=${logdir}/configure.log

	# They must be passed as a python array
	local meson_cflags=$(meson_args ${CC_ARCH} ${CPPFLAGS} ${CFLAGS})
	local meson_cxxflags=$(meson_args ${CXX_ARCH} ${CPPFLAGS} ${CXXFLAGS})
	local meson_ldflags=$(meson_args ${LDFLAGS})

	local meson_options="
		--buildtype=plain

		--prefix ${prefix}
		--libdir ${libdir}

		--default-library ${default_library}
		--strip

		-Db_ndebug=true
		${b_staticpic}
		${b_pie}
	"

	log "%s: configuring\n" ${package}

	CC=${CC} CXX=${CXX} \
		meson setup ${srcdir} --wipe \
		-Dc_args="${meson_cflags}" \
		-Dc_link_args="${meson_ldflags}" \
		-Dcpp_args="${meson_cxxflags}" \
		-Dcpp_link_args="${meson_ldflags}" \
		${meson_options} \
		>>${log_file} 2>&1

	test $? -eq 0 || die "${package}: configuration failed"
}

PACKAGE_build() {
	_meson_build
}

PACKAGE_check() {
	if ${MESON_TEST}; then
		_meson_check
	fi
}

PACKAGE_stage() {
	_meson_stage
}

PACKAGE_pack() {
	_meson_pack
}

PACKAGE_install() {
	_meson_install
}

PACKAGE_main() {
	_meson_main PACKAGE ${package_SRCDIR}
}
