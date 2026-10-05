# ADM examples

Example programs for the [ADM programming language](https://adm-lang.dev), grouped by category.

## Running an example

Install ADM from [adm-lang.dev](https://adm-lang.dev), clone this repository, and run an example from the repository root:

## Examples

### AI

| Example | Description |
|---------|-------------|
| [chat](ai/chat) | Chats with a GGUF language model in the terminal, with optional reasoning output and tool calls. |
| [classifier](ai/classifier) | CClassifies a support ticket with a decision model (Bespoke Nimble, or any chat model): typed questions answered with probabilities and other no text generated.|

### Devices

| Example | Description |
|---------|-------------|
| [camera](devices/camera) | Takes one picture with the first camera and saves it as a JPEG. |
| [list](devices/list) | Prints the devices of this computer: kind, name, USB identifiers, bus and node. |
| [microphone](devices/microphone) | Records three seconds from a microphone and plays them back. |
| [securitykey](devices/securitykey) | Registers a FIDO2 security key for a made-up site and signs in with it, as a browser and a server would. |
| [speakers](devices/speakers) | Plays a one-second tone on every speaker. |

### Encoding

| Example | Description |
|---------|-------------|
| [barcodes](encoding/barcodes) | Makes a barcode of every kind (QR, Data Matrix, Aztec, PDF417, EAN, UPC, Code 128 and more), saves each as an image and reads it back. |
| [formats](encoding/formats) | Writes one record as JSON, YAML, TOML, MessagePack and CBOR, reads it back, and writes bytes as hex, Base64 and Base32. |

### Graphics

| Example | Description |
|---------|-------------|
| [analysis](gfx/analysis) | Runs every image analysis on one picture: subject, colours, brightness, BlurHash, perceptual hashes and keypoints. |
| [canvas-showcase](gfx/canvas-showcase) | 2D canvas API showcase: paths, borders, gradients, compositing, effects, layers, text, pictures, sprites and mesh warps. |
| [filters](gfx/filters) | Applies every image filter (grayscale, blur, sepia, hue, threshold and more) to one picture, with and without a mask. |
| [gif-frames](gfx/gif-frames) | Splits an animated GIF into one PNG per frame and prints each frame's delay. |
| [gpu_canvas](gfx/gpu_canvas) | An animated scene drawn on the GPU in a window, with a shader written in ADM. |
| [icon-sizes](gfx/icon-sizes) | Lists the images inside an icon or cursor file and writes the icon at a chosen size. |
| [image-convert](gfx/image-convert) | Reads an image in one format and saves it in another, picked by the output file's extension. |
| [psd-layers](gfx/psd-layers) | Lists the layers of a Photoshop document and saves each visible layer as its own image. |
| [seam-carving](gfx/seam-carving) | Resizes an image with seam carving, which removes the least important paths of pixels so the subject keeps its shape. |
| [svg-animation](gfx/svg-animation) | Plays an animated SVG in a window, or writes its frames as PNG files. |
| [thumbnail](gfx/thumbnail) | Scales an image down to fit a square, keeping its proportions. |
| [transforms](gfx/transforms) | Applies every image transform to one picture: mirroring, cropping, padding, resizing with each algorithm and fitting into a box. |
| [tiff-pages](gfx/tiff-pages) | Lists the pages of a TIFF file and saves one of them. |
| [webp-info](gfx/webp-info) | Prints what a WebP file holds (encoding, transparency, animation frames, metadata) and converts it. |

### Interop

| Example | Description |
|---------|-------------|
| [c](interop/c) | Calls functions from a C file and from the C math library, and lets C call an ADM function back. |
| [dotnet](interop/dotnet) | Calls the static methods of a C# class (arrays and strings both ways, null as none, an exception as an error), makes a .NET list and has .NET sort it with an ADM function. |
| [go](interop/go) | Calls a Go package the build compiles itself (`@go`): text statistics, and a sum its goroutines compute over an ADM array. |
| [java](interop/java) | Calls the static methods of a Java class (arrays and strings both ways, null as none, an exception as an error), makes a Java list and has Java sort it with an ADM function. |
| [js](interop/js) | Runs a shop's pricing rules written in JavaScript, calling the script's functions like ordinary ADM functions. |
| [lua](interop/lua) | Works out customer discounts and badges with rules written in Lua, called like ordinary ADM functions. |
| [rust](interop/rust) | Calls a Rust crate the build compiles itself (`@rust`), lets Rust write into a buffer and call an ADM function back. |
| [zig](interop/zig) | Calls a Zig file the build compiles itself (`@zig`): a hash, primes written into an ADM array, and a callback for each step of a sequence. |

### Media

| Example | Description |
|---------|-------------|
| [media-player](media/media-player) | Plays audio and video files and internet radio in a window, with keys to pause, skip and change item. |
| [midi](media/midi) | Plays a MIDI file, or a scale built in code, through the built-in synthesizer. |

### Network

| Example | Description |
|---------|-------------|
| [http-client](network/http-client) | Fetches a web address and prints the status, a few headers and the start of the body. |
| [http-server](network/http-server) | A small web server with four routes: a page, a greeting with a name from the path, a JSON reply and an echo. |
| [irc-client](network/irc-client) | Joins an IRC channel and prints the messages, joins and leaves as they happen. |

## License

[MIT](LICENSE)
