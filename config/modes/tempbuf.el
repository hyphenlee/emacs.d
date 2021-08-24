;; -*- coding: utf-8 -*-

(wttr/plugin:prepend-to-load-path "tempbuf-mode")
(require 'tempbuf)
(add-hook 'help-mode-hook 'turn-on-tempbuf-mode)
(add-hook 'grep-mode-hook 'turn-on-tempbuf-mode)
;(add-hook 'gtags-select-mode-hook 'turn-on-tempbuf-mode)
