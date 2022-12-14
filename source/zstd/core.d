module zstd.core;

import std.stdint;
import std.string;

import zstd.c;

uint32_t versionNumber() @trusted
{
    return ZSTD_versionNumber();
}

unittest
{
    assert(versionNumber() > 0);
}

char[] versionString() @trusted
{
    return std.string.fromStringz(ZSTD_versionString());
}

unittest
{
    assert(versionString().length > 0);
}

alias CompressionLevel = int32_t;

CompressionLevel minCompressionLevel() @trusted
{
    return ZSTD_minCLevel();
}

CompressionLevel maxCompressionLevel() @trusted
{
    return ZSTD_maxCLevel();
}
