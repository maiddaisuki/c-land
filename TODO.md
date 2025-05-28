# TODO

This file lists packages which are planned to be supported.

## curl

`libcurl` is dependency of `elfutils`.

Dependencies:

- ???

## elfutils

`libdebuginfod` is optional dependency of `binutils` and `gdb`.

Dependencies:

- libcurl
- jsonc
- libarchive
- libmicrohttpd

## emacs

Dependencies:

- ???

## glib

Debian's `meson` package is too old :).

## gtk

How do we build X Libraries?

## jsonc

Dependency of `elfutils`.

## libarchive

Dependency of `elfutils`.

Dependencies:

- ???

## libc

Add support for:

- newlib
- dietlibc

## libmicrohttpd

Dependency of `elfutils`.

Dependencies:

- ???

## linux-utils

`libuuid` is optional dependency of `python`.

Dependencies:

- ???

## pkg-config

Dependencies:

- glib

## tk

Optional dependency of `pyhton`, `expect` and `gdb`.

Need to figure out how to build X Libraries, and whether it will work properly
with what we are doing.

## X

How do we build it?
