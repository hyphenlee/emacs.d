;; -*- coding: utf-8 -*-
(wttr/plugin:prepend-to-load-path "xcscope")
(require 'xcscope)
(if wttr/os:win64p (wttr/prepend-to-exec-path "~/.emacs.d/extra-bin/gtags"))
(global-set-key (kbd "C-c C-f") 'cscope-find-this-symbol )
(set-variable 'cscope-program "gtags-cscope")
(set-variable 'cscope-database-file "GTAGS")
