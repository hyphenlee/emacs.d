;; -*- coding: utf-8 -*-
(if wttr/os:win64p
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
(if wttr/os:osxp
    (mapc (lambda (filename) (load (concat "~/.emacs.d/config/modes/" filename)))
          (list 
           "dired.el"
           "helm.el"
           ;; "org-page.el"
           "org.el"
           "cmake.el"
           "elisp.el"
           "go.el"
           "magit.el"
           )))
(if wttr/os:linuxp
    (mapc (lambda (filename) (load (concat "~/.emacs.d/config/modes/" filename)))
          (list 
           "dired.el"
           "helm.el"
           "org.el"
           )))
(provide 'modes)
