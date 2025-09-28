@echo off

winget install StrawberryPerl.StrawberryPerl

reg import cmd-aliases.reg

perl bootstrap.pl