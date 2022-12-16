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

private:
    ZSTD_CDict* ptr;
}
