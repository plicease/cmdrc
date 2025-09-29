use strict;
use warnings;
use 5.040;
use feature qw( say );
use Path::Tiny qw( path );
use lib '.';
use Bootstrap qw( run add_path );

# packages
if(1) {
    my @packages = (
        { name => 'Mozilla.Firefox' },
        { name => 'Notepad++.Notepad++' },
        { name => 'GoLang.Go' },
        { name => 'Rustlang.Rustup',
         cb => sub {
            run "rustup toolchain install stable-x86_64-pc-windows-gnu";
            run "rustup default stable-x86_64-pc-windows-gnu"
         } },
        { name => 'chrisant996.Clink' },
        { name => 'Starship.Starship',
          cb => sub {
              my $path = path("~/AppData/Local/clink/starship.lua");
              if(-d $path->parent) {
                  say "updating starship config for clink";
                  $path->spew( {binmode => ":crlf"}, "-- starship.lua\n\nload(io.popen('starship init cmd'):read(\"*a\"))()\n");
              }
          }
        },
        { name => "Audacity.Audacity" },
        { name => "Inkscape.Inkscape" },
        { name => "Logitech.Options" },
        { name => "PuTTY.PuTTY" },
        { name => "SlackTechnologies.Slack" },
        { name => "Microsoft.VisualStudioCode" },
        { name => "OpenVPNTechnologies.OpenVPNConnect" },
        { name => "BurntSushi.ripgrep.MSVC" },
        { name => "GnuWin32.Grep",
          cb => sub {
              add_path "c:\\Program Files (x86)\\GnuWin32\\bin";
          }
        },
        { name => "GNU.Nano" },
        { name => "VideoLAN.VLC" },
        { name => "NcFTP.NcFTP" },
    );

    foreach my $package (@packages) {
        my $names = ref $package->{name} ? $package->{name} : [$package->{name}];
        foreach my $name (@$names) {
            run "winget install $name";
        }
        $package->{cb}->() if $package->{cb};
    }

}

# registry
if (1) {
    run "reg import cmd-aliases.reg";
}

# uutils
if (1) {
    run "cargo install coreutils";
    run "cargo install findutils";
    run "cargo install diffutils";
}