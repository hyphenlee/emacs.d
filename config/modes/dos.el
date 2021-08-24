;; -*- coding: utf-8 -*-

(wttr/plugin:prepend-to-load-path "dos-2.16")
(autoload 'dos-mode "dos" "Edit Dos scripts." t)
(add-to-list 'auto-mode-alist '("\\.bat$" . dos-mode))
(add-to-list 'auto-mode-alist '("\\.cmd$" . dos-mode))
