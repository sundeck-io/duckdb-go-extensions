
if (NOT MINGW)
    duckdb_extension_load(jemalloc)
endif()
duckdb_extension_load(core_functions)
duckdb_extension_load(json)
duckdb_extension_load(parquet)
duckdb_extension_load(icu)
duckdb_extension_load(aws
    GIT_URL https://github.com/duckdb/duckdb-aws
    GIT_TAG f92dc8e59a6259bcff2710cab785c983c93cb1cd
)
duckdb_extension_load(httpfs
    GIT_URL https://github.com/duckdb/duckdb-httpfs
    GIT_TAG cf3584b48ddabdfb58ef69d2649896da2e466405
    INCLUDE_DIR extension/httpfs/include
)
duckdb_extension_load(tpch)
duckdb_extension_load(tpcds)
duckdb_extension_load(substrait
    GIT_URL https://github.com/substrait-io/duckdb-substrait-extension
    GIT_TAG c7615b2813a4551b1057591f7c2889f7ec86690b
)
duckdb_extension_load(iceberg
    GIT_URL https://github.com/scgkiran/duckdb-iceberg
    GIT_TAG 46bfced3089e228cc3c3f316315d0e915cc646ec
)
