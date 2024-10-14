//go:build darwin || (linux && (amd64 || arm64))

package duckdb_go_extensions

import "C"
import (
	"github.com/marcboeker/go-duckdb"
	"reflect"
	"unsafe"
)

/*
 #cgo CXXFLAGS: -I${SRCDIR}/include -std=c++11
 #include "wrapper.h"
 #include <stdint.h>
 extern int32_t icecap_dynamic_int32(char* name, char* args);
 extern char* icecap_dynamic_string(char* name, char* args);
*/
import "C"

func LoadExtensions(conn *duckdb.Connector) error {
	connectorValue := reflect.ValueOf(conn)
	dbField := reflect.Indirect(connectorValue).FieldByName("db")
	dbField = reflect.NewAt(dbField.Type(), unsafe.Pointer(dbField.UnsafeAddr())).Elem()
	ptr := dbField.UnsafePointer()
	C.init_extensions_c(ptr)
	return nil
}
