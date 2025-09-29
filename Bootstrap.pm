package Bootstrap;

use strict;
use warnings;
use feature qw( say );
use experimental qw( signatures );
use Exporter qw( import );

our @EXPORT_OK = qw( run add_path );

sub run ($cmd) {
    say "+$cmd";
    system $cmd;
    die "command failed" unless $? == 0;
    reload_path();
}

package Bootstrap::WeirdRegistryShit;

use Win32API::Registry 0.21 qw( 
    RegOpenKeyEx
    RegQueryValueEx
    RegSetValueEx
    RegCloseKey
    HKEY_LOCAL_MACHINE
    HKEY_CURRENT_USER
    KEY_READ KEY_WRITE
);
use Env qw( @PATH );
use Path::Tiny qw( path );

sub Bootstrap::add_path ($dir) {
    return unless -d $dir;

    my $key;

    RegOpenKeyEx( HKEY_CURRENT_USER, "Environment", 0, KEY_READ | KEY_WRITE, $key);

    my $lookup = sub ($name) {
        my $type;
        my $data;
        RegQueryValueEx($key, $name, [], $type, $data, []) or die $^E;
        return $data;
    };

    {
        my $old = $lookup->("Path");
        my $new = "$old;$dir";
        RegSetValueEx( $key, "Path", 0, 2, $new) or die $^E;
    }

    RegCloseKey($key) or die $^E;
}

sub Bootstrap::reload_path {
    my $key;

    @PATH = ();

    {
        my $bin = path("~/bin");
        if(-d $bin) {
            push @PATH, "$bin" =~ s!/!\\!rg;
        }
    }

    RegOpenKeyEx( HKEY_LOCAL_MACHINE, "SYSTEM\\CurrentControlSet\\Control\\Session Manager\\Environment", 0, KEY_READ, $key)
      or die $^E;

    my $lookup = sub ($name) {
        my $type;
        my $data;
        RegQueryValueEx($key, $name, [], $type, $data, []) or die $^E;
        return $data;
    };

    foreach my $dir (split /;/, $lookup->("Path")) {
        $dir =~ s/%(.*?)%/$ENV{$1}/eg;
        $dir =~ s/\\\z//;
        push @PATH, $dir;
    }

    RegCloseKey($key) or die $^E;

    RegOpenKeyEx( HKEY_CURRENT_USER, "Environment", 0, KEY_READ, $key);
    
    foreach my $dir (split /;/, $lookup->("Path")) {
        $dir =~ s/%(.*?)%/$ENV{$1}/eg;
        $dir =~ s/\\\z//;
        push @PATH, $dir;
    }

    RegCloseKey($key) or die $^E;

    return;
}

1;
