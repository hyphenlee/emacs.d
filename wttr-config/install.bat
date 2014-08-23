@echo off
REG ADD "HKCR\*\shell\open with emacs...\command" /ve /d "e:\Tools\Emacs\bin\emacsclientw.exe \"%%1\" -a e:\Tools\Emacs\bin\runemacs.exe"
