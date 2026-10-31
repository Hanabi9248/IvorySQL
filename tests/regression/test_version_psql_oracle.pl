# Run the existing cases against the actual Oracle namespace module.
use strict;
use warnings FATAL => 'all';
use FindBin;
use Cwd qw(abs_path);
use lib "$FindBin::RealBin/../../src/oracle_test/perl";
use PostgreSQL::Version;

my $expected = abs_path(
    "$FindBin::RealBin/../../src/oracle_test/perl/PostgreSQL/Version.pm");
die "Oracle Version.pm was not loaded\n"
  unless abs_path($INC{'PostgreSQL/Version.pm'}) eq $expected;
print STDERR "Oracle module: $expected\n";

my $cases = "$FindBin::RealBin/test_version_psql.pl";
my $result = do $cases;
die $@ if $@;
die "could not read $cases: $!\n" unless defined $result;
die "Version.pm changed during regression\n"
  unless abs_path($INC{'PostgreSQL/Version.pm'}) eq $expected;
