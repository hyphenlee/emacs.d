;; -*- coding: utf-8 -*-

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.

(add-to-list 'load-path "~/.emacs.d/wttr-config")
(add-to-list 'load-path "~/.emacs.d/myelpa")
(package-initialize)
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file :noerror)
                                        ;(require 'wttr-font)
(require 'org-bullets)
(require 'wttr-basic)
;; (require 'wttr-mode-line)
(require 'wttr-modes)
(require 'wttr-key)

