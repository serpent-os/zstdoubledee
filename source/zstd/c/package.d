module zstd.c;

import std.stdint;

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
}
