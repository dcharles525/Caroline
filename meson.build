project ('com.github.dcharles525.caroline', 'vala', 'c')

sources = files(
  'Caroline.vala',
  'UnitTests.vala'
)

test_unit = 'unit-test'

deps = [
  dependency('glib-2.0'),
  dependency('gtk+-3.0'),
  dependency('gobject-2.0'),
  dependency('gee-0.8')
]

exe = executable(test_unit, sources: sources, dependencies : deps)
test(test_unit, exe)
