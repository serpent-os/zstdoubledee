module zstd.compcontext;

import zstd.c;
import zstd.core;

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
