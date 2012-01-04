use strict;
use warnings;

use Test::More tests => 2;
use File::Temp qw( tempdir tempfile );

use Config;
$ENV{PERL5LIB} = join ($Config{path_sep}, @INC);

{
  my $tmpdir = tempdir( CLEANUP => 1 );
  my ($fh, $filename) = tempfile( DIR => $tmpdir, SUFFIX => '.pL' );
  print $fh "\xE1\xF3 how na\xEFve";
  close $fh;

  my (undef, $outfile) = tempfile();

  `$^X -MTest::EOL -e "all_perl_files_ok( '$tmpdir' )" >$outfile 2>&1`;
  ok(! $? );

  my $out = do { local (@ARGV, $/) = $outfile; <> };

  is (
    $out,
    "ok 1 - No incorrect line endings in '$filename'\n1..1\n",
    'no malformed unicode warnings',
  );

  unlink $outfile;
}
