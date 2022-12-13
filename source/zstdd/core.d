module zstdd.core;

import std.stdint;
import std.string;

uint32_t versionNumber() {
    extern (C) uint32_t ZSTD_versionNumber();
    return ZSTD_versionNumber();
}

char[] versionString() {
    extern (C) char* ZSTD_versionString();
    return std.string.fromStringz(ZSTD_versionString());
}
