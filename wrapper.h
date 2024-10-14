#pragma once
// This is a shim interface such that compilation the go compilation does not
// include the duckdb c++ headers (I think.). They conflict with the duckdb
// headers included in the duckdb module. They should only be loaded when doing
// c++ compilation, not when doing go compilation (which needs this header to
// validate the C.* invocations).
#ifdef __cplusplus
extern "C" {
#endif

void init_extensions_c(void * ptr);

#ifdef __cplusplus
}
#endif
