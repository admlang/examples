// A small Zig library with a C interface: the functions main.adm declares
// and calls. `export` gives a function its C name and calling convention.

export fn numbers_version() [*:0]const u8 {
    return "numbers 1.0";
}

// The FNV-1a hash of `len` bytes.
export fn numbers_hash(data: [*]const u8, len: usize) u64 {
    var hash: u64 = 0xcbf29ce484222325;
    for (data[0..len]) |byte| {
        hash = (hash ^ byte) *% 0x100000001b3;
    }
    return hash;
}

// Writes the first primes into the caller's array, as many as it holds, and
// returns how many it wrote.
export fn numbers_primes(out: [*]u32, capacity: usize) usize {
    var count: usize = 0;
    var candidate: u32 = 2;
    while (count < capacity) : (candidate += 1) {
        var prime = true;
        for (out[0..count]) |p| {
            if (p * p > candidate) break;
            if (candidate % p == 0) {
                prime = false;
                break;
            }
        }
        if (prime) {
            out[count] = candidate;
            count += 1;
        }
    }
    return count;
}

// Calls `visit` with each step of the Collatz sequence from `start` down to
// 1 and returns the number of steps.
export fn numbers_collatz(start: u64, visit: *const fn (u64) callconv(.c) void) i64 {
    var value = start;
    var steps: i64 = 0;
    while (value > 1) : (steps += 1) {
        value = if (value % 2 == 0) value / 2 else value * 3 + 1;
        visit(value);
    }
    return steps;
}
