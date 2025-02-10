
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
    GIT_TAG 85ac4667bcb0d868199e156f8dd918b0278db7b9
    INCLUDE_DIR extension/httpfs/include
)
duckdb_extension_load(tpch)
duckdb_extension_load(tpcds)
duckdb_extension_load(substrait
    GIT_URL https://github.com/substrait-io/duckdb-substrait-extension
    GIT_TAG a1b341cc3df16c55535c12acce375040ffe50347
)
duckdb_extension_load(iceberg
    GIT_URL https://github.com/duckdb/duckdb-iceberg
    GIT_TAG 3060b30309d82f1059c928de7280286fcf800545
)
