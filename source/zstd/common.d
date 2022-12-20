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
    in
    {
        assert(ZSTD_isError(code));
    }
    do
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

unittest
{
    bool caught = false;
    try
    {
        throw new ZSTDException("my expected message");
    }
    catch (ZSTDException e)
    {
        caught = true;
        assert(e.msg == "my expected message");
    }
    assert(caught == true, "exception not caught");
}

unittest
{
    import std.exception : assertNotThrown, assertThrown;
    import core.exception : AssertError;

    const auto errCode = ZSTD_compress(null, 0, null, 0, 1);
    immutable auto okCode = 0;
    assertNotThrown(
        new ZSTDException(errCode),
        "%d should be an error code but it's not".format(errCode));
    assertThrown!AssertError(
        new ZSTDException(okCode),
        "%d should not be an error code, but it is".format(okCode));
}

unittest
{
    import std.exception : assertNotThrown, assertThrown;

    const auto errCode = ZSTD_compress(null, 0, null, 0, 1);
    immutable auto okCode = 0;
    assertNotThrown(ZSTDException.raiseIfError(okCode));
    assertThrown!ZSTDException(ZSTDException.raiseIfError(errCode));
}

alias CompressionLevel = int32_t;
