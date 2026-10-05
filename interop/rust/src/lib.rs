//! A small Rust library with a C interface: the functions main.adm declares
//! and calls. Each one is `extern "C"` and keeps its name (`#[no_mangle]`).

use std::ffi::{c_char, CStr, CString};

/// The text of a C string; bytes that are not UTF-8 are replaced.
unsafe fn text_of<'a>(text: *const c_char) -> std::borrow::Cow<'a, str> {
    CStr::from_ptr(text).to_string_lossy()
}

#[no_mangle]
pub extern "C" fn text_version() -> *const c_char {
    c"textstats 1.0".as_ptr()
}

/// How many words the text has.
#[no_mangle]
pub unsafe extern "C" fn text_words(text: *const c_char) -> i64 {
    text_of(text).split_whitespace().count() as i64
}

/// Copies the longest word into the caller's buffer and returns its length
/// in bytes, at most `capacity`.
#[no_mangle]
pub unsafe extern "C" fn text_longest(text: *const c_char, out: *mut u8, capacity: i64) -> i64 {
    let text = text_of(text);
    let longest = text.split_whitespace().max_by_key(|w| w.chars().count()).unwrap_or("");
    let n = longest.len().min(capacity.max(0) as usize);
    std::ptr::copy_nonoverlapping(longest.as_ptr(), out, n);
    n as i64
}

/// Calls `keep` for every word and counts the ones it accepts.
#[no_mangle]
pub unsafe extern "C" fn text_count_if(text: *const c_char, keep: extern "C" fn(*const c_char) -> bool) -> i64 {
    let mut count = 0;
    for word in text_of(text).split_whitespace() {
        let word = CString::new(word).unwrap_or_default();
        if keep(word.as_ptr()) {
            count += 1;
        }
    }
    count
}

/// The median of `n` values; the caller's array is left as it is.
#[no_mangle]
pub unsafe extern "C" fn stats_median(xs: *const f64, n: i64) -> f64 {
    if n <= 0 {
        return 0.0;
    }
    let mut sorted = std::slice::from_raw_parts(xs, n as usize).to_vec();
    sorted.sort_by(f64::total_cmp);
    let mid = sorted.len() / 2;
    if sorted.len() % 2 == 1 {
        sorted[mid]
    } else {
        (sorted[mid - 1] + sorted[mid]) / 2.0
    }
}
