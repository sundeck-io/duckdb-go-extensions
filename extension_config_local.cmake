
if (NOT MINGW)
    duckdb_extension_load(jemalloc)
endif()
duckdb_extension_load(core_functions)
duckdb_extension_load(json)
duckdb_extension_load(parquet)
duckdb_extension_load(icu)
duckdb_extension_load(aws
    GIT_URL https://github.com/duckdb/duckdb-aws
    GIT_TAG ${DUCKDB_AWS_REF}
)
duckdb_extension_load(httpfs
    GIT_URL https://github.com/duckdb/duckdb-httpfs
    GIT_TAG ${DUCKDB_HTTPFS_REF}
    INCLUDE_DIR extension/httpfs/include
)
duckdb_extension_load(tpch)
duckdb_extension_load(tpcds)
duckdb_extension_load(substrait
    GIT_URL https://github.com/substrait-io/duckdb-substrait-extension
    GIT_TAG ${DUCKDB_SUBSTRAIT_REF}
)
duckdb_extension_load(iceberg
    GIT_URL https://github.com/duckdb/duckdb-iceberg
    GIT_TAG ${DUCKDB_ICEBERG_REF}
)
