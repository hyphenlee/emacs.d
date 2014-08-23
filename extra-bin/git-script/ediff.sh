#! /bin/sh
HOME=/e/Tools/Emacs;/e/Tools/Emacs/bin/emacsclientw.exe --eval "(ediff-files \"$1\" \"$2\")"
