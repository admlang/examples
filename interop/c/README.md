# Calling C

An ADM program that uses a small C library: it calls the library's functions and one from the C math library, lets C write into one of its arrays, and hands C a function to call back.

```bash
adm run interop/c/main.adm
```

[stats.c](stats.c) sits beside the program, so it is compiled and linked with it; nothing else is set up. A function declared without a body is implemented in C, and its types are the C prototype's. From [main.adm](main.adm):

```adm
@link("m")
module measure {
	@c(symbol = "stats_mean")
	def mean(xs float[], n int) float;

	@c(symbol = "stats_count_if")
	def countIf(xs float[], n int, keep def(float) bool) int;

	def cbrt(x float) float;
}
```

```adm
let above = measure.countIf(samples, samples.len(), (x) => x > limit)
```

| ADM | C |
|-----|---|
| `int`, `int32`, `uint8`, … | `int64_t`, `int32_t`, `uint8_t`, … |
| `float`, `float32` | `double`, `float` |
| `bool` | `bool` |
| `string` | `const char*` |
| `float[]`, `byte[]`, any array of numbers | a pointer to the elements; pass the length as another argument |
| `def(float) bool` | a function pointer, `bool (*)(double)` |

- `@link("m")` on the module adds a library to the link (`-lm`); `@c(symbol = "…")` binds a declaration to a C function with another name; without it the C function has the declaration's name, as `cbrt` does.
- A function passed to C is callable until the C call returns. A C library that keeps the function for later marks the parameter `@callback`.

## Output

```
stats 1.0
mean       5.000000
deviation  2.000000
cbrt(27)   3.000000
above 4.500000  4
halved     [1.000000, 2.000000, 2.000000, 2.000000, 2.500000, 2.500000, 3.500000, 4.500000]
```
