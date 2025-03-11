
if (NOT MINGW)
    duckdb_extension_load(jemalloc)
endif()
duckdb_extension_load(core_functions)
duckdb_extension_load(json)
duckdb_extension_load(parquet)
duckdb_extension_load(icu)
duckdb_extension_load(aws
    GIT_URL https://github.com/sundeck-io/duckdb-aws
    GIT_TAG 49537b352be2f02947a9c785b6a6679601c96e6f
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
    GIT_TAG 4dcd319a929e2beaca78be6363202ecbaf081dc6
)
duckdb_extension_load(iceberg
    GIT_URL https://github.com/duckdb/duckdb-iceberg
    GIT_TAG 3060b30309d82f1059c928de7280286fcf800545
)
