;; -*- coding: utf-8 -*-
(wttr/plugin:prepend-to-load-path "csharp-mode")
(autoload 'csharp-mode "csharp-mode-0.8.5" nil t)
(add-to-list 'auto-mode-alist '("\\.cs$" . csharp-mode))
