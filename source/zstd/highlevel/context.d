module zstd.highlevel.context;

import std.stdint;

import zstd.c.symbols;
import zstd.common;
import zstd.context;
import zstd.dict;
import zstd.func;

public alias CompressionStream = CompressionContext;
public alias DecompressionStream = DecompressionContext;

class CompressionContext
{
    this()
    {
        ctx = new zstd.context.CompressionContext();
    }

    this(zstd.context.CompressionContext ctx)
    {
        this.ctx = ctx;
    }

    ubyte[] compress(const void[] src, CompressionLevel lvl)
    {
        buffer.ensureCapacity(compressBound(src.length));
        const auto size = ctx.compress(buffer, src, lvl);
        return buffer[0 .. size];
    }

    ubyte[] compress(const void[] src)
    {
        buffer.ensureCapacity(compressBound(src.length));
        const auto size = ctx.compress(buffer, src);
        return buffer[0 .. size];
    }

    ubyte[] compressUsingDict(const void[] src, const void[] dict, CompressionLevel lvl)
    {
        buffer.ensureCapacity(compressBound(src.length));
        const auto size = ctx.compressUsingDict(buffer, src, dict, lvl);
        return buffer[0 .. size];
    }

    ubyte[] compressUsingDict(const void[] src, const CompressionDict dict)
    {
        buffer.ensureCapacity(compressBound(src.length));
        const auto size = ctx.compressUsingDict(buffer, src, dict);
        return buffer[0 .. size];
    }

    void loadDictionary(const void[] dict)
    {
        return ctx.loadDictionary(dict);
    }

    void refDict(const CompressionDict dict)
    {
        return ctx.refDict(dict);
    }

    void refPrefix(const void[] prefix)
    {
        return ctx.refPrefix(prefix);
    }

    void setParameter(CompressionParameter param, int value)
    {
        return ctx.setParameter(param, value);
    }

    void setPledgedSrcSize(uint64_t pledgedSrcSize)
    {
        return ctx.setPledgedSrcSize(pledgedSrcSize);
    }

    void streamInit(CompressionLevel lvl)
    {
        return ctx.streamInit(lvl);
    }

    size_t streamCompress(OutBuffer* output, InBuffer* input)
    {
        return ctx.streamCompress(output, input);
    }

    size_t streamCompress(OutBuffer* output, InBuffer* input, EndDirective endOp)
    {
        return ctx.streamCompress(output, input, endOp);
    }

    size_t streamFlush(OutBuffer* output)
    {
        return ctx.streamFlush(output);
    }

    size_t streamEnd(OutBuffer* output)
    {
        return ctx.streamEnd(output);
    }

    size_t sizeOf()
    {
        return ctx.sizeOf();
    }

    void reset(ResetDirective directive)
    {
        return ctx.reset(directive);
    }

private:
    zstd.context.CompressionContext ctx;
    ubyte[] buffer;
}

class DecompressionContext
{
    this()
    {
        ctx = new zstd.context.DecompressionContext();
    }

    this(zstd.context.DecompressionContext ctx)
    {
        this.ctx = ctx;
    }

    ubyte[] decompress(const void[] src)
    {
        buffer.ensureCapacity(bufferSizeFor(src));
        const auto size = ctx.decompress(buffer, src);
        return buffer[0 .. size];
    }

    ubyte[] decompressUsingDict(const void[] src, const void[] dict)
    {
        buffer.ensureCapacity(bufferSizeFor(src));
        const auto size = ctx.decompressUsingDict(buffer, src, dict);
        return buffer[0 .. size];
    }

    ubyte[] decompressUsingDict(const void[] src, const DecompressionDict dict)
    {
        buffer.ensureCapacity(bufferSizeFor(src));
        const auto size = ctx.decompressUsingDict(buffer, src, dict);
        return buffer[0 .. size];
    }

    void loadDictionary(const void[] dict)
    {
        return ctx.loadDictionary(dict);
    }

    void refDict(const DecompressionDict dict)
    {
        return ctx.refDict(dict);
    }

    void refPrefix(const void[] prefix)
    {
        return ctx.refPrefix(prefix);
    }

    void setParameter(DecompressionParameter param, int value)
    {
        return ctx.setParameter(param, value);
    }

    size_t sizeOf()
    {
        return ctx.sizeOf();
    }

    void reset(ResetDirective directive)
    {
        return ctx.reset(directive);
    }

private:
    zstd.context.DecompressionContext ctx;
    ubyte[] buffer;

    size_t bufferSizeFor(const void[] src)
    {
        try
        {
            return getFrameContentSize(src);
        }
        catch (FrameContentSizeException)
        {
            return decompressBound(src);
        }
    }
}

private
{
    void ensureCapacity(ref ubyte[] buf, size_t size)
    {
        if (buf.length >= size)
        {
            return;
        }
        buf.length = size;
    }
}
