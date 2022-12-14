module zstd.core;

import std.format;
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

unittest
{
    assert(minCompressionLevel() < 0);
}

CompressionLevel maxCompressionLevel() @trusted
{
    return ZSTD_maxCLevel();
}

unittest
{
    assert(maxCompressionLevel() >= 22);
}

class ZSTDException : Exception
{
    this(size_t code, string filename = __FILE__, size_t line = __LINE__) @trusted
    {
        auto name = std.string.fromStringz(ZSTD_getErrorName(code));
        super(std.format.format("%s (%d)", cast(string) name, code), filename, line);
    }
}
