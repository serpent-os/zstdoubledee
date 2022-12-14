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

string versionString() @trusted
{
    return cast(string) std.string.fromStringz(ZSTD_versionString());
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

size_t compress(void* dst, size_t dstCapacity, void* src, size_t srcSize, CompressionLevel lvl) @trusted
{
    auto size = ZSTD_compress(dst, dstCapacity, src, srcSize, lvl);
    if (ZSTD_isError(size))
    {
        throw new ZSTDException(size);
    }
    return size;
}

size_t decompress(void* dst, size_t dstCapacity, void* src, size_t compressedSize) @trusted
{
    auto size = ZSTD_decompress(dst, dstCapacity, src, compressedSize);
    if (ZSTD_isError(size))
    {
        throw new ZSTDException(size);
    }
    return size;
}

uint64_t getFrameContentSize(const void* src, size_t srcSize) @trusted
{
    // TODO: exception handling with a proper exception type.
    return ZSTD_getFrameContentSize(src, srcSize);
}
