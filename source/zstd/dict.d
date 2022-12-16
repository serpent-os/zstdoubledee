module zstd.dict;

import zstd.c.symbols;
import zstd.simple;

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

package:
    ZSTD_DDict* ptr;
}
