use strict;
use warnings;
use feature qw( say );
use Path::Tiny qw( path );
use Capture::Tiny qw( capture_stdout );

# TODO: grep, nano

say "which=where \$*";

my $out = capture_stdout { system 'coreutils', '--list' };

my %sp = (
    ls => { ls => 'ls --color=auto -CF $*', 
            dir => 'ls --color=auto -lF $*'
    },
    cp => 'cp -i $*',
    rm => 'rm -i $*',
    mv => 'mv -i $*',
    df => 'df -h $*',
);

foreach my $cmd (split /\s+/, $out) {
    if($sp{$cmd}) {
        if(ref $sp{$cmd} eq 'HASH') {
            foreach my $alias (sort keys $sp{$cmd}->%*) {
                my $exe  = $sp{$cmd}->{$alias};
                say "$alias=coreutils $exe";
            }
        } else {
            say "$cmd=coreutils $sp{$cmd}";
        }
    } else {
        say "$cmd=coreutils $cmd \$*"
    }
}