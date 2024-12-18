DUCKDB_REPO=https://github.com/duckdb/duckdb.git
DUCKDB_BRANCH=v1.1.1

SUBSTRAIT_REPO=https://github.com/substrait-io/duckdb-substrait-extension.git
SUBSTRAIT_BRANCH=main

CFLAGS   = -O3
CXXFLAGS = -O3
CC 		 = ""
CXX      = ""
DEP_NAME = ""

DUCKDB_COMMON_BUILD_FLAGS := BUILD_SHELL=0 BUILD_UNITTESTS=0 DUCKDB_PLATFORM=any

CHECK_DARWIN = if [ "$(shell uname -s | tr '[:upper:]' '[:lower:]')" != "darwin" ]; then echo "Error: must run build on darwin"; false; fi
CHECK_LINUX = if [ "$(shell uname -s | tr '[:upper:]' '[:lower:]')" != "linux" ]; then echo "Error: must run build on linux"; false; fi
MKDIR_COMMAND = rm -rf deps/$(DEP_NAME) && mkdir -p deps/$(DEP_NAME)

CORE_COMMAND =  \
	cd duckdb && \
	mkdir build && \
	cd build && \
	MACOSX_DEPLOYMENT_TARGET=11.0 cmake -DBUILD_EXTENSIONS="icu;parquet;tpch;tpcds;json" -DBUILD_ONLY_EXTENSIONS=TRUE .. && \
	MACOSX_DEPLOYMENT_TARGET=11.0 CC="${CC}" CXX="${CXX}" CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" ${DUCKDB_COMMON_BUILD_FLAGS} make icu_extension tpch_extension tpcds_extension json_extension parquet_extension -j 2 && \
	cd ../.. && \
	find duckdb/build/ -type f -name '*extension*.a' -exec cp {} deps/$(DEP_NAME) \;

SUBSTRAIT_COMMAND = \
	cd substrait && \
	MACOSX_DEPLOYMENT_TARGET=11.0 CC="${CC}" CXX="${CXX}" CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" ${DUCKDB_COMMON_BUILD_FLAGS} make -j 2 && \
	cd .. && \
	cp substrait/build/release/extension/substrait/libsubstrait_extension.a deps/$(DEP_NAME)

PRE_COMPILE_TARGETS :=

# Add
ifneq ($(BUILD_CORE),false)
PRE_COMPILE_TARGETS += duckdb
endif

ifneq ($(BUILD_SUBSTRAIT),false)
PRE_COMPILE_TARGETS += substrait
endif

define get_build_commands
$(MKDIR_COMMAND)
$(if $(filter TRUE,$(or $(BUILD_CORE),TRUE)), $(CORE_COMMAND))
$(if $(filter TRUE,$(or $(BUILD_SUBSTRAIT),TRUE)), $(SUBSTRAIT_COMMAND))
endef

.PHONY: duckdb
duckdb:
	rm -rf duckdb
	git clone -b $(DUCKDB_BRANCH) --depth 1 $(DUCKDB_REPO)

.PHONY: substrait
substrait:
	rm -rf substrait
	git clone -b $(SUBSTRAIT_BRANCH) --depth 1 $(SUBSTRAIT_REPO) --recurse-submodules substrait

.PHONY: deps.header
deps.header: duckdb substrait
	mkdir -p include
	cp substrait/src/include/substrait_extension.hpp include/
	cp duckdb/extension/icu/include/icu_extension.hpp include/
	cp duckdb/extension/json/include/json_extension.hpp include/
	cp duckdb/extension/tpch/include/tpch_extension.hpp include/
	cp duckdb/extension/tpcds/include/tpcds_extension.hpp include/
	cp duckdb/extension/parquet/include/parquet_extension.hpp include/
	sed '/#include "duckdb\/main\/client_context.hpp"/d' include/tpcds_extension.hpp > temp_file && mv temp_file include/tpcds_extension.hpp
	cd duckdb && python3 scripts/amalgamation.py
	cp duckdb/src/amalgamation/duckdb.hpp include/


.PHONY: deps.darwin.amd64
deps.darwin.amd64: CC = clang
deps.darwin.amd64: CXX = clang++
deps.darwin.amd64: CFLAGS += -target x86_64-apple-macos11
deps.darwin.amd64: CXXFLAGS += -target x86_64-apple-macos11
deps.darwin.amd64: DEP_NAME = darwin_amd64
deps.darwin.amd64: $(PRE_COMPILE_TARGETS)
	$(CHECK_DARWIN)
	$(get_build_commands)

.PHONY: deps.darwin.arm64
deps.darwin.arm64: CC = clang
deps.darwin.arm64: CXX = clang++
deps.darwin.arm64: CFLAGS += -target arm64-apple-macos11
deps.darwin.arm64: CXXFLAGS += -target arm64-apple-macos11
deps.darwin.arm64: DEP_NAME = darwin_arm64
deps.darwin.arm64: $(PRE_COMPILE_TARGETS)
	$(CHECK_DARWIN)
	$(get_build_commands)

.PHONY: deps.linux.amd64
deps.linux.amd64: DEP_NAME = linux_amd64
deps.linux.amd64: $(PRE_COMPILE_TARGETS)
	$(CHECK_LINUX)
	$(get_build_commands)

.PHONY: deps.linux.arm64
deps.linux.arm64: CC = aarch64-linux-gnu-gcc
deps.linux.arm64: CXX = aarch64-linux-gnu-g++
deps.linux.arm64: DEP_NAME = linux_arm64
deps.linux.arm64: $(PRE_COMPILE_TARGETS)
	$(CHECK_LINUX)
	$(get_build_commands)

