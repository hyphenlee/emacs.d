;; -*- coding: utf-8 -*-

;;;; global
(setq viper-expert-level 5)
(setq viper-always t)
(setq viper-custom-file-name "~/.viper")

;;;; UI
(setq viper-inhibit-startup-message 't)
(setq viper-minibuffer-vi-face nil)
(setq viper-minibuffer-emacs-face nil)
(setq blink-matching-paren 't)
;(setq viper-vi-state-id (concat (propertize "<N>" 'face '(:foreground "white" :background "blue")) " "))
;(setq viper-emacs-state-id (concat (propertize "<E>" 'face '(:foreground "white" :background "red")) " "))
;(setq viper-insert-state-id (concat (propertize "<I>" 'face '(:foreground "black" :background "green")) " "))
;(setq viper-replace-state-id (concat (propertize "<R>" 'face '(:foreground "black" :background "yellow")) " "))

;;;; search
(setq viper-case-fold-search 't)
(setq viper-re-search 't)
(setq viper-search-wrap-around 't)
(setq viper-re-query-replace 't)

;;;; control
(setq viper-vi-style-in-minibuffer nil)
(setq viper-no-multiple-ESC 't)
(setq viper-fast-keyseq-timeout 200)
(setq viper-ex-style-motion t)
(setq viper-ex-style-editing t)
(setq viper-ESC-move-cursor-back t)
(setq viper-want-emacs-keys-in-insert t)
(setq viper-want-emacs-keys-in-vi t)
(setq viper-keep-point-on-repeat nil)
(setq viper-keep-point-on-undo nil)
(setq viper-delete-backwards-in-replace t)
(setq ex-cycle-other-window nil)
(setq ex-cycle-through-non-files nil)
(setq viper-allow-multiline-replace-regions t)

;;;; auto
(setq-default require-final-newline 't)

;;;; indent
(setq-default viper-auto-indent 't)
(setq-default viper-electric-mode 't)
(setq-default tab-width 4)
(setq viper-shift-width 4)

;;;; emacs
(setq viper-want-ctl-h-help 't)
(setq viper-tags-file-name "TAGS")
(setq viper-spell-function 'ispell-region)


;;;; key map
; normal mode
(defun wttr/kill-buffer ()
  (interactive)
  (if server-buffer-clients
      (server-kill-buffer))
  (kill-buffer (current-buffer)))

(define-key viper-vi-global-user-map (kbd "zf") 'ido-find-file)
(define-key viper-vi-global-user-map (kbd "zr") 'revert-buffer-with-coding-system)
(define-key viper-vi-global-user-map (kbd "zc") 'wttr/kill-buffer)
(define-key viper-vi-global-user-map (kbd "zk") 'ido-kill-buffer)
(define-key viper-vi-global-user-map (kbd "zo") 'other-window)
(define-key viper-vi-global-user-map (kbd "zw") 'ido-write-file)
(define-key viper-vi-global-user-map (kbd "zb") 'ido-switch-buffer)
(define-key viper-vi-global-user-map (kbd "zB") 'ido-switch-buffer-other-window)
(define-key viper-vi-global-user-map (kbd "zn") 'next-buffer)
(define-key viper-vi-global-user-map (kbd "zp") 'previous-buffer)
(define-key viper-vi-global-user-map (kbd "C-s") 'save-buffer)
(define-key viper-vi-global-user-map (kbd "zg") 'rgrep)
(define-key viper-vi-global-user-map (kbd "SPC") 'ace-jump-mode)
; insert-global
;(define-key viper-insert-global-user-map (kbd "C-s") 'save-buffer)


;;;; mode setting
; grep mode
(add-to-list 'viper-vi-state-mode-list 'grep-mode)


;;;; ===================end============================

;viper-glob-function
;viper-replace-overlay-face
;viper-replace-overlay-cursor-color
;viper-insert-state-cursor-color
;viper-emacs-state-cursor-color
;viper-replace-region-end-delimiter
;viper-replace-region-start-delimiter
;viper-use-replace-region-delimiters
;viper-toggle-key "\C-z"
;viper-surrounding-word-function
;viper-search-face
;viper-vi-state-hook
;viper-insert-state-hook
;viper-replace-state-hook
;viper-emacs-state-hook
;viper-load-hook
;viper-vi-global-user-map
;viper-insert-global-user-map
;viper-emacs-global-user-map

;viper-buffer-search-char
;(viper-buffer-search-enable)
;viper-minibuffer-vi-face
;(copy-face 'default 'viper-minibuffer-vi-face)
;(copy-face 'default 'viper-minibuffer-insert-face)
;(copy-face 'default 'viper-minibuffer-emacs-face)

;(define-key viper-vi-global-user-map ",e" 'ido-find-file)
