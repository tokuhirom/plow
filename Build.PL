use strict;
use warnings;
use Module::Build;

my $build = Module::Build->new(
    license              => 'perl',
    dynamic_config       => 0,

    build_requires       => {
        'Test::More' => '0.98',
        'Test::Requires' => 0,
    },
    configure_requires   => { 'Module::Build' => '0.38' },
    requires             => {
        perl => '5.008005',
        'Exporter'                      => '0',
        'parent'                        => '0',
        'Class::XSAccessor'             => 0,
        'Path::Class'                   => 0,
        'Devel::Declare'                => 0,
        'Sub::Name'                     => 0,
        'utf8::all'                     => 0,
        'Term::ReadLine'                => 0,
        'true'                          => 0,
        'autovivification'              => 0,
        'Moo'                           => 0,
        'JSON::XS'                      => 0,
        'Furl'                          => 0,
        'URI::Escape::XS'               => 0,
        'Term::ANSIColor'               => 0,
    },

    no_index    => { 'directory' => [ 'inc' ] },
    name        => 'plow',
    module_name => 'Plow',

    script_files => ['bin/plow'],

    test_files => (-d '.git' || $ENV{RELEASE_TESTING}) ? 't/ xt/' : 't/',
    recursive_test_files => 1,
   
    create_readme  => 1,
    create_license => 1,
);
$build->create_build_script();
