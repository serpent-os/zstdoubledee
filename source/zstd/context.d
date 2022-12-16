module zstd.context;

import std.stdint;

import zstd.c.symbols;
import zstd.simple;
import zstd.dict;
public import zstd.c.typedefs : Bounds,
    CompressionParameter,
    DecompressionParameter,
    EndDirective,
    InBuffer,
    OutBuffer,
    ResetDirective;

public alias CompressionStream = CompressionContext;
public alias DecompressionStream = DecompressionContext;

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

    size_t compress(void* dst, size_t dstCapacity, void* src, size_t srcSize)
    {
        const auto size = ZSTD_compress2(ptr, dst, dstCapacity, src, srcSize);
        if (ZSTD_isError(size))
        {
            throw new ZSTDException(size);
        }
        return size;
    }

    size_t compressUsingDict(
        void* dst,
        size_t dstCap,
        const void* src,
        size_t srcSize,
        const void* dict,
        size_t dictSize,
        CompressionLevel lvl)
    {
        const auto size = ZSTD_compress_usingDict(ptr, dst, dstCap, src, srcSize, dict, dictSize, lvl);
        if (ZSTD_isError(size))
        {
            throw new ZSTDException(size);
        }
        return size;
    }

    size_t compressUsingDict(
        void* dst,
        size_t dstCapacity,
        const void* src,
        size_t srcSize,
        const CompressionDict cdict)
    {
        const auto size = ZSTD_compress_usingCDict(ptr, dst, dstCapacity, src, srcSize, cdict.ptr);
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

    void streamInit(CompressionLevel lvl)
    {
        const auto errcode = ZSTD_initCStream(ptr, lvl);
        if (ZSTD_isError(errcode))
        {
            throw new ZSTDException(errcode);
        }
    }

    size_t streamCompress(OutBuffer* output, InBuffer* input)
    {
        const auto size = ZSTD_compressStream(ptr, output, input);
        if (ZSTD_isError(size))
        {
            throw new ZSTDException(size);
        }
        return size;
    }

    size_t streamCompress(OutBuffer* output, InBuffer* input, EndDirective endOp)
    {
        const auto remain = ZSTD_compressStream2(ptr, output, input, endOp);
        if (ZSTD_isError(remain))
        {
            throw new ZSTDException(remain);
        }
        return remain;
    }

    size_t streamFlush(OutBuffer* output)
    {
        const auto size = ZSTD_flushStream(ptr, output);
        if (ZSTD_isError(size))
        {
            throw new ZSTDException(size);
        }
        return size;
    }

    size_t streamEnd(OutBuffer* output)
    {
        const auto size = ZSTD_endStream(ptr, output);
        if (ZSTD_isError(size))
        {
            throw new ZSTDException(size);
        }
        return size;
    }

    static size_t streamInSize()
    {
        return ZSTD_CStreamInSize();
    }

    static size_t streamOutSize()
    {
        return ZSTD_CStreamOutSize();
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

    size_t decompressUsingDict(void* dst, size_t dstCap, const void* src, size_t srcSize, const void* dict, size_t dictSize)
    {
        const auto size = ZSTD_decompress_usingDict(ptr, dst, dstCap, src, srcSize, dict, dictSize);
        if (ZSTD_isError(size))
        {
            throw new ZSTDException(size);
        }
        return size;
    }

    void setParameter(DecompressionParameter param, int value)
    {
        const auto errCode = ZSTD_DCtx_setParameter(ptr, param, value);
        if (ZSTD_isError(errCode))
        {
            throw new ZSTDException(errCode);
        }
    }

    static size_t streamInSize()
    {
        return ZSTD_DStreamInSize();
    }

    size_t streamOutSize()
    {
        return ZSTD_DStreamOutSize();
    }

    void reset(ResetDirective directive)
    {
        const auto errCode = ZSTD_DCtx_reset(ptr, directive);
        if (ZSTD_isError(errCode))
        {
            throw new ZSTDException(errCode);
        }
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

Bounds getBounds(DecompressionParameter dp)
{
    return ZSTD_dParam_getBounds(dp);
}

unittest
{
    const auto bounds = getBounds(DecompressionParameter.WindowLogMax);
    assert(bounds.lowerBound > 0);
}
