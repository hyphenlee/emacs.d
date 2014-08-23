;; -*- coding: utf-8 -*-

;; powershell-mode
(wttr/plugin:prepend-to-load-path "powershell-mode-0.5")
(autoload 'powershell-mode "powershell-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.ps[12]?$" . powershell-mode))
(require 'powershell)
