# Calling .NET

A shop keeps its pricing rules in a C# class, and the ADM program calls its static methods like its own functions. .NET's arrays and strings arrive as ADM's, a `null` as none, and an exception as an error. .NET runs on the [`adm.interop.dotnet`](https://github.com/admlang/interop/tree/main/dotnet) library, which loads the installed .NET runtime into the program.

```bash
adm get                             # once: fetches the library adm.toml names
dotnet build interop/dotnet -o interop/dotnet/bin
adm run interop/dotnet/main.adm
```

[adm.toml](adm.toml) lists the library under `[deps]`; without it `@dotnet` and `dotnet.runtime()` do not exist. Running the program needs a .NET runtime, version 8 or later; building it needs nothing of .NET.

[Pricing.cs](Pricing.cs) is an ordinary class with no attribute on it. A function declared without a body under `@dotnet` is the static method of the same name with a capital first letter, and its types are the method's. From [main.adm](main.adm):

```adm
module pricing {
	use adm.interop.dotnet::*

	@dotnet("Shop.Pricing")
	def total(prices float[], quantities int32[], customer string) !float;

	@dotnet("Shop.Pricing")
	def coupon(code string) !?string;

	@dotnet("Shop.Pricing", method = "Check")
	def checkOrder(total float) !none;
}
```

```adm
try dotnet.runtime().start(folders = ["interop/dotnet/bin"])
println("total     {try pricing.total(prices, quantities, customer)}")
```

| ADM | .NET |
|-----|------|
| `bool` | `bool` |
| `int8`, `int16`, `int32`, `int` | `sbyte`, `short`, `int`, `long` |
| `byte`, `uint16`, `uint32`, `uint` | `byte`, `ushort`, `uint`, `ulong` |
| `float32`, `float` | `float`, `double` |
| `string` | `string` |
| `float[]`, `int32[]`, `string[]`, … | `double[]`, `int[]`, `string[]`, … |

- `dotnet.runtime()` is the program's .NET runtime, and its `start` names the folders assemblies (`.dll` files) are loaded from. A program has one .NET runtime, started once.
- `?string` takes `null` as none, as `coupon` does. Without the `?`, a null fails the call.
- A .NET exception fails the call with a `dotnet.ScriptError`, which has the stack trace and the exception itself as a value: `thrown.get("Message")` reads its property.
- `method = "Check"` names the method when the declaration cannot have its name: `check` is a keyword in ADM.

.NET objects are made and called through the same runtime, and an ADM function goes where .NET takes a delegate. The program fills a `List<string>` and has .NET sort it with an ADM function as the `Comparison<string>`:

```adm
let clr = dotnet.runtime()
let names = try (try clr.load("System.Collections.Generic.List`1[System.String]")).construct()
try names.invoke("Add", "pear")
let byLength = try clr.function(def (args dotnet.Value[]) !dotnet.Value {
	return try clr.value((try args[0].asString()).len() - (try args[1].asString()).len())
})
try names.invoke("Sort", byLength)
```

## Output

```
labels    EUR 19.90, EUR 5.00, EUR 120.00
discount  0.150000
total     140.080000
coupon    10% off the first order
coupon    none for SUMMER
refused   dotnet: System.ArgumentException: orders start at 10.00, this one is 4.5
          .NET says: orders start at 10.00, this one is 4.5
sorted    fig, pear, banana
```
