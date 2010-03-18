use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Badge::GoogleTalk',
    AUTHOR              => 'Rakesh Kumar Shardiwal <rakesh.shardiwal@gmail.com>',
    VERSION_FROM        => 'lib/Badge/GoogleTalk.pm',
    ABSTRACT_FROM       => 'lib/Badge/GoogleTalk.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' 	=> 0,
        'version'    	=> 0,
	'WWW::Mechanize'=> 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Badge-GoogleTalk-*' },
);
