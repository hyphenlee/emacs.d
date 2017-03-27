;; -*- coding: utf-8 -*-

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.

(package-initialize)

(setq paradox-github-token "7c3823a852f919c1390fefb4b3c2ffcc764c9be8")
(add-to-list 'load-path "~/.emacs.d/wttr-config")
(require 'wttr-font)
(require 'wttr-basic)
(require 'wttr-mode-line)
(require 'wttr-modes)
(require 'wttr-key)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-revert-interval 1 t)
 '(package-selected-packages
   (quote
    (vmd-mode paradox esup protobuf-mode nlinum yafolding vimish-fold yagist json-mode ac-clang nginx-mode ob-browser neotree icicles nyan-mode key-chord evil-escape elpy org-tree-slide epresent ox-html5slide mongo org-bullets rinari baidu-life color-theme-solarized switch-window company gnuplot org-alert magit-svn highlight-tail magit-popup magit starter-kit-ruby slime-volleyball ruby-end ruby-dev popup markdown-mode+ jumblr json-rpc image+ highlight-indentation helm-zhihu-daily helm-projectile helm-emmet helm-ag golden-ratio git-rebase-mode flycheck ducpel color-theme cmake-mode autopair auto-package-update anaconda-mode ample-regexps ace-isearch 2048-game)))
 '(paradox-automatically-star t)
 '(scheme-program-name "scheme"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'downcase-region 'disabled nil)


