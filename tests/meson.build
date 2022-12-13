src_tests = [
    'main.d',
]

bin_tests = executable(meson.project_name() + '_testrunner',
    sources: src_tests,
    link_with: [lib],
    d_unittest: true,
)
test('tests', bin_tests)
