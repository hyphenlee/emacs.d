;; -*- coding: utf-8 -*-

(require 'cl)


(if (string-equal system-type "windows-nt")
    (loop for file in (directory-files "~/.emacs.d/wttr-config/modes" t "\\.el$")
          do (load file nil nil t)))

(if (string-equal system-type "darwin")
    (mapc (lambda (filename) (load (concat "~/.emacs.d/wttr-config/modes/" filename)))
          (list ;; "ido.el"
           "evil.el"
           "ace-jump.el"
           "dired.el"
           ;;                "linum.el"
           "rtags.el"
           "auto-complete.el"
           ;;          "cedet.el"
           ;; "gtags.el"
           ;;                "xcscope.el"
           "yasnippet.el"
           "helm.el"
           "cc.el"
           "org.el")))
(provide 'wttr-modes)
