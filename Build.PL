use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Badge::GoogleTalk',
    license             => 'perl',
    dist_author         => 'Rakesh Kumar Shardiwal <rakesh.shardiwal@gmail.com>',
    dist_version_from   => 'lib/Badge/GoogleTalk.pm',
    requires => {
        'Test::More' => 0,
        'version'    => 0,
	'WWW::Mechanize' => 0
    },
    add_to_cleanup      => [ 'Badge-GoogleTalk-*' ],
);

$builder->create_build_script();
