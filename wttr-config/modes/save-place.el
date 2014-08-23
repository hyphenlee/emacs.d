;; -*- coding: utf-8 -*-

;; save place when file is close and resume next itme
(setq save-place-file "~/.emacs.d/.emacs-places")
(setq-default save-place t)                   ;; activate it for all buffers
(require 'saveplace)                          ;; get the package
