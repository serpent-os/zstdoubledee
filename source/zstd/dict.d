module zstd.dict;

import std.stdint;

import zstd.c.symbols;
import zstd.simple;

uint32_t getDictIDFromDict(const void* dict, size_t dictSize)
{
    return ZSTD_getDictID_fromDict(dict, dictSize);
}

uint32_t getDictIDFromFrame(const void* src, size_t srcSize)
{
    return ZSTD_getDictID_fromFrame(src, srcSize);
}

class CompressionDict
{
    this(const void* dictBuffer, size_t dictSize, CompressionLevel lvl)
    {
        ptr = ZSTD_createCDict(dictBuffer, dictSize, lvl);
    }

    ~this()
    {
        ZSTD_freeCDict(ptr);
    }

    uint32_t getDictID()
    {
        return ZSTD_getDictID_fromCDict(ptr);
    }

package:
    ZSTD_CDict* ptr;
}

class DecompressionDict
{
    this(const void* dictBuffer, size_t dictSize)
    {
        ptr = ZSTD_createDDict(dictBuffer, dictSize);
    }

    ~this()
    {
        ZSTD_freeDDict(ptr);
    }

    uint32_t getDictID()
    {
        return ZSTD_getDictID_fromDDict(ptr);
    }

package:
    ZSTD_DDict* ptr;
}
