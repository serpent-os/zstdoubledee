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

subdir('source')
lib = static_library(meson.project_name(),
    sources: src_lib,
    dependencies: [dep_zstd],
    install: shouldInstall,
)
