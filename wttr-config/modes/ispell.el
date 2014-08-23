;; -*- coding: utf-8 -*-

(autoload 'ispell-buffer "ispell" "spell check the current buffer" t)
(when wttr/os:windowsp
  (wttr/prepend-to-exec-path "~/.emacs.d/extra-bin/aspell/bin")
  (setq ispell-program-name "aspell"))
(setq ispell-dictionary "british")
