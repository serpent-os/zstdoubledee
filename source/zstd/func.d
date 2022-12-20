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
    return cast(string) ZSTD_versionString().fromStringz();
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
    assert(lvl >= minCompressionLevel() && lvl <= maxCompressionLevel());
}

CompressionLevel maxCompressionLevel() @trusted
{
    return ZSTD_maxCLevel();
}

unittest
{
    immutable auto v150MaxLevel = 22; /* May be subject to changes. */
    assert(maxCompressionLevel() >= v150MaxLevel);
}

size_t compress(void[] dst, const void[] src, CompressionLevel lvl) @trusted
{
    const auto size = ZSTD_compress(dst.ptr, dst.length, src.ptr, src.length, lvl);
    ZSTDException.raiseIfError(size);
    return size;
}

unittest
{
    import std.algorithm.comparison : equal;
    import std.exception : assertNotThrown;

    ubyte[] src = [1, 2, 3];
    ubyte[] dst;
    dst.length = compressBound(src.length);
    assertNotThrown(compress(dst, src, 1));
    assert(!equal(dst, new ubyte[dst.length]));
}

size_t decompress(void[] dst, const void[] src) @trusted
{
    const auto size = ZSTD_decompress(dst.ptr, dst.length, src.ptr, src.length);
    ZSTDException.raiseIfError(size);
    return size;
}

unittest
{
    import std.algorithm.comparison : equal;
    import std.exception : assertNotThrown;

    /* This is the dst of the compression test. */
    ubyte[] src = [40, 181, 47, 253, 32, 3, 25, 0, 0, 1, 2, 3];
    ubyte[] dst;
    dst.length = src.length;
    assertNotThrown(decompress(dst, src));
    assert(!equal(dst, new ubyte[dst.length]));
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
                return "size cannot be determined (code %d)".format(kind);
            }
        case Kind.SizeError:
            {
                return "one of the arguments is invalid (code %d)".format(kind);
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

uint64_t decompressBound(const void[] src) @trusted
{
    return ZSTD_decompressBound(src.ptr, src.length);
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
    auto nBytes = ZSTD_readSkippableFrame(dst.ptr, dst.length, &magicVariant, src.ptr, src
            .length);
    ZSTDException.raiseIfError(nBytes);
    return tuple(nBytes, magicVariant);
}
