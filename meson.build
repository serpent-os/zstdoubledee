project('zstd-d',['d'],
    version: '1.0.0',
	license: 'Zlib',
)

shouldInstall = true
if meson.is_subproject()
	shouldInstall = false
endif

dep_zstd = dependency('libzstd',
    version: ['>=1.5.0', '<=2.0.0'],
)

subdir('source/zstd')
lib = static_library(meson.project_name(),
    sources: src_lib,
    dependencies: dep_zstd,
    include_directories: src_include,
    install: shouldInstall,
)

if get_option('tests')
    exe_test = executable(meson.project_name() + '_test',
        sources: src_lib,
        include_directories: src_include,
        dependencies: dep_zstd,
        link_with: lib,
        d_unittest: true,
    )
    test('tests', exe_test)
endif
