DUCKDB_REPO=https://github.com/duckdb/duckdb.git
DUCKDB_REF=ab8c90985741ac68cd203c8396022894c1771d4b

CFLAGS   = -O2 -g -fno-omit-frame-pointer
CXXFLAGS = -O2 -g -fno-omit-frame-pointer
CC 		 = ""
CXX      = ""
DEP_NAME = ""
VCPKG_TARGET_TRIPLET = ""
OSX_BUILD_ARCH = ""


CHECK_DARWIN = if [ "$(shell uname -s | tr '[:upper:]' '[:lower:]')" != "darwin" ]; then echo "Error: must run build on darwin"; false; fi
CHECK_LINUX = if [ "$(shell uname -s | tr '[:upper:]' '[:lower:]')" != "linux" ]; then echo "Error: must run build on linux"; false; fi
MKDIR_COMMAND = rm -rf deps/$(DEP_NAME) && mkdir -p deps/$(DEP_NAME)

DUCKDB_COMMON_BUILD_FLAGS := BUILD_SHELL=0 DISABLE_SHELL=1 STATIC_LIBCPP=0 BUILD_UNITTESTS=0 DUCKDB_PLATFORM=any ENABLE_EXTENSION_AUTOLOADING=1 ENABLE_EXTENSION_AUTOINSTALL=1 SKIP_SUBSTRAIT_C_TESTS=true USE_MERGED_VCPKG_MANIFEST=1 VCPKG_TOOLCHAIN_PATH=${VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake 

CORE_COMMAND =  \
	cd duckdb && \
	CC=${CC} CXX=${CXX} VCPKG_TARGET_TRIPLET=${VCPKG_TARGET_TRIPLET} OSX_BUILD_ARCH=${OSX_BUILD_ARCH} ${DUCKDB_COMMON_BUILD_FLAGS} make debug extension_configuration bundle-library -j 2 && \
	cd ../ && \
	cp duckdb/build/debug/src/libduckdb.* deps/${DEP_NAME}/ && \
	find duckdb/build/debug/repository -name '*.duckdb_extension' -exec cp {} deps/${DEP_NAME}/ \;


OS := $(shell uname -s | tr '[:upper:]' '[:lower:]')  # Get OS name in lowercase
ARCH := $(shell uname -m)
COS := $(strip $(OS))
ifeq ($(ARCH),x86_64)
  ARCH := amd64
else ifeq ($(ARCH),aarch64)
  ARCH := arm64
endif


.PHONY: test
test:
	CGO_LDFLAGS="-L$(PWD)/deps/$(COS)_$(ARCH)/ -Wl,-rpath -Wl,$$ORIGIN/deps/$(COS)_$(ARCH)/" DYLD_LIBRARY_PATH=$(PWD)/deps/$(COS)_$(ARCH) LD_LIBRARY_PATH=$(PWD)/deps/$(COS)_$(ARCH) go test -tags duckdb_use_lib github.com/marcboeker/go-duckdb/... -run '^TestOpen$\' duckdb_test.go
	CGO_LDFLAGS="-L$(PWD)/deps/$(COS)_$(ARCH)/ -Wl,-rpath -Wl,$$ORIGIN/deps/$(COS)_$(ARCH)/" DYLD_LIBRARY_PATH=$(PWD)/deps/$(COS)_$(ARCH) LD_LIBRARY_PATH=$(PWD)/deps/$(COS)_$(ARCH) go test -tags duckdb_use_lib ./ -run '^TestExtensions$\' extensions_test.go

.PHONY: test.linux.arm64
test.linux.arm64: CC = aarch64-linux-gnu-gcc
test.linux.arm64: CXX = aarch64-linux-gnu-g++
test.linux.amd64:
	CGO_LDFLAGS="-L$(PWD)/deps/linux_arm64/ -Wl,-rpath -Wl,$$ORIGIN/deps/linux_arm64/" go test -tags duckdb_use_lib github.com/marcboeker/go-duckdb/... -run '^TestOpen$\' duckdb_test.go
	CGO_LDFLAGS="-L$(PWD)/deps/linux_arm64/ -Wl,-rpath -Wl,$$ORIGIN/deps/linux_arm64/" go test -tags duckdb_use_lib ./ -run '^TestExtensions$\' extensions_test.go

.PHONY: duckdb
duckdb:
	rm -rf duckdb
	git clone --depth 1 $(DUCKDB_REPO) duckdb
	cd duckdb && git fetch --depth 1 origin $(DUCKDB_REF) && git checkout $(DUCKDB_REF)
	cp extension_config_local.cmake duckdb/extension/extension_config.cmake

.PHONY: deps.header
deps.header: duckdb
	mkdir -p include
	find duckdb/extension -name '*_extension.hpp' -exec cp {} include/ \;
	cd duckdb && make extension_configuration && cd ../ && find duckdb/build/extension_configuration/_deps -name '*_extension.hpp' -exec cp {} include/ \;
	sed '/#include "duckdb\/main\/client_context.hpp"/d' include/tpcds_extension.hpp > temp_file && mv temp_file include/tpcds_extension.hpp
	cd duckdb && python3 scripts/amalgamation.py
	cp duckdb/src/amalgamation/duckdb.hpp include/


.PHONY: deps.darwin.amd64
deps.darwin.amd64: CFLAGS += -target x86_64-apple-macos11
deps.darwin.amd64: CXXFLAGS += -target x86_64-apple-macos11
deps.darwin.amd64: DEP_NAME = darwin_amd64
deps.darwin.amd64: VCPKG_TARGET_TRIPLET = x64-osx
deps.darwin.amd64: OSX_BUILD_ARCH = x86_64
deps.darwin.amd64: duckdb
	$(CHECK_DARWIN)
	$(MKDIR_COMMAND)
	$(CORE_COMMAND)

.PHONY: deps.darwin.arm64
deps.darwin.arm64: CFLAGS += -target x86_64-apple-macos11
deps.darwin.arm64: CXXFLAGS += -target x86_64-apple-macos11
deps.darwin.arm64: DEP_NAME = darwin_arm64
deps.darwin.arm64: VCPKG_TARGET_TRIPLET = arm64-osx
deps.darwin.arm64: OSX_BUILD_ARCH = arm64
deps.darwin.arm64: duckdb
	$(CHECK_DARWIN)
	$(MKDIR_COMMAND)
	$(CORE_COMMAND)

.PHONY: deps.linux.amd64
deps.linux.amd64: DEP_NAME = linux_amd64
deps.linux.amd64: VCPKG_TARGET_TRIPLET = x64-linux
deps.linux.amd64: duckdb
	$(CHECK_LINUX)
	$(MKDIR_COMMAND)
	$(CORE_COMMAND)

.PHONY: deps.linux.arm64
deps.linux.arm64: CC = aarch64-linux-gnu-gcc
deps.linux.arm64: CXX = aarch64-linux-gnu-g++
deps.linux.arm64: DEP_NAME = linux_arm64
deps.linux.arm64: VCPKG_TARGET_TRIPLET = arm64-linux
deps.linux.arm64: duckdb
	$(CHECK_LINUX)
	$(MKDIR_COMMAND)
	$(CORE_COMMAND)

