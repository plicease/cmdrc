@echo off
doskey /macrofile=%userprofile%\\cmd\\aliases.mac
if defined CLINK_DIR (
    "%CLINK_DIR%\clink.bat" inject --autorun profile ~\clink
)