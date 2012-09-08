# Check that our own source is clean
use Test::EOL;
all_perl_files_ok({ trailing_whitespace => 1 });
