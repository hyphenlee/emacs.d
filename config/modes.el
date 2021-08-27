;; -*- coding: utf-8 -*-
(if
    os:windowsp
    ( mapc (lambda (filename) (load (concat "~/.emacs.d/config/modes/" filename)))
           (list 
            "helm.el"
            "cmake.el"
            "nsis.el"
            "org.el"
            "go.el"
            "magit.el"
            "elisp.el"
            )))
(if os:osxp
    (mapc (lambda (filename) (load (concat "~/.emacs.d/config/modes/" filename)))
          (list 
           "dired.el"
           "helm.el"
           ;; "org-page.el"
           "org.el"
           "cmake.el"
           )))
(if os:linuxp
    (mapc (lambda (filename) (load (concat "~/.emacs.d/config/modes/" filename)))
          (list 
           "dired.el"
           "helm.el"
           "org.el"
           )))
(provide 'modes)
