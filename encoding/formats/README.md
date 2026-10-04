# Data formats

Writes one record in five data formats (JSON, YAML, TOML, MessagePack and CBOR), reads it back from JSON, then writes a few bytes as text in three ways (hex, Base64 and Base32). All of it comes from `std.data.encoding`.

```bash
adm run encoding/formats/main.adm
```

Every codec has `encode` and `decode`, and any struct can be encoded: its field names become the keys. From [main.adm](main.adm):

```adm
let book = Book{title: "Dune", author: "Frank Herbert", year: 1965, tags: ["fiction", "desert"]}

println(string(new YAML().encode(book)))

let copy = Book{}
try json.decode(json.encode(book), copy)
```

## Output

```
JSON
{
	"title": "Dune",
	"author": "Frank Herbert",
	"year": 1965,
	"tags": [
		"fiction",
		"desert"
	]
}

YAML
title: Dune
author: Frank Herbert
year: 1965
tags: [fiction, desert]

TOML
title = "Dune"
author = "Frank Herbert"
year = 1965
tags = ["fiction", "desert"]

MessagePack, 62 bytes
84a57469746c65a444756e65a6617574686f72ad4672616e6b2048657262657274a479656172cd07ada47461677392a766696374696f6ea6646573657274

CBOR, 62 bytes
a4657469746c656444756e6566617574686f726d4672616e6b204865726265727464796561721907ad6474616773826766696374696f6e66646573657274

Read back from JSON: Dune by Frank Herbert, 1965

hex     41444d2073617973206869
Base64  QURNIHNheXMgaGk=
Base32  IFCE2IDTMF4XGIDINE======
```
