// A small Go package with a C interface: the functions main.adm declares
// and calls. A function marked //export keeps its name; the Go runtime
// starts the first time one is called.
package wordfreq

import "C"

import (
	"sort"
	"strings"
	"sync"
	"unsafe"
)

func counts(text string) map[string]int {
	seen := map[string]int{}
	for _, word := range strings.Fields(strings.ToLower(text)) {
		seen[strings.Trim(word, ".,;:!?\"'")]++
	}
	delete(seen, "")
	return seen
}

// How many different words the text has.
//
//export wordfreq_distinct
func wordfreq_distinct(text *C.char) C.longlong {
	return C.longlong(len(counts(C.GoString(text))))
}

// Copies the most frequent word into the caller's buffer and returns its
// length in bytes, at most `capacity`. Go memory never leaves the library:
// the caller owns the buffer.
//
//export wordfreq_top
func wordfreq_top(text *C.char, out *C.char, capacity C.longlong) C.longlong {
	seen := counts(C.GoString(text))
	words := make([]string, 0, len(seen))
	for word := range seen {
		words = append(words, word)
	}
	sort.Slice(words, func(i, j int) bool {
		if seen[words[i]] != seen[words[j]] {
			return seen[words[i]] > seen[words[j]]
		}
		return words[i] < words[j]
	})
	if len(words) == 0 || capacity <= 0 {
		return 0
	}
	return C.longlong(copy(unsafe.Slice((*byte)(unsafe.Pointer(out)), int(capacity)), words[0]))
}

// The sum of the squares of `n` values, computed by four goroutines.
//
//export wordfreq_sum_squares
func wordfreq_sum_squares(xs *C.double, n C.longlong) C.double {
	values := unsafe.Slice((*float64)(unsafe.Pointer(xs)), int(n))
	const workers = 4
	parts := make([]float64, workers)
	var wait sync.WaitGroup
	for w := 0; w < workers; w++ {
		wait.Add(1)
		go func(w int) {
			defer wait.Done()
			for i := w; i < len(values); i += workers {
				parts[w] += values[i] * values[i]
			}
		}(w)
	}
	wait.Wait()
	total := 0.0
	for _, part := range parts {
		total += part
	}
	return C.double(total)
}
