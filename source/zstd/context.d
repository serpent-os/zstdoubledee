module zstd.context;

import zstd.c.symbols;
import zstd.simple;

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
