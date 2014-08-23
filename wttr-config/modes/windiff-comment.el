;; -*- coding: utf-8 -*-

;; windiff comment mode
(wttr/plugin:prepend-to-load-path "windiff-comment-mode")
(autoload 'windiff-comment-mode "windiff-comment-mode" nil t)
(add-to-list 'auto-mode-alist
             '("\\.wdc$" . windiff-comment-mode))

