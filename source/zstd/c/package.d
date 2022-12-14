module zstd.c;

import std.stdint;

extern (C)
{
    uint32_t ZSTD_versionNumber();
    char* ZSTD_versionString();

    int32_t ZSTD_minCLevel();
    int32_t ZSTD_maxCLevel();
}
