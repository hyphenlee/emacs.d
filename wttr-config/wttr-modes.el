;; -*- coding: utf-8 -*-

;; (if (string-equal system-type "windows-nt")
;;    (loop for file in (directory-files "~/.emacs.d/wttr-config/modes" t "\\.el$")
;;          do (load file nil nil t)))

(if wttr/os:win64p
    ( mapc (lambda (filename) (load (concat "~/.emacs.d/wttr-config/modes/" filename)))
           (list 
            "helm.el"
            "company-mode.el"
            ;; "evil.el"
            "cmake.el"
            "elisp.el"
            "nsis.el"
            "org.el"
            "cc.el"
            "go.el"
            "magit.el"
            )))
(if wttr/os:osxp
    (mapc (lambda (filename) (load (concat "~/.emacs.d/wttr-config/modes/" filename)))
          (list ;; "ido.el"
           ;; "evil.el"
           "ace-jump.el"
           "dired.el"
           "rtags.el"
           ;; "auto-complete.el"
           ;;           "yasnippet.el"
           "helm.el"
           "cc.el"
           ;; "org-page.el"
           "org.el"
           "cmake.el"
           ;; "tts.el"
           )))
(if wttr/os:linuxp
    (mapc (lambda (filename) (load (concat "~/.emacs.d/wttr-config/modes/" filename)))
          (list 
           ;; "evil.el"
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
