;; -*- coding: utf-8 -*-

(require 'cl)

;; (if (string-equal system-type "windows-nt")
;;    (loop for file in (directory-files "~/.emacs.d/wttr-config/modes" t "\\.el$")
;;          do (load file nil nil t)))
(if wttr/os:win64p
    ( mapc (lambda (filename) (load (concat "~/.emacs.d/wttr-config/modes/" filename)))
           (list 
            "ace-jump.el"
            "auto-complete.el"
            "dash.el"
            "dired.el"
            "dos.el"
            "evil.el"
            "grep.el"
            "helm.el"
            "ibuffer.el"
            "org.el"
            "slime.el"
            ;; "undo-tree.el"
            ;; "yasnippet.el"
            ;; "js2.el"
            ;; "flycheck.el"
            "org-page.el"
            ;; "magit.el"
            )))
(if wttr/os:osxp
    (mapc (lambda (filename) (load (concat "~/.emacs.d/wttr-config/modes/" filename)))
          (list ;; "ido.el"
           "evil.el"
           "ace-jump.el"
           "dired.el"
           "rtags.el"
           "auto-complete.el"
           ;;           "yasnippet.el"
           "helm.el"
           "cc.el"
           "org-page.el"
           "org.el"
           "cmake.el"
                      "tts.el"
           )))
(if wttr/os:linuxp
    (mapc (lambda (filename) (load (concat "~/.emacs.d/wttr-config/modes/" filename)))
          (list 
           "evil.el"
           "ace-jump.el"
           "dired.el"
           "auto-complete.el"
           "yasnippet.el"
           "helm.el"
           "cc.el"
           ;; "rtags.el"
           "org.el"
           )))
(provide 'wttr-modes)
