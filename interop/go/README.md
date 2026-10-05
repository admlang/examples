# Calling Go

An ADM program that uses a small Go package: it calls the package's functions, lets Go write into one of its buffers, and gives Go an array that four goroutines read.

```bash
cd interop/go
adm run
```

`@go` on the module names the folder of the package, [wordfreq.go](wordfreq.go) here: the build has `go` compile it and links it into the program with the Go runtime, which starts the first time one of its functions is called. There is nothing to build by hand; it needs `go` on `PATH`. The package is an ordinary one inside a Go module ([go.mod](go.mod)), not `package main`. A function marked `//export` keeps its name; a function declared without a body in ADM is one of them, and its types are the Go function's. From [main.adm](main.adm):

```adm
@go(".", prefix = "wordfreq_")
module wordfreq {
	def distinct(text string) int;

	def top(text string, out byte[], capacity int) int;

	@go(symbol = "wordfreq_sum_squares")
	def sumSquares(xs float[], n int) float;
}
```

| ADM | Go |
|-----|----|
| `int`, `int32`, `uint8`, … | `C.longlong`, `C.int`, `C.uchar`, … |
| `float`, `float32` | `C.double`, `C.float` |
| `string` | `*C.char`, read with `C.GoString` |
| `float[]`, `byte[]`, any array of numbers | a pointer to the elements (`*C.double`, `*C.char`), viewed with `unsafe.Slice`; pass the length as another argument |

- The folder in `@go` is relative to the source file that declares it.
- `prefix` is what the exported names start with: `distinct` is `wordfreq_distinct`. `@go(symbol = "...")` names a function that does not follow it.
- The build downloads nothing: a package with dependencies needs them in the module cache before (`go mod download`).
- The declarations are taken at their word: a type that differs from the Go function's is not reported.
- Go returns text by writing into a buffer the program owns (`top`). Memory that Go's garbage collector manages must not be kept by the program after the call returns.
- Go's runtime handles signals itself, among them the one ADM's optional preemption uses: leave `ADM_PREEMPT` unset in a program that links Go.

## Output

```
distinct     9
most common  it
sum squares  91.000000
```
