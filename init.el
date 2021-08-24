;; -*- coding: utf-8 -*-
(add-to-list 'load-path "~/.emacs.d/config")
(package-initialize)
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file :noerror)
(require 'basic)
(require 'modes)
(require 'key)

