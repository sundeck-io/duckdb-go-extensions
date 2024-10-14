package duckdb_go_extensions

import (
	"database/sql"
	"github.com/marcboeker/go-duckdb"
	"github.com/stretchr/testify/require"
	"testing"
)

func TestLoaded(t *testing.T) {
	conn, err := duckdb.NewConnector("", nil)
	require.NoError(t, err)

	db := sql.OpenDB(conn)
	require.NoError(t, db.Ping())

	require.NoError(t, LoadExtensions(conn))
}
