DUCKDB_REPO=https://github.com/duckdb/duckdb.git
DUCKDB_BRANCH=v1.1.1

CFLAGS   = -O3
CXXFLAGS = -O3
CC 		 = ""
CXX      = ""
DEPS_PATH = ""

DUCKDB_COMMON_BUILD_FLAGS := BUILD_SHELL=0 BUILD_UNITTESTS=0 DUCKDB_PLATFORM=any
CHECK_DARWIN = if [ "$(shell uname -s | tr '[:upper:]' '[:lower:]')" != "darwin" ]; then echo "Error: must run build on darwin"; false; fi
CHECK_LINUX = if [ "$(shell uname -s | tr '[:upper:]' '[:lower:]')" != "linux" ]; then echo "Error: must run build on linux"; false; fi
WORK_COMMAND =  \
	mkdir -p deps/$(DEPS_PATH) && \
	cd duckdb && \
	mkdir build && \
	cd build && \
	cmake -DBUILD_EXTENSIONS="icu;parquet;tpch;tpcds;json" -DBUILD_ONLY_EXTENSIONS=TRUE .. && \
	CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" CC="${CC}" CXX="${CXX}" make icu_extension tpch_extension tpcds_extension json_extension parquet_extension -j 2 && \
	cd ../.. && \
	find duckdb/build/ -type f -name '*extension*.a' -exec cp {} deps/$(DEPS_PATH) \;

.PHONY: duckdb
duckdb:
	rm -rf duckdb
	git clone -b $(DUCKDB_BRANCH) --depth 1 $(DUCKDB_REPO)

.PHONY: deps.darwin.amd64
deps.darwin.amd64: CFLAGS += -target x86_64-apple-macos11
deps.darwin.amd64: CXXFLAGS += -target x86_64-apple-macos11
deps.darwin.amd64: DEPS_PATH = darwin_amd64
deps.darwin.amd64: duckdb
	$(CHECK_DARWIN)
	$(WORK_COMMAND)

.PHONY: deps.darwin.arm64
deps.darwin.arm64: CFLAGS += -target arm64-apple-macos11
deps.darwin.arm64: CXXFLAGS += -target arm64-apple-macos11
deps.darwin.arm64: DEPS_PATH = darwin_arm64

deps.darwin.arm64: duckdb
	$(CHECK_DARWIN)
	$(WORK_COMMAND)

.PHONY: deps.linux.amd64
deps.linux.amd64: DEPS_PATH = linux_amd64
deps.linux.amd64: duckdb
	$(CHECK_LINUX)
	$(WORK_COMMAND)

.PHONY: deps.linux.arm64
deps.linux.arm64: CC = aarch64-linux-gnu-gcc
deps.linux.arm64: CXX = aarch64-linux-gnu-g++
deps.linux.arm64: DEPS_PATH = linux_arm64
deps.linux.arm64: duckdb
	$(CHECK_LINUX)
	$(WORK_COMMAND)
