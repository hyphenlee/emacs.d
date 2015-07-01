;; -*- coding: utf-8 -*-
(require 'wttr-utils)

;; yasnippet
;;(wttr/plugin:prepend-to-load-path "yasnippet")
(require 'yasnippet)
(yas-global-mode 1)
(yas-load-directory (wttr/plugin:expand-file-name "yasnippet/snippets"))
