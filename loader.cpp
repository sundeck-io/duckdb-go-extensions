#include "include/duckdb.hpp"
#include "include/icu_extension.hpp"
#include "include/substrait_extension.hpp"
#include "include/tpcds_extension.hpp"
#include "include/tpch_extension.hpp"
#include "include/iceberg_extension.hpp"

// this is a copy of an internal duckdb structure as we need it to convert the c handle to a C++ handle.
// Original structure is here: https://github.com/duckdb/duckdb/blob/main/src/include/duckdb/main/capi/capi_internal.hpp#L31
struct DatabaseData {
	duckdb::unique_ptr<duckdb::DuckDB> database;
};

extern "C" {

void init_extensions(void * db) {
    auto duck = reinterpret_cast<DatabaseData*>(db);
    printf("Loading Extensions... [");

    duckdb::SubstraitExtension sub;
    sub.Load(*duck->database);
    printf("substrait ");

    duckdb::IcuExtension icu;
    icu.Load(*duck->database);
    printf("icu ");

    duckdb::TpcdsExtension tpcds;
    tpcds.Load(*duck->database);
    printf("tpcds ");

    duckdb::TpchExtension tpch;
    tpch.Load(*duck->database);
    printf("tpch ");

    duckdb::IcebergExtension iceberg;
    iceberg.Load(*duck->database);
    printf("iceberg]\n");
}

}
