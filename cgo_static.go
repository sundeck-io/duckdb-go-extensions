//go:build darwin || (linux && (amd64 || arm64))

package duckdb_go_extensions

////-lsubstrait_extension
/*
#cgo LDFLAGS: -licu_extension -ltpch_extension -ltpcds_extension -lsubstrait_extension -lparquet_extension -lduckdb_mbedtls
#cgo darwin,amd64 LDFLAGS: -lc++ -L${SRCDIR}/deps/darwin_amd64
#cgo darwin,arm64 LDFLAGS: -lc++ -L${SRCDIR}/deps/darwin_arm64
#cgo linux,amd64 LDFLAGS: -lstdc++ -lm -ldl -L${SRCDIR}/deps/linux_amd64
#cgo linux,arm64 LDFLAGS: -lstdc++ -lm -ldl -L${SRCDIR}/deps/linux_arm64
*/
import "C"
