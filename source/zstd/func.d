module zstd.func;

import std.format;
import std.stdint;
import std.string;
import std.typecons : tuple, Tuple;

import zstd.c.symbols;
public import zstd.c.typedefs : Bounds,
    CompressionParameter,
    DecompressionParameter;
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

CompressionLevel minCompressionLevel()
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

size_t compress(void[] dst, const void[] src, CompressionLevel lvl) @trusted
{
    const auto size = ZSTD_compress(dst.ptr, dst.length, src.ptr, src.length, lvl);
    ZSTDException.raiseIfError(size);
    return size;
}

size_t decompress(void[] dst, const void[] src) @trusted
{
    const auto size = ZSTD_decompress(dst.ptr, dst.length, src.ptr, src.length);
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

uint64_t getFrameContentSize(const void[] src) @trusted
{
    const auto size = ZSTD_getFrameContentSize(src.ptr, src.length);
    if (FrameContentSizeException.isError(size))
    {
        throw new FrameContentSizeException(cast(FrameContentSizeException.Kind) size);
    }
    return size;
}

size_t findFrameCompressedSize(const void[] src) @trusted
{
    const auto size = ZSTD_findFrameCompressedSize(src.ptr, src.length);
    ZSTDException.raiseIfError(size);
    return size;
}

size_t compressBound(size_t srcSize) @trusted
{
    return ZSTD_compressBound(srcSize);
}

uint32_t getDictIDFromDict(const void[] dict)
{
    return ZSTD_getDictID_fromDict(dict.ptr, dict.length);
}

uint32_t getDictIDFromFrame(const void[] src)
{
    return ZSTD_getDictID_fromFrame(src.ptr, src.length);
}

Bounds getBounds(CompressionParameter cp)
{
    return ZSTD_cParam_getBounds(cp);
}

unittest
{
    const auto bounds = getBounds(CompressionParameter.CompressionLevel);
    assert(bounds.lowerBound < 0);
}

Bounds getBounds(DecompressionParameter dp)
{
    return ZSTD_dParam_getBounds(dp);
}

unittest
{
    const auto bounds = getBounds(DecompressionParameter.WindowLogMax);
    assert(bounds.lowerBound > 0);
}

bool isSkippableFrame(const void[] buffer)
{
    return cast(bool) ZSTD_isSkippableFrame(buffer.ptr, buffer.length);
}

Tuple!(size_t, uint32_t) readSkippableFrame(void[] dst, const void[] src)
{
    uint32_t magicVariant;
    auto nBytes = ZSTD_readSkippableFrame(dst.ptr, dst.length, &magicVariant, src.ptr, src.length);
    ZSTDException.raiseIfError(nBytes);
    return tuple(nBytes, magicVariant);
}
