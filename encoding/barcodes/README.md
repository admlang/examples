# Barcodes

Makes one barcode of every kind `std.barcodes` knows, saves each as an image, then loads the image back and checks that the barcode found in it holds the text it was made from. The images below are this example's output.

```bash
adm run encoding/barcodes/main.adm                # writes into barcodes-out/
adm run encoding/barcodes/main.adm -- some/dir    # writes into some/dir
```

Making a barcode and reading one are a call each, in [main.adm](main.adm):

```adm
let symbol = try encode("https://adm-lang.dev", Symbology.Qr)
try symbol.toImage(scale = 5).save("qr.png")

for let (_, found) in decode(try load("qr.png")) {
	println("{found.symbology}: {found.text}")
}
```

## Two-dimensional codes

| Kind | Text | Image |
|------|------|-------|
| QR | `https://adm-lang.dev/?from=barcodes` | ![QR code](barcodes-out/qr.png) |
| Micro QR | `ADM 2026` | ![Micro QR code](barcodes-out/micro-qr.png) |
| Data Matrix | `Data Matrix: 0123456789` | ![Data Matrix code](barcodes-out/datamatrix.png) |
| Aztec | `Aztec Code, hello!` | ![Aztec code](barcodes-out/aztec.png) |
| PDF417 | `PDF417 carries whole paragraphs of text.` | ![PDF417 code](barcodes-out/pdf417.png) |
| MicroPDF417 | `MicroPDF417` | ![MicroPDF417 code](barcodes-out/micro-pdf417.png) |

## Linear codes

| Kind | Text | Image |
|------|------|-------|
| EAN-13 | `5901234123457` | ![EAN-13 barcode](barcodes-out/ean13.png) |
| EAN-8 | `96385074` | ![EAN-8 barcode](barcodes-out/ean8.png) |
| UPC-A | `036000291452` | ![UPC-A barcode](barcodes-out/upca.png) |
| UPC-E | `01234565` | ![UPC-E barcode](barcodes-out/upce.png) |
| Code 128 | `Code 128 / ADM` | ![Code 128 barcode](barcodes-out/code128.png) |
| Code 39 | `CODE 39` | ![Code 39 barcode](barcodes-out/code39.png) |
| Code 93 | `Code 93!` | ![Code 93 barcode](barcodes-out/code93.png) |
| ITF | `12345670` | ![ITF barcode](barcodes-out/itf.png) |
| Codabar | `A40156B` | ![Codabar barcode](barcodes-out/codabar.png) |

## Read back from a JPEG

JPEG is lossy, so its blurred edges test the reader. This QR code holds `Read back from a JPEG`, with a higher error correction level:

![QR code saved as JPEG](barcodes-out/qr.jpg)

## Several barcodes in one image

`decode` finds every barcode in an image. This sheet holds a QR code, a Data Matrix code, an Aztec code and a Code 128 barcode, and one call reads all four:

![Four barcodes on one sheet](barcodes-out/sheet.png)
