use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'HelloWorld',
    license             => 'perl',
    dist_abstract       => 'A simple, stupid hello world test.',
    dist_author         => 'Shane Doucette <sd@zu.com>',
    build_requires => {
        'Test::More' => '0.10',
    },
);

$builder->create_build_script();

