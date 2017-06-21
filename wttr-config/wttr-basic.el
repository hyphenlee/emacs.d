;; -*- coding: utf-8 -*-
(require 'wttr-utils)
;; set user information
(menu-bar-mode 'nil)
;; (desktop-save-mode 1)
(setq default-directory "~/")
(package-initialize)
(setq create-lockfiles nil)
(modify-syntax-entry ?_ "w")
(auto-fill-mode -1)
(highlight-tail-mode)
;; visual regexp
;; (require 'visual-regexp-steroids)
;; (define-key global-map (kbd "C-r") 'vr/isearch-backward)
;; (define-key global-map (kbd "C-s") 'vr/isearch-forward)
;; (define-key global-map (kbd "M-%") 'vr/replace)
;; (define-key global-map (kbd "C-M-%") 'vr/query-replace)

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

;; auto maximize window after emacs startup
                                        ; (run-with-idle-timer 0.2 nil 'w32-maximize-frame)
;; (when wttr/os:windowsp
;;  (add-to-list 'emacs-startup-hook #'wttr/w32-maximize-frame))

                                        ;===================================
                                        ; Control
                                        ;===================================
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
(cond
 (wttr/os:windowsp
       (progn (setq file-name-coding-system 'utf-8)
(set-language-environment 'Chinese-GBK)))
(wttr/os:osxp
(progn (setq file-name-coding-system 'utf-8)
(set-language-environment 'utf-8)
(setq mac-option-modifier 'super)
(setq mac-command-modifier 'meta)
(defun system-move-file-to-trash (file)
(call-process "trash" nil nil nil file))
)))

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

;; set default mode to text-mode, seems useless.
                                        ;(setq-default major-mode 'text-mode)

;; set startup scrach buffer to another mode
                                        ; (setq initial-major-mode 'text-mode)

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

;; add extra binary path
;; it seems the "find" in "unix-utils-bin" works better and the
;; on in the "etc", so we put "ect" after "unix-utils-bin"
(cond (wttr/os:windowsp
       (mapc #'wttr/prepend-to-exec-path
             (list  "C:/emacs-24.3/bin"
                    "C:/MinGW/bin"
                    "C:/Program Files (x86)/Git/bin"
                    "~/.emacs.d/extra-bin/gnuwin32"
                    "~/.emacs.d/extra-bin/clang-server"
                    "~/.emacs.d/extra-bin/unix-utils-bin"
                    "C:/cygwin/bin"
                    "c:/Program Files/MySQL/MySQL Server 5.6/bin"
                    "C:/Program Files (x86)/cmake/bin"
                    "c:/Program Files (x86)/Microsoft Visual Studio 11.0/VC/bin"
                    "c:/Program Files (x86)/Microsoft Visual Studio 11.0/Common7/IDE"
                    "C:/phantomjs/bin"
                    "C:/Program Files/Python36"
                    )))
      (wttr/os:osxp
       (mapc #'wttr/prepend-to-exec-path
             (list
              "~/.emacs.d/plugins/rtags/bin"
              "~/.emacs.d/extra-bin/"
              "~/.emacs.d/plugins/clang-async"
              "/usr/local/bin"
              "/usr/bin"
              "/bin"
              "/usr/sbin"
              "/sbin"
              "~/.bin"
              ))))

;;copy line
(defun copy-line ()
  (interactive)
  (kill-ring-save (save-excursion
                    (back-to-indentation)
                    (point))
                  (line-end-position))
  (message "line copied"))

;; (wttr/plugin:prepend-to-load-path "w3m")
;; (require 'w3m-load)
(defun indent-buffer()
  (interactive)
  (indent-region (buffer-end 0) (buffer-end 1)))

(require 'package) ;; You might already have this line
;; (add-to-list 'package-archives
             ;; '("melpa" . "http://elpa.zilongshanren.com/melpa/") t)
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line

;; (add-to-list 'auto-mode-alist '("\\.txt$" . view-mode))
;; (modify-coding-system-alist 'file "\\.txt\\'" 'gb18030)

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
;;color theme
(require 'color-theme)
;; (color-theme-solarized)
(server-start)
(idle-highlight-mode t)
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
(setq auto-revert-interval 1)
(require 'spaceline-config)
(spaceline-spacemacs-theme)
(spaceline-helm-mode)
(global-nlinum-mode)
(require 'spacemacs-dark-theme)
(provide 'wttr-basic)

