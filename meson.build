project ('com.github.dcharles525.caroline', 'vala', 'c')

pkgconfig = import('pkgconfig')

deps = [
  dependency('glib-2.0'),
  dependency('gtk+-3.0'),
  dependency('gobject-2.0'),
  dependency('gee-0.8')
]

api='0.2'

lib_sources = files(
  'Caroline.vala'
)

test_sources = files(
  'UnitTests.vala'
)

lib = shared_library('caroline-'+api, lib_sources,
                        dependencies: deps,
                        install: true)

headerfilename = meson.current_build_dir () + '/caroline-' + api + '.h'
run_command('touch', headerfilename)
install_headers(headerfilename,
                subdir: 'caroline-' + api)

vapifilename = meson.current_build_dir() + '/caroline-' + api + '.vapi'
run_command('touch', vapifilename)
install_data(sources: vapifilename,
             install_dir: get_option('datadir') + '/vala/vapi')

install_data(sources: [meson.current_source_dir() + '/caroline-' + api + '.deps'],
             install_dir: get_option('datadir') + '/vala/vapi')

test_unit = 'caroline-vala'
exe = executable(test_unit,test_sources,
                        link_with: lib,
                        dependencies: deps)

pkgconfig.generate(libraries: [lib],
                   subdirs: 'caroline-0.2',
                   version: api,
                   name: 'caroline',
                   filebase: 'caroline-' + api,
                   requires: ['glib-2.0', 'gobject-2.0', 'gtk+-3.0', 'gee-0.8'],
                   description: 'A simple Cairo Chart Library for GTK and Vala')

test(test_unit, exe)
