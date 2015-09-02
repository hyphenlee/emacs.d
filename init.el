;; -*- coding: utf-8 -*-

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(add-to-list 'load-path "~/.emacs.d/wttr-config")
(require 'wttr-font)
(require 'wttr-basic)
(require 'wttr-color-theme)
(require 'wttr-mode-line)
(require 'wttr-modes)
(require 'wttr-key)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (yasnippet visual-regexp-steroids virtualenv swift-mode starter-kit-ruby slime-volleyball skewer-mode ruby-end ruby-dev ruby-additional popup org-page org-journal markdown-mode+ jumblr image+ highlight-indentation helm-zhihu-daily helm-swoop helm-projectile helm-emmet helm-ag golden-ratio flycheck ducpel color-theme autopair auto-package-update anaconda-mode ample-regexps 2048-game)))
 '(scheme-program-name "petite"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:weight normal :height 100 :width normal)))))
