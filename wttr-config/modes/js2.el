;; -*- coding: utf-8 -*-
(wttr/plugin:prepend-to-load-path "js2-mode-20090723")
(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
