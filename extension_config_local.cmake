
if (NOT MINGW)
    duckdb_extension_load(jemalloc)
endif()
duckdb_extension_load(core_functions)
duckdb_extension_load(json)
duckdb_extension_load(parquet)
duckdb_extension_load(icu)
duckdb_extension_load(aws
    GIT_URL https://github.com/duckdb/duckdb-aws
    GIT_TAG b3050f35c6e99fa35465230493eeab14a78a0409
)
duckdb_extension_load(httpfs
    GIT_URL https://github.com/duckdb/duckdb-httpfs
    GIT_TAG 84fb5f0c38b3ed7ce32420e073c280d4c264f3e8
    INCLUDE_DIR extension/httpfs/include
)
duckdb_extension_load(tpch)
duckdb_extension_load(tpcds)
duckdb_extension_load(substrait
    GIT_URL https://github.com/rymurr/duckdb-substrait-extension
    GIT_TAG 23ffe479c9d4500f42decf4c50cc5fcf15588bd7
)
duckdb_extension_load(iceberg
    GIT_URL https://github.com/duckdb/duckdb-iceberg
    GIT_TAG 3060b30309d82f1059c928de7280286fcf800545
)
