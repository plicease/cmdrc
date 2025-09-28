package Bootstrap;

use strict;
use warnings;
use feature qw( say );
use experimental qw( signatures );
use Exporter qw( import );

our @EXPORT = qw( run );

sub run ($cmd) {
    say "+$cmd";
    system $cmd;
    die "command failed" unless $? == 0;

}

1;