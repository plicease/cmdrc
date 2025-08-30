@echo off
doskey /macrofile=%userprofile%\\cmd\\aliases.mac
PATH %userprofile%\bin;%PATH%
if defined CLINK_DIR (
    "%CLINK_DIR%\clink.bat" inject --autorun profile ~\clink
)