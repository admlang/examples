# Calling Java

A shop keeps its pricing rules in a Java class, and the ADM program calls its static methods like its own functions. Java's arrays and strings arrive as ADM's, a `null` as none, and an exception as an error. Java runs on the [`adm.interop.java`](https://github.com/admlang/interop/tree/main/java) library, which loads the Java VM of the installed JDK or JRE into the program.

```bash
adm get                             # once: fetches the library adm.toml names
javac interop/java/Pricing.java
adm run interop/java/main.adm
```

[adm.toml](adm.toml) lists the library under `[deps]`; without it `@java` and `java.runtime()` do not exist. Running the program needs Java 8 or later (`JAVA_HOME`, or `java` on `PATH`); building it needs nothing of Java.

[Pricing.java](Pricing.java) is an ordinary class. A function declared without a body under `@java` is the static method of the same name, and its types are the Java method's. From [main.adm](main.adm):

```adm
module pricing {
	use adm.interop.java::*

	@java("Pricing")
	def total(prices float[], quantities int32[], customer string) !float;

	@java("Pricing")
	def coupon(code string) !?string;

	@java("Pricing", method = "check")
	def checkOrder(total float) !none;
}
```

```adm
try java.runtime().start(classPath = ["interop/java"])
println("total     {try pricing.total(prices, quantities, customer)}")
```

| ADM | Java |
|-----|------|
| `bool` | `boolean` |
| `int8`, `int16`, `int32`, `int` | `byte`, `short`, `int`, `long` |
| `float32`, `float` | `float`, `double` |
| `string` | `String` |
| `float[]`, `int32[]`, `string[]`, … | `double[]`, `int[]`, `String[]`, … |

- `java.runtime()` is the program's Java VM, and its `start` gives it the class path: folders of `.class` files and `.jar` files. A program has one Java VM, started once.
- `?string` takes Java's `null` as none, as `coupon` does. Without the `?`, a null fails the call.
- A Java exception fails the call with a `java.ScriptError`, which has the stack trace and the exception itself as a value: `thrown.invoke("getMessage")` calls it.
- `method = "check"` names the Java method when the declaration cannot have its name: `check` is a keyword in ADM.

Java objects are made and called through the same runtime, and an ADM function goes where Java takes an interface. The program fills a `java.util.ArrayList` and has Java sort it with an ADM function as the `Comparator`:

```adm
let vm = java.runtime()
let names = try (try vm.load("java.util.ArrayList")).construct()
try names.invoke("add", "pear")
let byLength = try vm.function(def (args java.Value[]) !java.Value {
	return try vm.value((try args[0].asString()).len() - (try args[1].asString()).len())
})
try names.invoke("sort", byLength)
```

## Output

```
labels    EUR 19.90, EUR 5.00, EUR 120.00
discount  0.150000
total     140.080000
coupon    10% off the first order
coupon    none for SUMMER
refused   java: java.lang.IllegalArgumentException: orders start at 10.00, this one is 4.5
          Java says: orders start at 10.00, this one is 4.5
sorted    [fig, pear, banana]
```
