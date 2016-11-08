;; -*- coding: utf-8 -*-
(require 'wttr-utils)

;;;; pre setting
(setq-default evil-auto-indent t)
(setq evil-shift-width 4)
(setq evil-repeat-move-cursor t)
(setq evil-find-skip-newlines nil)
(setq evil-move-cursor-back t)
(setq evil-want-fine-undo nil)
(setq evil-regexp-search t)
(setq evil-search-wrap t)
(setq evil-flash-delay 3)
(setq evil-want-C-i-jump nil)
(setq evil-want-C-u-scroll nil)

;; load
(wttr/plugin:prepend-to-load-path "evil")
(require 'evil)
                                        ;(global-set-key "\C-z" 'evil-mode)
;;(evil-mode 1)
;;(global-set-key "\C-z" 'evil-mode)
;;;; cursor appearance
                                        ;evil-default-cursor [Variable]
                                        ;The default cursor.
                                        ;evil-normal-state-cursor [Variable]
                                        ;The cursor for Normal state.
                                        ;evil-insert-state-cursor [Variable]
                                        ;The cursor for Insert state.
                                        ;evil-visual-state-cursor [Variable]
                                        ;The cursor for Visual state.
                                        ;evil-replace-state-cursor [Variable]
                                        ;The cursor for Replace state.
                                        ;evil-operator-state-cursor [Variable]
                                        ;The cursor for Operator-Pending state.
                                        ;evil-motion-state-cursor [Variable]
                                        ;The cursor for Motion state.
                                        ;evil-emacs-state-cursor [Variable]
                                        ;The cursor for Emacs state.

;;;; initial state
                                        ;evil-set-initial-state

;;;; key map
                                        ;evil-normal-state-map [Variable]
                                        ;The global keymap for Normal state.
(define-key evil-normal-state-map (kbd "C-s") 'save-buffer)

;; some auto load
(autoload 'dired-jump "dired" "dired-jump" t)
(autoload 'dired-jump-other-window "dired" "dired-jump" t)
;; add ";" sub map
(define-prefix-command 'wttr/my-evil-normal-map)
(define-key evil-normal-state-map (kbd ";") 'wttr/my-evil-normal-map)
(defun kill-current-buffer()
  (interactive)
  (kill-buffer (current-buffer)))
(mapc (lambda (info)
        (define-key wttr/my-evil-normal-map
          (read-kbd-macro (car info))
          (cdr info)))
      '(
        ("d" . ido-dired)
        ("E" . eshell)
        ("e" . kid-switch-to-shell)
        ("f" . ido-find-file)
        ("r" . revert-buffer-with-coding-system)
        ("4" . wttr/kill-buffer-may-have-clients)
        ("k" . kill-current-buffer)
        ("o" . other-window)
        ("w" . ido-write-file)
        ("b" . ido-switch-buffer)
        ("B" . ido-switch-buffer-other-window)
        ("n" . next-buffer)
        ("p" . previous-buffer)
        ("s" . save-buffer)
        ("g" . wttr/customized:rgrep)
        ("a" . wttr/customized:rgrep-using-ack)
        ("l" . ibuffer)
        ("j" . dired-jump )
        ("J" . dired-jump-other-window )
        ("i" . ispell-buffer)
        ("m" . magit-status)
        ))

(define-key evil-visual-state-map (kbd "SPC") 'scroll-up)
(define-key evil-normal-state-map (kbd "SPC") 'scroll-up)
;; opposite to C-o : evil-jump-backward
(define-key evil-normal-state-map (kbd "TAB") 'evil-jump-forward)
;; opposite to u : undo-tree-undo
(define-key evil-normal-state-map (kbd "C-r") 'undo-tree-redo)

;; replace the <c-e> to move-end-of-line
(define-key evil-insert-state-map (kbd "C-e") 'move-end-of-line)

;; we do not need c-n and c-p to evil-complete
(define-key evil-insert-state-map (kbd "C-n") 'next-line)
(define-key evil-insert-state-map (kbd "C-p") 'previous-line)

;; recover the c-k, do not trigger special char input as vim
(define-key evil-insert-state-map (kbd "C-k") 'kill-line)
;; recover the c-y, yank
(define-key evil-insert-state-map (kbd "C-y") 'yank)

(define-key evil-visual-state-map "C-q" 'evil-change-to-previous-state)
(define-key evil-insert-state-map "C-q" 'evil-normal-state)
(define-key evil-replace-state-map "C-q" 'evil-normal-state)
(require 'key-chord)
(auto-complete-mode)
(setq key-chord-two-keys-delay 0.5)
(key-chord-mode 1)
(key-chord-define evil-insert-state-map "jk" 'evil-normal-state)
;; some mode that should use emacs state
;; (dolist (mode '(dired-mode
;;                 eassist-mode
;;                 gtags-select-mode
;;                 magit-status-mode
;;                 magit-log-mode
;;                 magit-commit-mode
;;                 magit-diff-mode
;;                 org-mode
;;                 fundamental-mode
;;                 text-mode))
;;   (add-to-list 'evil-emacs-state-modes mode))

(setq evil-default-state 'emacs)
