module zstd.advcomp;

import zstd.c.symbols;
public import zstd.c.typedefs : Strategy, CompressionParameter, Bounds;

Bounds getBounds(CompressionParameter cp)
{
    return ZSTD_cParam_getBounds(cp);
}

unittest
{
    const auto bounds = getBounds(CompressionParameter.CompressionLevel);
    assert(bounds.lowerBound < 0);
}
