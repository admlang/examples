# Calling Zig

An ADM program that uses a small Zig library: it calls the library's functions, lets Zig write into one of its arrays, and hands Zig a function to call back.

```bash
cd interop/zig
adm run
```

`@zig` on the module names [numbers.zig](numbers.zig): the build compiles the file with `zig` and links it into the program, so there is nothing to build by hand. It needs `zig` on `PATH`. A function marked `export` in Zig has the C calling convention and keeps its name. A function declared without a body in ADM is one of them, and its types are the Zig function's. From [main.adm](main.adm):

```adm
@zig("numbers.zig", prefix = "numbers_")
module numbers {
	def hash(data byte[], n uint) uint;

	def primes(out uint32[], capacity uint) uint;

	def collatz(start uint, visit def(uint)) int;
}
```

```adm
let highest uint = 0
let steps = numbers.collatz(27, (value) => {
	highest = value when value > highest
})
```

| ADM | Zig |
|-----|-----|
| `int`, `int32`, `uint8`, … | `i64`, `i32`, `u8`, … |
| `uint` | `u64`, `usize` |
| `float`, `float32` | `f64`, `f32` |
| `bool` | `bool` |
| `string` | `[*:0]const u8` |
| `uint32[]`, `byte[]`, any array of numbers | a pointer to the elements (`[*]u32`, `[*]const u8`); pass the length as another argument |
| `def(uint)` | `*const fn (u64) callconv(.c) void` |

- The path in `@zig` is relative to the source file that declares it.
- `prefix` is what the exported names start with: `hash` is `numbers_hash`. `@zig(symbol = "...")` on a function names an export that does not follow it.
- The declarations are taken at their word: a type that differs from the Zig function's is not reported.
- A function passed to Zig is callable until the Zig call returns, and it can use the variables around it, as `highest` above.

## Output

```
numbers 1.0
hash     2819B508FD855C1F
primes   [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
collatz  27 reaches 1 in 111 steps, as high as 9232
```
