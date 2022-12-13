project('zstdoubledee',['d'],
    version: '0.0.2',
	license: 'Zlib',
)

shouldInstall = true
if meson.is_subproject()
	shouldInstall = false
endif

dep_zstd = dependency('libzstd',
    version: ['>=1.5.0', '<=2.0.0'],
)

subdir('source/zstdd')
lib = static_library(meson.project_name(),
    sources: src_lib,
    dependencies: [dep_zstd],
    include_directories: include_directories('source'),
    install: shouldInstall,
)

if get_option('tests')
    subdir('tests')
endif
