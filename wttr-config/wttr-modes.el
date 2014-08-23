;; -*- coding: utf-8 -*-

(require 'cl)


(loop for file in (directory-files "~/.emacs.d/wttr-config/modes" t "\\.el$")
      do (load file nil nil t))


(provide 'wttr-modes)
