module zstd.dict;

import std.stdint;

import zstd.c.symbols;
import zstd.common;

class CompressionDict
{
    this(const void[] dictBuffer, CompressionLevel lvl)
    {
        ptr = ZSTD_createCDict(cast(const void*) dictBuffer, dictBuffer.length, lvl);
    }

    ~this()
    {
        ZSTD_freeCDict(ptr);
    }

    uint32_t getDictID()
    {
        return ZSTD_getDictID_fromCDict(ptr);
    }

    size_t sizeOf()
    {
        return ZSTD_sizeof_CDict(ptr);
    }

package:
    ZSTD_CDict* ptr;
}

class DecompressionDict
{
    this(const void[] dictBuffer)
    {
        ptr = ZSTD_createDDict(cast(const void*) dictBuffer, dictBuffer.length);
    }

    ~this()
    {
        ZSTD_freeDDict(ptr);
    }

    uint32_t getDictID()
    {
        return ZSTD_getDictID_fromDDict(ptr);
    }

    size_t sizeOf()
    {
        return ZSTD_sizeof_DDict(ptr);
    }

package:
    ZSTD_DDict* ptr;
}
