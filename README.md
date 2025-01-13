# DuckDB Extensions

This repo builds duck db and adds a number of extensions for automatic load and uses dynamic linking instead of static linking (which go-duckdb uses).
The man reason is the number of static libraries is very large and linking them all in the correct order is cumbersome.
Additionally the osx linker doesnt have `--start-group` and `--end-group` which makes it exteremely difficult to link all the
static libraries in the correct order on osx at all.

This fork also removes the windows and freebsd builds. The extensions are not available or not tested on those platforms.
We couldn't even get the windows build to work.

Some consequences of this change:
* `DYLD_LIBRARY_PATH` must be set to the directory containing the dynamic libraries.
* `LD_LIBRARY_PATH` must be set to the directory containing the dynamic libraries.
* we use vcpkg to build dependencies. You must have vcpkg installed to build the dynamic libraries.
* go-duckdb will statically link against the library it distributes. We have to set a go tag `duckdb_use_lib` to ensure
    that the shared library and its extensions are linked correctly.

## Configure `vcpkg`

To install vcpkg, follow the instructions
[here](https://learn.microsoft.com/en-gb/vcpkg/get_started/get-started?pivots=shell-powershell).

You can simply run the following on osx:
```
brew install vcpkg
git clone https://github.com/microsoft/vcpkg "$HOME/vcpkg"
export VCPKG_ROOT="$HOME/vcpkg"
```

Be sure to set the `VCPKG_ROOT` environment variable in .profile or .bashrc to make sure its picked up at build time.

## Optionally Configure ccache

Run `brew install ccache` to install ccache on osx. This will speed up the build process transparently.

## Ensure the following are set when using this repo:

1. set `-tags duckdb_use_lib` in your go build command.
2. set `DYLD_LIBRARY_PATH` to the directory containing the dynamic libraries.
    * OSX: `export DYLD_LIBRARY_PATH=$HOME/go/src/github.com/sundeck-io/go-duckdb-latest/deps/darwin_arm64`
    * Linux (x64): `export LD_LIBRARY_PATH=$HOME/go/src/github.com/sundeck-io/go-duckdb-latest/deps/linux_amd64`
    * Linux: (arm64) `export LD_LIBRARY_PATH=$HOME/go/src/github.com/sundeck-io/go-duckdb-latest/deps/linux_arm64`
