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
           "org-page.el"
           "org.el"
           "cmake.el"
           "elisp.el"
           "go.el"
           "magit.el"
           )))
(if os:linuxp
    (mapc (lambda (filename) (load (concat "~/.emacs.d/config/modes/" filename)))
          (list 
           "dired.el"
           "helm.el"
           "org.el"
           "cpp.el"
           "elisp.el"
           "cmake.el"
           "magit.el"
           )))

(provide 'modes)
