# Exercise documented psql --version inputs through the complete public API.
# Inputs are literal examples of showVersion's output, not command receipts.

use strict;
use warnings FATAL => 'all';

use FindBin;
use lib "$FindBin::RealBin/../../src/test/perl";
use PostgreSQL::Version;
use Test::More;

sub snapshot
{
    my ($input, $plain) = @_;
    my $result = eval {
        my $version = PostgreSQL::Version->new($input);
        my $expected = PostgreSQL::Version->new($plain);
        join('|', "$version", $version->major, $version <=> $expected);
    };
    diag($@) if $@;
    return $result;
}

my @psql_cases = (
    ["18.3", "18"],
    ["9.6.24", "9.6"],
    ["19devel", "19"],
    ["18beta1", "18"],
    ["18rc2", "18"]);

for my $case (@psql_cases)
{
    my ($plain, $major) = @$case;
    is(snapshot("psql (PostgreSQL) $plain\n", $plain),
        "$plain|$major|0", "psql output: $plain");
}

is(snapshot("PostgreSQL 18.3\n", "18.3"), "18.3|18|0",
    "pg_config-style marker remains supported");
is(snapshot(12, "12"), "12|12|0",
    "numeric constructor input remains supported");

my $legacy = PostgreSQL::Version->new("9.6.24");
is($legacy->major(separator => '_'), "9_6",
    "legacy major separator remains unchanged");

my $development = PostgreSQL::Version->new("19devel");
cmp_ok($development, '<', PostgreSQL::Version->new("19"),
    "existing development-before-release comparison remains unchanged");

done_testing();
