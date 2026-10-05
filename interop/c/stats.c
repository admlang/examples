// A small C library: the functions main.adm declares and calls.
#include <math.h>
#include <stdbool.h>
#include <stdint.h>

double stats_mean(const double* xs, int64_t n) {
    double sum = 0;
    for (int64_t i = 0; i < n; i++) sum += xs[i];
    return n ? sum / (double)n : 0;
}

double stats_deviation(const double* xs, int64_t n) {
    double mean = stats_mean(xs, n), sum = 0;
    for (int64_t i = 0; i < n; i++) sum += (xs[i] - mean) * (xs[i] - mean);
    return n ? sqrt(sum / (double)n) : 0;
}

// Writes into the caller's array.
void stats_scale(double* xs, int64_t n, double factor) {
    for (int64_t i = 0; i < n; i++) xs[i] *= factor;
}

// Calls `keep` for every value and counts the ones it accepts.
int64_t stats_count_if(const double* xs, int64_t n, bool (*keep)(double)) {
    int64_t count = 0;
    for (int64_t i = 0; i < n; i++) count += keep(xs[i]) ? 1 : 0;
    return count;
}

const char* stats_version(void) { return "stats 1.0"; }
