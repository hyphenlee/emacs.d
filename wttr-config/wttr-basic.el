;; -*- coding: utf-8 -*-
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; (require 'benchmark-init)
;; To disable collection of benchmark data after init is done.
;; (add-hook 'after-init-hook 'benchmark-init/deactivate)
(require 'wttr-utils)
;; set user information
(menu-bar-mode 'nil)

;; (desktop-save-mode 1)
(setq default-directory "~/")
(setq create-lockfiles nil)
(modify-syntax-entry ?_ "w")
(auto-fill-mode -1)
(setq paradox-github-token "d891d68c8184c331bf8f3b5a7097355ea11225f2")
(defun load-work-file()
  (interactive )
  (find-file "~/note/work.org"))
(defun load-note-file()
  (interactive )
  (find-file "~/note/note.org"))
(define-key global-map (kbd "M-4") 'load-note-file)
;;====================================
;;  UI
;;====================================
;; close startup message
(setq inhibit-startup-message t)

;; turn on syntax hilight
(global-font-lock-mode t)

;; remove toolbar/menu bar/scroll bar
(tool-bar-mode 0)
;;(menu-bar-mode 0)
(set-scroll-bar-mode nil)

;; show clock at statusline
(display-time-mode t)
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)
(setq display-time-use-mail-icon t)
(setq display-time-interval 10)

;; show column number in mode line
(setq column-number-mode t)

;; show parent
(show-paren-mode t)
(setq show-paren-style 'parenthesis)

;; hilight mark area
(transient-mark-mode t)

;; make the title infomation more useful
(setq frame-title-format
      (list "GNU Emacs " emacs-version "@" system-name " - " '(buffer-file-name "%f" "%b")))
;; don't ring at error
(setq ring-bell-function 'ignore)

;; can use the narrow to region
(put 'narrow-to-region 'disabled nil)

;; use mouse to copy thing automatically
(setq mouse-drag-copy-region t)

;; move mouse when cursor is close to it
                                        ;(mouse-avoidance-mode 'animate)
(mouse-avoidance-mode 'none)

;; no backup file, and auto save
(setq
 backup-by-copying t      ; don't clobber symlinks
 backup-directory-alist
 '(("." . "~/.saves"))    ; don't litter my fs tree
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control t)       ; use versioned backups
(setq auto-save-default nil)

;; use y --> yes
(fset 'yes-or-no-p 'y-or-n-p)

;; setup for newline auto-appending support
(setq next-line-add-newline t)

;;encoding
(set-language-environment 'UTF-8)
;; setup up a big kill-ring, so i will never miss anything:-)
(setq kill-ring-max 1000)

(setq extended-command-history-max 500)
(setq query-replace-history-max 500)
(setq replace-string-history-max 500)
(setq file-name-history-max 500)
(setq replace-regex-history-max 500)
(setq minibuffer-history-max 1000)
(setq shell-command-history-max 1000)
(setq find-file-history-max 1000)
;; we need to paste something from another program, but sometimes we
;; do real paste after some kill action, that will erase the
;; clipboard,so we need to save it to kill ring, here is the setting
;; used to control that
(setq save-interprogram-paste-before-kill t)
(setq x-select-enable-clipboard t)

;; scroll one line at a time (less "jumpy" than defaults)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 3)))   ;; one line at a time
(setq mouse-wheel-progressive-speed nil)              ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't)                    ;; scroll window under mouse
(setq scroll-step 1)                                  ;; keyboard scroll one line at a time
(setq scroll-margin 0)                                ;; stop autoscroll when mouse is close to margin

;; not use tab, use space to indent
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

;; always split window vertically
(setq split-width-threshold nil)

;;copy line
(defun copy-line ()
  (interactive)
  (kill-ring-save (save-excursion
                    (back-to-indentation)
                    (point))
                  (line-end-position))
  (message "line copied"))

(defun indent-buffer()
  (interactive)
  (indent-region (buffer-end 0) (buffer-end 1)))


(defun xah-syntax-color-hex ()
  "Syntax color hex color spec such as 「#ff1100」 in current buffer."
  (interactive)
  (font-lock-add-keywords
   nil
   '(("#[abcdef[:digit:]]\\{6\\}"
      (0 (put-text-property
          (match-beginning 0)
          (match-end 0)
          'face (list :background (match-string-no-properties 0)))))))
  (font-lock-fontify-buffer)
  )
(defun lhf-log-color ()
  "Syntax color hex color spec such as 「#ff1100」 in current buffer."
  (interactive)
  (font-lock-add-keywords nil '(
                                ("\\<\\(ERROR\\)" 1 '(:foreground "red") t)
                                ("\\<\\(NOTICE\\)" 1 '(:foreground "green") t)
                                ("\\<\\(WARN\\)" 1 '(:foreground "yellow") t)
                                ("\\<\\(DEBUG\\)" 1 '(:foreground "yellow") t)
                                ))
  )
(server-start)
(defun backward-symbol (&optional arg)
  "Move backward until encountering the beginning of a symbol.
With argument, do this that many times."
  (interactive "p")
  (forward-symbol (- (or arg 1))))

(defun backward-same-syntax (&optional arg)
  "Move backward until encountering the beginning of a same-syntax.
With argument, do this thato many times."
  (interactive "p")
  (forward-same-syntax (- (or arg 1))))
(global-auto-revert-mode 1)
(setq auto-revert-interval 1)

(global-display-line-numbers-mode)
(setq paradox-github-token t)

(defun my-flymd-browser-function (url)
  (let ((process-environment (browse-url-process-environment)))
    (apply 'start-process
           (concat "chrome " url) nil
           "chrome"
           (list "--new-window" "--allow-file-access-from-files" url))))
(setq flymd-browser-open-function 'my-flymd-browser-function)
(setq helm-ag-base-command "rg -i --line-number --no-heading")

;; set coding config, last is highest priority.
(prefer-coding-system 'cp950)
(prefer-coding-system 'gb2312)
(prefer-coding-system 'cp936)
(prefer-coding-system 'gb18030)
(prefer-coding-system 'utf-16)
(prefer-coding-system 'utf-8-dos)
(prefer-coding-system 'utf-8-unix)

(defun lhf-update-repos ()
  "update repo"
  (interactive)
  (async-shell-command "powershell.exe C:/work/update_repo.ps1")
  )
;; (require 'color-theme-modern)
;; (require 'color-theme-sanityinc-tomorrow)
;;go lang
(add-hook 'go-mode-hook 'lsp-deferred)

;; (require 'find-file-in-project)
(helm-mode t)
(provide 'wttr-basic)
