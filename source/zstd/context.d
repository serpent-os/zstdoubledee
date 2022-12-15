module zstd.context;

import std.stdint;

import zstd.c.symbols;
import zstd.simple;
public import zstd.c.typedefs : CompressionParameter, Bounds, ResetDirective;

class CompressionContext
{
    this()
    {
        ptr = ZSTD_createCCtx();
    }

    ~this()
    {
        ZSTD_freeCCtx(ptr);
    }

    size_t compress(void* dst, size_t dstCapacity, void* src, size_t srcSize, CompressionLevel lvl)
    {
        const auto size = ZSTD_compressCCtx(ptr, dst, dstCapacity, src, srcSize, lvl);
        if (ZSTD_isError(size))
        {
            throw new ZSTDException(size);
        }
        return size;
    }

    void setParameter(CompressionParameter param, int value)
    {
        const auto errCode = ZSTD_CCtx_setParameter(ptr, param, value);
        if (ZSTD_isError(errCode))
        {
            throw new ZSTDException(errCode);
        }
    }

    void setPledgedSrcSize(uint64_t pledgedSrcSize)
    {
        const auto errCode = ZSTD_CCtx_setPledgedSrcSize(ptr, pledgedSrcSize);
        if (ZSTD_isError(errCode))
        {
            throw new ZSTDException(errCode);
        }
    }

    void reset(ResetDirective directive)
    {
        const auto errCode = ZSTD_CCtx_reset(ptr, directive);
        if (ZSTD_isError(errCode))
        {
            throw new ZSTDException(errCode);
        }
    }

private:
    ZSTD_CCtx* ptr;
}

class DecompressionContext
{
    this()
    {
        ptr = ZSTD_createDCtx();
    }

    ~this()
    {
        ZSTD_freeDCtx(ptr);
    }

    size_t decompress(void* dst, size_t dstCapacity, const void* src, size_t srcSize)
    {
        const auto size = ZSTD_decompressDCtx(ptr, dst, dstCapacity, src, srcSize);
        if (ZSTD_isError(size))
        {
            throw new ZSTDException(size);
        }
        return size;
    }

private:
    ZSTD_DCtx* ptr;
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
