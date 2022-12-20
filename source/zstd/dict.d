module zstd.dict;

import std.stdint;

import zstd.c.symbols;
import zstd.common;

class CompressionDict
{
    this(const void[] dictBuffer, CompressionLevel lvl)
    {
        ptr = ZSTD_createCDict(dictBuffer.ptr, dictBuffer.length, lvl);
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

unittest
{
    assert(new CompressionDict(null, 1).getDictID() == 0);
}

unittest
{
    assert(new CompressionDict(null, 1).sizeOf() > 0);
}

class DecompressionDict
{
    this(const void[] dictBuffer)
    {
        ptr = ZSTD_createDDict(dictBuffer.ptr, dictBuffer.length);
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

unittest
{
    assert(new DecompressionDict(null).getDictID() == 0);
}

unittest
{
    assert(new DecompressionDict(null).sizeOf() > 0);
}
