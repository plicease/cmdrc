use strict;
use warnings;
use 5.040;
use feature qw( say );
use Path::Tiny qw( path );
use lib '.';
use Bootstrap;

# packages
if(1) {
    my @packages = (
        { name => 'Mozilla.Firefox' },
        { name => 'Notepad++.Notepad++' },
        { name => 'GoLang.Go' },
        { name => 'Rustlang.Rustup' },
        { name => 'chrisant996.Clink' },
        { name => 'Starship.Starship',
          cb => sub {
              my $path = path("~/AppData/Local/clink/starship.lua");
              if(-d $path->parent) {
                  say "updating starship config for clink";
                  $path->spew_utf8("-- starship.lua\n\nload(io.popen('starship init cmd'):read(\"*a\"))\n");
              }
          }
        },
    );

    foreach my $package (@packages) {
        run "winget install @{[ $package->{name} ]}";
        $package->{cb}->() if $package->{cb};
    }

}

# registry
if (1) {
    run "reg import cmd-aliases.reg";
}