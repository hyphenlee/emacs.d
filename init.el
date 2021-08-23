;; -*- coding: utf-8 -*-

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.

(package-initialize)

(add-to-list 'load-path "~/.emacs.d/wttr-config")
(add-to-list 'load-path "~/.emacs.d/myelpa")
                                        ;(require 'wttr-font)
(require 'org-bullets)
(require 'wttr-basic)
;; (require 'wttr-mode-line)
(require 'wttr-modes)
(require 'wttr-key)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-revert-interval 1)
 '(package-selected-packages
   '( helm magit avy helm-gitlab gitlab protobuf-mode helm-descbinds ace-jump-mode magit-gerrit dash powershell projectile helm-xref company-lsp cquery lsp-mode lsp-ui flymd monky xwidgete itail org-redmine ng2-mode nsis-mode vmd-mode paradox esup nlinum vimish-fold yagist json-mode ac-clang nginx-mode ob-browser neotree icicles nyan-mode key-chord evil-escape elpy org-tree-slide epresent ox-html5slide mongo org-bullets rinari baidu-life switch-window company gnuplot org-alert magit-svn highlight-tail magit-popup starter-kit-ruby slime-volleyball ruby-end ruby-dev popup markdown-mode+ jumblr json-rpc image+ highlight-indentation helm-zhihu-daily helm-projectile helm-emmet helm-ag golden-ratio git-rebase-mode flycheck ducpel cmake-mode autopair auto-package-update anaconda-mode ample-regexps ace-isearch))
 '(paradox-automatically-star t)
 '(scheme-program-name "scheme"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:weight normal :height 110 :width normal)))))
(put 'downcase-region 'disabled nil)


