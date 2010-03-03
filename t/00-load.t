#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Test::EOL' );
}

diag( "Testing Test::EOL $Test::EOL::VERSION, Perl $], $^X" );
