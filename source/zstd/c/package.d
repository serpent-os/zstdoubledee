module zstd.c;

import std.stdint;

extern (C)
{
    uint32_t ZSTD_versionNumber();
    char* ZSTD_versionString();

    int32_t ZSTD_minCLevel();
    int32_t ZSTD_maxCLevel();

    uint32_t ZSTD_isError(size_t);
    char* ZSTD_getErrorName(size_t);

}
