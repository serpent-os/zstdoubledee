project('zstd-d',['d'],
    version: '1.0.0',
	license: 'Zlib',
)

dep_zstd = dependency('libzstd',
    version: ['>=1.5.0', '<=2.0.0'],
)

subdir('source/zstd')
lib = library(meson.project_name(),
    sources: src_lib,
    dependencies: dep_zstd,
    include_directories: src_include,
    install: true,
    version: meson.project_version(),
)

pkg = import('pkgconfig')
pkg.generate(lib,
    subdirs: 'd/zstd',
)
install_subdir('source/zstd',
    install_dir: get_option('includedir') / 'd',
    exclude_files: ['meson.build'],
)

if get_option('tests')
    exe_test = executable(meson.project_name() + '_test',
        sources: src_lib,
        include_directories: src_include,
        dependencies: dep_zstd,
        link_with: lib,
        install: false,
        d_unittest: true,
        d_debug: [true, 'meson'],
    )
    test('tests', exe_test)
endif
