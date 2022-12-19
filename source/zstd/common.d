module zstd.common;

import std.format;
import std.stdint;
import std.string;

import zstd.c.symbols;

class ZSTDException : Exception
{
package:
    this(string msg, string filename = __FILE__, size_t line = __LINE__) @trusted
    {
        super(msg, filename, line);
    }

    this(size_t code, string filename = __FILE__, size_t line = __LINE__) @trusted
    {
        const auto name = ZSTD_getErrorName(code).fromStringz();
        super("%s (%d)".format(cast(string) name, code), filename, line);
    }

    static raiseIfError(size_t code)
    {
        if (ZSTD_isError(code))
        {
            throw new ZSTDException(code);
        }
    }
}

alias CompressionLevel = int32_t;
