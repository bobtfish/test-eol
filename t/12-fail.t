use strict;

use Test::More qw(no_plan);

use File::Temp qw( tempdir tempfile );

my $perl  = $^X || 'perl';
my $inc = join(' -I ', map { qq{"$_"} } @INC) || '';
$inc = "-I $inc" if $inc;

{
    my $dir = make_bad_file_1();
    my (undef, $outfile) = tempfile();
    ok( `$perl $inc -MTest::EOL -e "all_perl_files_ok( '$dir' )" 2>&1 > $outfile` );
    local $/ = undef;
    open my $fh, '<', $outfile or die $!;
    my $content = <$fh>;
    like( $content, qr/^not ok 1 - No windows line endings in '[^']*' on line 4/m, 'windows EOL found in tmp file 1' );
    unlink $outfile;
}
{
    my $dir = make_bad_file_2();
    my (undef, $outfile) = tempfile();
    ok( `$perl $inc -MTest::EOL -e "all_perl_files_ok( '$dir' )" 2>&1 > $outfile` );
    open my $fh, '<', $outfile or die $!;
    local $/ = undef;
    my $content = <$fh>;
    like( $content, qr/^not ok 1 - No windows line endings in '[^']*' on line \d+/m, 'windows EOL found in tmp file2 ' );
    unlink $outfile;
}
{
    my ($dir, $file) = make_bad_file_3();
    my (undef, $outfile) = tempfile();
    ok( `$perl $inc -MTest::EOL -e "all_perl_files_ok( '$file' )" 2>&1 > $outfile` );
    open my $fh, '<', $outfile or die $!;
    local $/ = undef;
    my $content = <$fh>;
    like( $content, qr/^not ok 1 - No windows line endings in '[^']*' on line \d+/m, 'windows EOL found in tmp file 3' );
    unlink $outfile;
}

{
    my $dir = make_bad_file_4();
    my (undef, $outfile) = tempfile();
    ok( `$perl $inc -MTest::EOL -e "all_perl_files_ok({trailing_whitespace => 1}, '$dir' )" 2>&1 > $outfile` );
    open my $fh, '<', $outfile or die $!;
    local $/ = undef;
    my $content = <$fh>;
    like( $content, qr/^not ok 1 - No windows line endings in '[^']*' on line \d+/m, 'windows EOL found in tmp file 4' );
    unlink $outfile;
}

sub make_bad_file_1 {
  my $tmpdir = tempdir( CLEANUP => 1 );
  my ($fh, $filename) = tempfile( DIR => $tmpdir, SUFFIX => '.pL' );
  print $fh <<"DUMMY";
#!perl

sub main {
    print "Hello!\r\n";
}
DUMMY
  return $tmpdir;
}

sub make_bad_file_2 {
  my $tmpdir = tempdir( CLEANUP => 1 );
  my ($fh, $filename) = tempfile( DIR => $tmpdir, SUFFIX => '.pL' );
  print $fh <<"DUMMY";
#!perl

=pod

=head1 NAME

test.pL -	A test script

=cut

sub main {
    print "Hello!\n";
}
DUMMY
  return $tmpdir;
}

sub make_bad_file_3 {
  my $tmpdir = tempdir( CLEANUP => 1 );
  my ($fh, $filename) = tempfile( DIR => $tmpdir, SUFFIX => '.pm' );
  print $fh <<"DUMMY";
use strict;

package My::Test;

sub new {
    my (\$class) = @_;
    my \$self = bless { }, \$class;
    return \$self;
}


1;
DUMMY
  close $fh;
  return ($tmpdir, $filename);
}

sub make_bad_file_4 {
  my $tmpdir = tempdir( CLEANUP => 1 );
  my ($fh, $filename) = tempfile( DIR => $tmpdir, SUFFIX => '.pL' );
  print $fh <<"DUMMY";
#!perl

=pod

=head1 NAME

test.pL -	A test script

=cut

sub main {
DUMMY

print $fh qq{    print "Hello!\n";   \n}; # <-- whitespace
print $fh '}';

  return $tmpdir;
}

