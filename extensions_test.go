package duckdb_go_extensions

import (
	"database/sql"
	_ "github.com/marcboeker/go-duckdb"
	"github.com/stretchr/testify/require"
	"testing"
)

func TestExtensions(t *testing.T) {
	t.Parallel()

	t.Run("with config", func(t *testing.T) {
		db, err := sql.Open("duckdb", "?access_mode=read_write&threads=4")
		require.NoError(t, err)
		defer db.Close()

		var (
			substrait string
			ak        any
			sk        any
			st        any
			r         any
			sz        int
		)
		res := db.QueryRow("call get_substrait('select 1')")
		require.NoError(t, res.Scan(&substrait))
		require.Equal(t, "\x1a\"\x12 \n\x1b:\x19\n\x05\x12\x03\n\x01\x01\x12\n\n\b*\x06\n\x04\n\x02(*\x1a\x04\n\x02(\x01\x12\x0112\n\x105*\x06DuckDB", substrait)
		res = db.QueryRow("call load_aws_credentials('foo')")
		require.NoError(t, res.Scan(&ak, &sk, &st, &r))
		// dont check the actual values, just check that there is no error
		res = db.QueryRow("SELECT count(*) FROM 'https://localhost/file.parquet'")
		err = res.Scan(&sz)
		require.ErrorContains(t, err, "IO Error: Could not establish connection")
		res = db.QueryRow("SELECT count(*) FROM iceberg_scan('data/iceberg/lineitem_iceberg', allow_moved_paths = true);")
		err = res.Scan(&sz)
		require.ErrorContains(t, err, "IO Error: Cannot open \"data/iceberg/lineitem_iceberg\"")
	})
}
