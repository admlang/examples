# Database service

A shop keeps its orders in one database and an audit trail in another. Both are held by the `Database` service, which gives each connection a name and makes it a pool that tasks share. The statements are `sql def` functions: they run on the service's connections without being handed one. The databases here are SQLite ([`adm.database.sqlite`](https://github.com/admlang/database/tree/main/sqlite)), so there is no server to run.

```bash
adm get                             # once: fetches the library adm.toml names
adm run database/service/main.adm
```

The service is started, and connections are added by URL. The name `""` is the default connection:

```adm
try await Database.start()
try Database.add("", "sqlite::memory:", 1)
try Database.add("audit", "sqlite::memory:", 1)
```

A database in memory belongs to one connection, hence the limit of 1. With a file or a server the limit is how many connections the pool may open, and tasks run side by side:

```adm
try Database.add("postgres://app:secret@db.internal/shop?sslmode=verify-full")   // the default, up to 8 connections
try Database.add("audit", "mysql://audit:secret@db.internal/audit", 4)
```

(with `adm.database.postgres` and `adm.database.mysql` in [adm.toml](adm.toml) and imported in the program).

A `sql def` outside a type runs on the default connection; `@db` names another. `{name}` is a bound argument, and the result type says how the rows are read. From [main.adm](main.adm):

```adm
module shop {
	use (
		std.data.db
		std.services.database::(Database, db)
	)

	sql def place(customer string, total float) !db.Result {
		INSERT INTO orders (customer, total) VALUES ({customer}, {total})
	}

	sql def ordersOf(customer string) !Order[] {
		SELECT * FROM orders WHERE customer = {customer} ORDER BY id
	}

	@db("audit")
	sql def record(event string) !none {
		INSERT INTO events (event) VALUES ({event})
	}
}
```

The service also runs statements itself (`Database.exec`, `Database.query`, on the default connection) and hands out a pool by name (`Database.get("audit")`), which is a `db.Connection` like any other.

Three tasks place orders at once; each statement borrows a connection from its pool and gives it back:

```adm
let a = async shop.checkout("ana", 19.90)
let b = async shop.checkout("bob", 5.25)
let c = async shop.checkout("ana", 42.00)
```

After `try await Database.stop()` the pools are closed, and a `sql def` fails with a message that says what is missing.

Output (which task gets which order number can differ from run to run):

```
connection  (default)
connection  audit
Orders from three tasks
  placed    orders 1, 2 and 3
What the databases hold
  ana       order 1: 19.90
  ana       order 3: 42.00
  revenue   67.15
  audit     3 events
  stopped   no database connection for this sql def: start the Database service and add a connection, or give the type a @connection property
```
