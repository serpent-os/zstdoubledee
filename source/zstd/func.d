module zstd.func;

import std.format;
import std.stdint;
import std.string;

import zstd.c.symbols;
import zstd.common;

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

CompressionLevel minCompressionLevel() @trusted
{
    return ZSTD_minCLevel();
}

unittest
{
    assert(minCompressionLevel() < 0);
}

CompressionLevel defaultCompressionLevel() @trusted
{
    return ZSTD_defaultCLevel();
}

unittest
{
    const auto lvl = defaultCompressionLevel();
    assert(lvl >= minCompressionLevel && lvl <= maxCompressionLevel);
}

CompressionLevel maxCompressionLevel() @trusted
{
    return ZSTD_maxCLevel();
}

unittest
{
    assert(maxCompressionLevel() >= 22);
}

size_t compress(void* dst, size_t dstCapacity, void* src, size_t srcSize, CompressionLevel lvl) @trusted
{
    const auto size = ZSTD_compress(dst, dstCapacity, src, srcSize, lvl);
    ZSTDException.raiseIfError(size);
    return size;
}

size_t decompress(void* dst, size_t dstCapacity, void* src, size_t compressedSize) @trusted
{
    const auto size = ZSTD_decompress(dst, dstCapacity, src, compressedSize);
    ZSTDException.raiseIfError(size);
    return size;
}

class FrameContentSizeException : ZSTDException
{
private:
    this(Kind kind, string filename = __FILE__, size_t line = __LINE__) @safe
    {
        super(kindToString(kind), filename, line);
    }

    enum Kind : uint64_t
    {
        SizeUnknown = -1,
        SizeError = -2,
    }

    static bool isError(uint64_t size) @safe
    {
        return size >= Kind.min && size <= Kind.max;
    }

    static string kindToString(Kind kind) @safe
    {
        final switch (kind)
        {
        case Kind.SizeUnknown:
            {
                return std.format.format("size cannot be determined (code %d)", kind);
            }
        case Kind.SizeError:
            {
                return std.format.format("one of the arguments is invalid (code %d)", kind);
            }
        }
    }
}

uint64_t getFrameContentSize(const void* src, size_t srcSize) @trusted
{
    const auto size = ZSTD_getFrameContentSize(src, srcSize);
    if (FrameContentSizeException.isError(size))
    {
        throw new FrameContentSizeException(cast(FrameContentSizeException.Kind) size);
    }
    return size;
}

size_t findFrameCompressedSize(void* src, size_t srcSize) @trusted
{
    const auto size = ZSTD_findFrameCompressedSize(src, srcSize);
    ZSTDException.raiseIfError(size);
    return size;
}

size_t compressBound(size_t srcSize) @trusted
{
    return ZSTD_compressBound(srcSize);
}

uint32_t getDictIDFromDict(const void* dict, size_t dictSize)
{
    return ZSTD_getDictID_fromDict(dict, dictSize);
}

uint32_t getDictIDFromFrame(const void* src, size_t srcSize)
{
    return ZSTD_getDictID_fromFrame(src, srcSize);
}

bool isSkippableFrame(const void* buffer, size_t size)
{
    return cast(bool) ZSTD_isSkippableFrame(buffer, size);
}

size_t readSkippableFrame(void* dst, size_t dstCap, uint32_t* magicVariant, const void* src, size_t srcSize)
{
    const auto nBytes = ZSTD_readSkippableFrame(dst, dstCap, magicVariant, src, srcSize);
    ZSTDException.raiseIfError(nBytes);
    return nBytes;
}
