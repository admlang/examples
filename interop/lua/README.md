# Lua

A shop keeps its customer rules in a Lua file, and the ADM program calls them like its own functions. One of them returns a table that arrives as an ADM struct. The example also gives the script a function to call back, and runs a second, limited engine for a script the program does not trust. Lua runs on the [`adm.interop.lua`](https://github.com/admlang/interop/tree/main/lua) library (Lua 5.4), which is compiled into the program.

```bash
adm get                             # once: fetches the library adm.toml names
adm run interop/lua/main.adm
```

[adm.toml](adm.toml) lists the library under `[deps]`; without it `@lua` and `lua.Runtime` do not exist.

[rules.lua](rules.lua) is a Lua module: it returns a table of functions. A function declared without a body under `@lua` is the function of the same name in that table; the file is embedded in the program when it is built. From [main.adm](main.adm):

```adm
module rules {
	use adm.interop.lua::*

	struct Customer {
		name   string
		years  int
		orders int
	}

	struct Badge {
		title string
		perks string[]
	}

	@lua("rules.lua")
	def discount(customer Customer) float;

	@lua("rules.lua")
	def badge(customer Customer) Badge;

	@lua("rules.lua")
	def shipping(country string, weight float) !float;
}
```

```adm
let badge = rules.badge(ada)
println("{badge.title}: {badge.perks.join(", ")}")

rules.shipping("MARS", 1.0) onerror (err error) {
	println(err.message)        // lua: no shipping to MARS
	recover 0.0
}
```

- A struct reaches the script as a table, and a table the script returns fills the declared struct, field by field. A script that raises an error fails an errorable declaration.
- The declarations run in one engine, `lua.runtime()`. The program sets `audit` in its table of globals, and `welcome` in the script calls it.
- `new lua.Runtime(memoryLimit = …, timeout = …)` is a separate engine for a script that arrives at run time: `eval` runs it, and a script that never ends is stopped.

## Output

```
Typed declarations
  discount  Ada 0.15, Bob 0.05
  badge     Ada (gold): newsletter, free shipping
  to RO     7.50
  to MARS   lua: no shipping to MARS
A function for the script
  audit     welcome mail for Bob
  letters   3
A second engine with limits
  eval      1 4 9
  runaway   lua: the script ran longer than its timeout
```
