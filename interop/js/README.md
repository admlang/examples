# JavaScript

A shop keeps its pricing rules in a JavaScript file, and the ADM program calls them like its own functions. The example also gives the script a function to call back, and runs a second, limited engine for a script the program does not trust. JavaScript runs on the [`adm.interop.js`](https://github.com/admlang/interop/tree/main/js) library (QuickJS), which is compiled into the program.

```bash
adm get                             # once: fetches the library adm.toml names
adm run interop/js/main.adm
```

[adm.toml](adm.toml) lists the library under `[deps]`; without it `@js` and `js.Runtime` do not exist.

[pricing.js](pricing.js) is an ordinary ES module. A function declared without a body under `@js` is the export of the same name; the file is embedded in the program when it is built. From [main.adm](main.adm):

```adm
module shop {
	use adm.interop.js::*

	struct Item {
		name     string
		price    float
		quantity int
	}

	@js("pricing.js")
	def total(items Item[]) float;

	@js("pricing.js")
	def discount(amount float, code string) !float;
}
```

```adm
println(shop.total(cart))

shop.discount(10.0, "FREE") onerror (err error) {
	println(err.message)        // js: RangeError: unknown discount code FREE
	recover 0.0
}
```

- Structs reach the script as plain objects, an absent `?string` as `null`, `float[]` as a `Float64Array` over the caller's own array (`roundAll` rounds it in place), and a script that throws fails an errorable declaration.
- The declarations run in one engine, `js.runtime()`. The program sets `audit` on its global object, and `checkout` in the script calls it.
- `new js.Runtime(memoryLimit = …, timeout = …)` is a separate engine for a script that arrives at run time: `eval` runs it, and a script that never ends is stopped.

## Output

```
Typed declarations
  total     25.50
  lines     3 x notebook, 10 x pen
  SPRING    2.55 off
  FREE      js: RangeError: unknown discount code FREE
  rounded   3 prices in place: 4.5, 1.2, 10
A function for the script
  audit     checkout of 2 lines, 5.10 off
  to pay    20.40
  audit     checkout of 2 lines, 0.00 off
  no code   25.50
A second engine with limits
  eval      1 4 9
  runaway   js: the script ran longer than its timeout
```
