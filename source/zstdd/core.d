module zstdd.core;

import std.stdint;
import std.string;

uint32_t versionNumber() @trusted {
    extern (C) uint32_t ZSTD_versionNumber();
    return ZSTD_versionNumber();
}

unittest {
    assert(1==1);
}

char[] versionString() @trusted {
    extern (C) char* ZSTD_versionString();
    return std.string.fromStringz(ZSTD_versionString());
}

alias CompressionLevel = int32_t;

CompressionLevel minCompressionLevel() @trusted {
    extern (C) int32_t ZSTD_minCLevel();
    return ZSTD_minCLevel();
}

CompressionLevel maxCompressionLevel() @trusted {
    extern (C) int32_t ZSTD_maxCLevel();
    return ZSTD_maxCLevel();
}
