#include <algorithm>
#include <cmath>
#include <cstdint>

namespace {
double ordered_sum(const double* values, int count) {
    if (count < 8) {
        double result = 0.0;
        for (int index = 0; index < count; ++index) result += values[index];
        return result;
    }
    if (count > 128) {
        const int split = (count / 2) & ~7;
        return ordered_sum(values, split) + ordered_sum(values + split, count - split);
    }
    double lanes[8];
    std::copy(values, values + 8, lanes);
    int index = 8;
    for (; index < count - count % 8; index += 8) {
        for (int lane = 0; lane < 8; ++lane) lanes[lane] += values[index + lane];
    }
    double result = ((lanes[0] + lanes[1]) + (lanes[2] + lanes[3]))
                  + ((lanes[4] + lanes[5]) + (lanes[6] + lanes[7]));
    for (; index < count; ++index) result += values[index];
    return result;
}

double sample_sign(double value) {
    return value > 0.0 ? 1.0 : value < 0.0 ? -1.0 : 0.0;
}
}

extern "C" std::uint32_t vvg_cpu_features_abi() { return 0x00010001; }

extern "C" int vvg_cpu_preprocess_dc(const double* input, int count, const double* weights,
    double coefficient, double previous, double carry, double* output, double* state) {
    if (!input || !weights || !output || !state || count < 1 || count > 960
            || !std::isfinite(coefficient) || !std::isfinite(previous) || !std::isfinite(carry)) return -1;
    for (int index = 0; index < count; ++index) if (!std::isfinite(input[index])) return -2;
    for (int index = 0; index < 256; ++index) {
        if (!std::isfinite(weights[index]) || weights[index] <= 0) return -2;
    }
    for (int start = 0; start < count; start += 256) {
        const int length = std::min(256, count - start);
        const double initial = coefficient * carry;
        double accumulated = (input[start] - previous) / weights[0];
        output[start] = weights[0] * (initial + accumulated);
        for (int index = 1; index < length; ++index) {
            const double difference = input[start + index] - input[start + index - 1];
            accumulated += difference / weights[index];
            output[start + index] = weights[index] * (initial + accumulated);
        }
        carry = output[start + length - 1];
        previous = input[start + length - 1];
    }
    state[0] = previous;
    state[1] = carry;
    return 0;
}

extern "C" int vvg_cpu_features_prepare(const double* input, int rows, int columns,
                                        double* centered, double* energy, double* metrics) {
    if (!input || !centered || !energy || !metrics || rows < 1 || rows > 64 || columns != 512) return -1;
    for (int row = 0; row < rows; ++row) {
        const double* source = input + row * columns;
        for (int column = 0; column < columns; ++column) {
            if (!std::isfinite(source[column])) return -2;
        }
        const double mean = (0.0 + ordered_sum(source, columns)) / columns;
        double crossings = 0.0;
        double* destination = centered + row * columns;
        double* squared = energy + row * columns;
        for (int column = 0; column < columns; ++column) {
            destination[column] = source[column] - mean;
            squared[column] = destination[column] * destination[column];
            if (column) crossings += std::abs(sample_sign(destination[column]) - sample_sign(destination[column - 1]));
        }
        metrics[row * 2] = (0.0 + ordered_sum(squared, columns)) / columns;
        metrics[row * 2 + 1] = crossings / (columns - 1) / 2;
    }
    return 0;
}

extern "C" int vvg_cpu_features_finish(const double* energy, const double* metrics,
    const double* correlation, const double* spectrum, const std::int32_t* lags,
    int rows, int lag_count, int hi_first, int low_first, int low_last,
    double sample_hz, double autocorr_epsilon, double q_min, double spectrum_epsilon,
    double* output) {
    if (!energy || !metrics || !correlation || !spectrum || !lags || !output
            || rows < 1 || rows > 64 || lag_count < 1 || lag_count > 511
            || hi_first < 0 || hi_first > 257 || low_first < 0 || low_last < low_first || low_last >= 257
            || !std::isfinite(sample_hz) || sample_hz <= 0
            || !std::isfinite(autocorr_epsilon) || autocorr_epsilon <= 0
            || !std::isfinite(q_min) || q_min < 0 || q_min > 1
            || !std::isfinite(spectrum_epsilon) || spectrum_epsilon <= 0) return -1;
    for (int index = 0; index < lag_count; ++index) {
        if (lags[index] < 1 || lags[index] > 511) return -2;
    }
    for (int row = 0; row < rows; ++row) {
        double prefix[512], suffix[512];
        const double* squared = energy + row * 512;
        prefix[0] = squared[0];
        suffix[511] = squared[511];
        for (int index = 1; index < 512; ++index) {
            prefix[index] = prefix[index - 1] + squared[index];
            suffix[511 - index] = suffix[512 - index] + squared[511 - index];
        }
        double best_quality = 0.0;
        int best_index = 0;
        for (int index = 0; index < lag_count; ++index) {
            const double corr = correlation[row * lag_count + index];
            const double first = suffix[lags[index]], second = prefix[511 - lags[index]];
            double quality = 0.0;
            if (corr > 0 && first > autocorr_epsilon && second > autocorr_epsilon) {
                quality = (corr * corr) / (first * second + autocorr_epsilon);
            }
            if (quality > best_quality) { best_quality = quality; best_index = index; }
        }
        best_quality = std::min(1.0, std::max(0.0, best_quality));
        const bool valid = best_quality >= q_min;
        const int lag = valid ? lags[best_index] : 0;
        const double* magnitudes = spectrum + row * 257;
        const double total = 0.0 + ordered_sum(magnitudes, 257);
        double* result = output + row * 8;
        result[0] = metrics[row * 2];
        result[1] = metrics[row * 2 + 1];
        result[2] = lag;
        result[3] = valid ? sample_hz / lag : 0.0;
        result[4] = best_quality;
        result[5] = total > spectrum_epsilon ? (0.0 + ordered_sum(magnitudes + hi_first, 257 - hi_first)) / total : 0.0;
        result[6] = total > spectrum_epsilon ? (0.0 + ordered_sum(magnitudes + low_first, low_last - low_first + 1)) / total : 0.0;
        result[7] = valid ? 1.0 : 0.0;
    }
    return 0;
}