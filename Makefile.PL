use inc::Module::Install 0.78;

name     'Test-EOL';
license  'perl';
author   'Tomas Doran <bobtfish@bobtfish.net>';

all_from 'lib/Test/EOL.pm';
requires 'Test::More';
requires 'Test::Builder';
requires 'File::Spec';
requires 'FindBin';
requires 'File::Find';

resources repository => 'git://github.com/bobtfish/perl-test-eol.git';

if ($Module::Install::AUTHOR) {
    system("pod2text lib/Test/EOL.pm > README") and die;
}

WriteAll;

