# Calling Rust

An ADM program that uses a small Rust crate: it calls the crate's functions, lets Rust write into one of its buffers and read one of its arrays, and hands Rust a function to call back.

```bash
cd interop/rust
adm run
```

`@rust` on the module names the crate's folder, the one with [Cargo.toml](Cargo.toml): the build has cargo compile the crate and links it into the program, so there is nothing to build by hand. It needs `cargo` on `PATH`. The crate is an ordinary library crate. Each function the program calls is `extern "C"` and `#[no_mangle]`, so it has the C calling convention and keeps its name. A function declared without a body in ADM is one of them, and its types are the Rust function's. From [main.adm](main.adm):

```adm
@rust(".", prefix = "text_")
module textstats {
	def words(text string) int;

	def longest(text string, out byte[], capacity int) int;

	@rust(symbol = "text_count_if")
	def countIf(text string, keep def(string) bool) int;

	@rust(symbol = "stats_median")
	def median(xs float[], n int) float;
}
```

```adm
let short = textstats.countIf(text, (word) => word.len() <= 3)
```

| ADM | Rust |
|-----|------|
| `int`, `int32`, `uint8`, … | `i64`, `i32`, `u8`, … |
| `float`, `float32` | `f64`, `f32` |
| `bool` | `bool` |
| `string` | `*const c_char` |
| `float[]`, `byte[]`, any array of numbers | a pointer to the elements (`*const f64`, `*mut u8`); pass the length as another argument |
| `def(string) bool` | `extern "C" fn(*const c_char) -> bool` |

- The path in `@rust` is relative to the source file that declares it. It can also be one `.rs` file, which needs no Cargo.toml and takes no crate attributes (`#![...]`).
- `prefix` is what the exported names start with: `words` is `text_words`. `@rust(symbol = "...")` names a function that does not follow it.
- cargo downloads nothing during the build: a crate with dependencies needs them fetched before (`cargo fetch`).
- The declarations are taken at their word: a type that differs from the Rust function's is not reported.
- Rust returns text by writing into a buffer the program owns (`longest`), or by returning a string that lives as long as the program (`version`). A `String` Rust allocates cannot cross as it is: the program would have no way to free it.
- A panic in Rust ends the program: it cannot unwind into ADM.

## Output

```
textstats 1.0
words    10
longest  extraordinarily
short    4
median   5.000000
```
