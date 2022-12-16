module zstd.context;

import std.stdint;

import zstd.c.symbols;
public import zstd.c.typedefs : Bounds,
    CompressionParameter,
    DecompressionParameter,
    EndDirective,
    InBuffer,
    OutBuffer,
    ResetDirective;
import zstd.common;
import zstd.dict;

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
        ZSTDException.raiseIfError(size);
        return size;
    }

    size_t compress(void* dst, size_t dstCapacity, void* src, size_t srcSize)
    {
        const auto size = ZSTD_compress2(ptr, dst, dstCapacity, src, srcSize);
        ZSTDException.raiseIfError(size);
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
        ZSTDException.raiseIfError(size);
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
        ZSTDException.raiseIfError(size);
        return size;
    }

    void loadDictionary(const void* dict, size_t dictSize)
    {
        const auto errCode = ZSTD_CCtx_loadDictionary(ptr, dict, dictSize);
        ZSTDException.raiseIfError(errCode);
    }

    void refDict(const CompressionDict dict)
    {
        const auto errCode = ZSTD_CCtx_refCDict(ptr, dict.ptr);
        ZSTDException.raiseIfError(errCode);
    }

    void refPrefix(const void* prefix, size_t prefixSize)
    {
        const auto errCode = ZSTD_CCtx_refPrefix(ptr, prefix, prefixSize);
        ZSTDException.raiseIfError(errCode);
    }

    void setParameter(CompressionParameter param, int value)
    {
        const auto errCode = ZSTD_CCtx_setParameter(ptr, param, value);
        ZSTDException.raiseIfError(errCode);
    }

    void setPledgedSrcSize(uint64_t pledgedSrcSize)
    {
        const auto errCode = ZSTD_CCtx_setPledgedSrcSize(ptr, pledgedSrcSize);
        ZSTDException.raiseIfError(errCode);
    }

    void streamInit(CompressionLevel lvl)
    {
        const auto errcode = ZSTD_initCStream(ptr, lvl);
        ZSTDException.raiseIfError(errcode);
    }

    size_t streamCompress(OutBuffer* output, InBuffer* input)
    {
        const auto size = ZSTD_compressStream(ptr, output, input);
        ZSTDException.raiseIfError(size);
        return size;
    }

    size_t streamCompress(OutBuffer* output, InBuffer* input, EndDirective endOp)
    {
        const auto remain = ZSTD_compressStream2(ptr, output, input, endOp);
        ZSTDException.raiseIfError(remain);
        return remain;
    }

    size_t streamFlush(OutBuffer* output)
    {
        const auto size = ZSTD_flushStream(ptr, output);
        ZSTDException.raiseIfError(size);
        return size;
    }

    size_t streamEnd(OutBuffer* output)
    {
        const auto size = ZSTD_endStream(ptr, output);
        ZSTDException.raiseIfError(size);
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

    size_t sizeOf()
    {
        return ZSTD_sizeof_CCtx(ptr);
    }

    void reset(ResetDirective directive)
    {
        const auto errCode = ZSTD_CCtx_reset(ptr, directive);
        ZSTDException.raiseIfError(errCode);
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
        ZSTDException.raiseIfError(size);
        return size;
    }

    size_t decompressUsingDict(
        void* dst,
        size_t dstCap,
        const void* src,
        size_t srcSize,
        const void* dict,
        size_t dictSize)
    {
        const auto size = ZSTD_decompress_usingDict(ptr, dst, dstCap, src, srcSize, dict, dictSize);
        ZSTDException.raiseIfError(size);
        return size;
    }

    size_t decompressUsingDict(
        void* dst, size_t dstCapacity,
        const void* src, size_t srcSize,
        const DecompressionDict ddict)
    {
        const auto size = ZSTD_decompress_usingDDict(ptr, dst, dstCapacity, src, srcSize, ddict.ptr);
        ZSTDException.raiseIfError(size);
        return size;
    }

    void loadDictionary(const void* dict, size_t dictSize)
    {
        const auto errCode = ZSTD_DCtx_loadDictionary(ptr, dict, dictSize);
        ZSTDException.raiseIfError(errCode);
    }

    void refDict(const DecompressionDict dict)
    {
        const auto errCode = ZSTD_DCtx_refDDict(ptr, dict.ptr);
        ZSTDException.raiseIfError(errCode);
    }

    void refPrefix(const void* prefix, size_t prefixSize)
    {
        const auto errCode = ZSTD_DCtx_refPrefix(ptr, prefix, prefixSize);
        ZSTDException.raiseIfError(errCode);
    }

    void setParameter(DecompressionParameter param, int value)
    {
        const auto errCode = ZSTD_DCtx_setParameter(ptr, param, value);
        ZSTDException.raiseIfError(errCode);
    }

    static size_t streamInSize()
    {
        return ZSTD_DStreamInSize();
    }

    size_t streamOutSize()
    {
        return ZSTD_DStreamOutSize();
    }

    size_t sizeOf()
    {
        return ZSTD_sizeof_DCtx(ptr);
    }

    void reset(ResetDirective directive)
    {
        const auto errCode = ZSTD_DCtx_reset(ptr, directive);
        ZSTDException.raiseIfError(errCode);
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
