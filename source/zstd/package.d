module zstd;

public import zstd.common;
public import zstd.context;
public import zstd.dict;
public import zstd.func;

/* Meson doesn't automatically add a main function, unlike dub. */
version (unittest)
{
    debug (meson)
    {
        void main()
        {
        }
    }
}
