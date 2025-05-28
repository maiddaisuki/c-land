#/bin/sh

. ${include_dir}/devenv.sh
. ${include_dir}/stagevars.sh

strip_args() {
	local list=$1
	shift

	local opt arg args

	for arg in ${list}; do
		for opt in "$@"; do
			case ${arg} in
			${opt})
				continue 2
				;;
			esac
		done

		if test -z "${args}"; then
			args=${arg}
		else
			args="${args} ${arg}"
		fi
	done

	printf %s "${args}"
}
