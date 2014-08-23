;; -*- coding: utf-8 -*-
(require 'wttr-utils)
;; we need to add the ccl binary path
;; (when wttr/os:windowsp
;;   (wttr/prepend-to-exec-path "~/../ccl-1.7-windows")
;;   (setq inferior-lisp-program
;;         (if (getenv "PROGRAMW6432") "wx86cl64.exe" "wx86cl.exe"))
;;   (wttr/plugin:prepend-to-load-path "quicklisp" "~/../ccl-quicklisp")
;;   (autoload 'slime "slime-helper" nil t))

;; ;; we use emacs to slime repl
;; (when (boundp 'evil-emacs-state-modes)
;;   (add-to-list 'evil-emacs-state-modes 'slime-repl-mode))

(setq inferior-lisp-program "~/.emacs.d/extra-bin/sbcl/sbcl.exe")
(add-to-list 'load-path "~/.emacs.d/plugins/slime")
(require 'slime-autoloads)
(slime-setup )
