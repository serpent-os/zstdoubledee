module zstd.stream;

import zstd.c.symbols;
import zstd.simple;
public import zstd.c.typedefs : EndDirective,
    InBuffer,
    OutBuffer;

class CompressionStream
{
    this()
    {
        ptr = ZSTD_createCStream();
    }

    ~this()
    {
        ZSTD_freeCStream(ptr);
    }

    void initStream(CompressionLevel lvl)
    {
        const auto errcode = ZSTD_initCStream(ptr, lvl);
        if (ZSTD_isError(errcode))
        {
            throw new ZSTDException(errcode);
        }
    }

    size_t compress(OutBuffer* output, InBuffer* input)
    {
        const auto size = ZSTD_compressStream(ptr, output, input);
        if (ZSTD_isError(size))
        {
            throw new ZSTDException(size);
        }
        return size;
    }

    size_t compress(OutBuffer* output, InBuffer* input, EndDirective endOp)
    {
        const auto remain = ZSTD_compressStream2(ptr, output, input, endOp);
        if (ZSTD_isError(remain))
        {
            throw new ZSTDException(remain);
        }
        return remain;
    }

    size_t flush(OutBuffer* output)
    {
        const auto size = ZSTD_flushStream(ptr, output);
        if (ZSTD_isError(size))
        {
            throw new ZSTDException(size);
        }
        return size;
    }

    size_t end(OutBuffer* output)
    {
        const auto size = ZSTD_endStream(ptr, output);
        if (ZSTD_isError(size))
        {
            throw new ZSTDException(size);
        }
        return size;
    }

    static size_t inSize()
    {
        return ZSTD_CStreamInSize();
    }

    static size_t outSize()
    {
        return ZSTD_CStreamOutSize();
    }

private:
    ZSTD_CStream* ptr;
}
