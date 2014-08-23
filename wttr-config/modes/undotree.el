;; -*- coding: utf-8 -*-

;; undo tree mode
(wttr/plugin:prepend-to-load-path "undo-tree-0.3")
(require 'undo-tree)
(global-undo-tree-mode)
