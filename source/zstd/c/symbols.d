module zstd.c.symbols;

import std.stdint;

import zstd.c.typedefs;

extern (C) @nogc nothrow
{
    uint32_t ZSTD_versionNumber();
    char* ZSTD_versionString();

    int32_t ZSTD_minCLevel();
    int32_t ZSTD_defaultCLevel();
    int32_t ZSTD_maxCLevel();

    uint32_t ZSTD_isError(size_t);
    char* ZSTD_getErrorName(size_t);

    size_t ZSTD_compress(void* dst, size_t dstCapacity, const void* src, size_t srcSize, int compressionLevel);
    size_t ZSTD_decompress(void* dst, size_t dstCapacity, void* src, size_t compressedSize);
    size_t ZSTD_findFrameCompressedSize(void* src, size_t srcSize);
    size_t ZSTD_compressBound(size_t srcSize);

    uint64_t ZSTD_getFrameContentSize(const void* src, size_t srcSize);

    struct ZSTD_CCtx_s;
    alias ZSTD_CCtx = ZSTD_CCtx_s;
    ZSTD_CCtx* ZSTD_createCCtx();
    void ZSTD_freeCCtx(ZSTD_CCtx* cctx);
    size_t ZSTD_compressCCtx(ZSTD_CCtx* cctx, void* dst, size_t dstCap, const void* src, size_t srcSize, int compLvl);
    size_t ZSTD_compress2(ZSTD_CCtx* cctx, void* dst, size_t dstCapacity, void* src, size_t srcSize);
    size_t ZSTD_CCtx_setParameter(ZSTD_CCtx* cctx, CompressionParameter param, int value);
    size_t ZSTD_CCtx_setPledgedSrcSize(ZSTD_CCtx* cctx, uint64_t pledgedSrcSize);
    size_t ZSTD_CCtx_reset(ZSTD_CCtx* cctx, ResetDirective reset);

    struct ZSTD_DCtx_s;
    alias ZSTD_DCtx = ZSTD_DCtx_s;
    ZSTD_DCtx* ZSTD_createDCtx();
    size_t ZSTD_freeDCtx(ZSTD_DCtx* dctx);
    size_t ZSTD_decompressDCtx(ZSTD_DCtx* dctx, void* dst, size_t dstCapacity, const void* src, size_t srcSize);

    Bounds ZSTD_cParam_getBounds(CompressionParameter);
}
