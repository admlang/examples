# SQLite

A small library of books kept in SQLite. The program runs statements with bound arguments, reads rows into structs, wraps two inserts in a transaction, tells a failure apart by its kind, and then does the same work through `sql def` methods. SQLite comes from the [`adm.database.sqlite`](https://github.com/admlang/database/tree/main/sqlite) library and is compiled into the program, so there is no server to run.

```bash
adm get                             # once: fetches the library adm.toml names
adm run database/sqlite/main.adm
```

[adm.toml](adm.toml) lists the driver under `[deps]`. Importing it is what makes the `sqlite:` scheme known to `db.connect`; with `adm.database.postgres` or `adm.database.mysql` the same program talks to those servers, the placeholders in the plain statements aside (`$1` for PostgreSQL).

The plain API, from [main.adm](main.adm):

```adm
let conn = try db.connect("sqlite::memory:?foreign_keys=on")

let res = try conn.exec("INSERT INTO books (title, author, published, added) VALUES (?, ?, ?, ?)", "Dune", "Frank Herbert", 1965, now)

let rows = try conn.query("SELECT title, published, rating FROM books WHERE published < ?", 1970)
for try rows.next() {
	println("{try rows.int(1)}  {try rows.string(0)}")
}

let all = try db.readAll<Book>(try conn.query("SELECT * FROM books ORDER BY id"))
```

A struct says how its fields sit in a row, and its values serve as named arguments:

```adm
struct Book {
	id     int
	title  string
	author string
	@db.column("published")
	year   int
	rating ?float
	@db.column(stored = db.Stored.Text)
	added  time.Time
}

try conn.exec("INSERT INTO books (id, title, author, published, rating, added) VALUES (:id, :title, :author, :published, :rating, :added)", db.values(book))
```

A `sql def` is a statement as a method. `{name}` is a bound argument, and the result type says how the rows are read:

```adm
type Shelf {
	@db.connection()
	conn db.Queryable

	sql def find(id int) !?Book {
		SELECT * FROM books WHERE id = {id}
	}

	sql def best() !(string, float) {
		SELECT title, rating FROM books WHERE rating IS NOT NULL ORDER BY rating DESC LIMIT 1
	}
}
```

Output:

```
SQLite 3.53.4, drivers: sqlite, sqlite3
Statements with arguments
  inserted  1 row, id 1
Reading rows
  1961  Solaris (4.5)
  1965  Dune (not rated)
  1965  The Cyberiad (not rated)
  4 books, the first added 2026-10-06T05:11:23.527690279Z
A failure
  Constraint: sqlite: UNIQUE constraint failed: books.title (SQLite code 2067)
Statements as methods
  books     4
  authors   Frank Herbert, Stanisław Lem
  best      Dune (4.8)
  by Lem    1961 Solaris
  by Lem    1965 The Cyberiad
  book 99   not on the shelf
```
