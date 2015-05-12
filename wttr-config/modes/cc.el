;; -*- coding: utf-8 -*-
(setq-default c-basic-offset 4)
(defun wttr/cc-mode:basic-setup ()
  "Set setting for cc mode"
  (c-set-style "stroustrup"))
  ;; (c-toggle-auto-hungry-state))
;;(modify-syntax-entry ?_ "w" c++-mode-syntax-table)
(add-hook 'c-mode-common-hook 'wttr/cc-mode:basic-setup)
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
