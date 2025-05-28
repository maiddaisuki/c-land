# Templates

This subdirectory contains templates which can be used to add new packages
which use `autotools`, `cmake` or `meson` as their build system.

In most cases all you need to do is modify `{package}_configure` function
to pass package-specific options.

## The {package}\_configure Function

This function should configure the package, but not invoke the build system
to build it.

For packages which use plain `make`, this function should copy source files to
build directory, for example:

```shell
cp -Rp ${srcdir}/* -t ${builddir}
```

If package has optional dependencies, their usege should be controlled with
`WITH_*` macros set in `config/packages.sh`.

See existing scripts for examples.

## Details for Specific Build Systems

### Make/Autotools

Some very old packages may not support out-of-tree builds. In this case copy
source files to build directory.

The `_make_stage` function uses `install-strip` target by default to install
package to staged area. Packages which do not use `automake` may not support
this target. In this case, explicitly use `install` target:

```shell
_make_stage install
```

Similarly, `_make_check` uses `check` target by default. Some packages use
`test` target instead:

```shell
_make_check test
```

### CMake

Most packages use `BUILD_SHARED_LIBS` variable to choose what type of libraries
to build. Some packages have package-specific variables to choose type of libraries to
build.

`include/tools.sh` sets the following variables:

- `build_shared_libs`
- `build_static_libs`

Both may expand into `ON` or `OFF`.

If package provides a variable to explicitly specify whether to build static
libraries, pass it to `cmake` like this:

```shell
cmake ... -D{PACKAGE_SPECIFIC_VARNAME}=${build_static_libs}
```
