;; -*- coding: utf-8 -*-
(require 'wttr-utils)

;; (wttr/plugin:prepend-to-load-path "auto-complete-suite/pos-tip")
;; (wttr/plugin:prepend-to-load-path "auto-complete-suite/popup-el")
;; (wttr/plugin:prepend-to-load-path "auto-complete-suite/fuzzy-el")
;; (wttr/plugin:prepend-to-load-path "auto-complete-suite/auto-complete")

;; load auto-complete
;; (require 'auto-complete-config)
;; (add-to-list 'ac-dictionary-directories
             ;; (wttr/plugin:expand-file-name "auto-complete-suite/auto-complete/dict"))
;; (ac-config-default)

;; ;; use pos-tip, which is better than native popup
;; ;; 
;; ;; NOTE:
;; ;; If we do not require pos-tip explicitly, this feature will not be
;; ;; triggered, even we set `ac-quick-help-prefer-pos-tip' to t, which
;; ;; is already the default value. We can see the implementation of
;; ;; `ac-quick-help-use-pos-tip-p' to find the reason.
;; (require 'pos-tip)
;; (setq ac-quick-help-prefer-pos-tip t)   ;default is t

;; ;; Quick help will appear at the side of completion menu, so you can
;; ;; easily see the help.
;; (setq ac-use-quick-help t)
;; (setq ac-quick-help-delay 1.0)

;; behavior of completion by TAB will be changed as a behavior of
;; completion by RET
;;  - After selecting candidates, TAB will behave as RET
;;  - TAB will behave as RET only on candidate remains
;; (setq ac-dwim t)                        

;; give a key to trigger ac when it is not automatically triggered
;; (ac-set-trigger-key "<C-return>")

;; make del also trigger the ac
;; (setq ac-trigger-commands (cons 'backward-delete-char-untabify ac-trigger-commands))

;; use fuzzy mode, its interesting
;; (setq ac-fuzzy-enable t)

;; (if wttr/os:win64p (setq ac-clang-flags (list
;;                                          "-fms-extensions"
;;                                          "-fms-compatibility"
;;                                          "-IC:/Program Files (x86)/Microsoft Visual Studio 11.0/VC/include"
;;                                          "-IC:/Program Files (x86)/Microsoft Visual Studio 11.0/VC/include/sys"
;;                                          ))
;;   (setq ac-clang-flags (list
;;                         "-fms-extensions"
;;                         "-fms-compatibility"
;;                         "-D_FILE_OFFSET_BITS=64"
;;                         "-DWXUSINGDLL"
;;                         "-D__WXMAC__"
;;                         "-D__WXOSX__"
;;                         "-D__WXOSX_COCOA__"
;;                         "-I/usr/local/lib/wx/include/osx_cocoa-unicode-3.0"
;;                         "-I/usr/local/include/wx-3.0"
;;                         "-I/usr/include"
;;                         "-I/usr/local/include"
;;                         "-std=c++11"
;;                         "-stdlib=libc++"
;;                         )))



;; ;; auto complete clang
;; ;; (if wttr/os:windowsp 
;; ;;     (wttr/prepend-to-exec-path "~/.emacs.d/extra-bin/clang++"))
;; ;; (if wttr/os:win64p (wttr/prepend-to-exec-path "~/extra-bin/clang"))
;; ;; (wttr/plugin:prepend-to-load-path "auto-complete-suite/auto-complete-clang")
;; ;; (require 'auto-complete-clang)

;; ;; (defun wttr/cc-mode:auto-complete-setup ()
;; ;;   (make-local-variable 'ac-auto-start)
;; ;;   (setq ac-auto-start nil)              ;auto complete using clang is CPU sensitive
;; ;;   (setq ac-sources (append '(ac-source-yasnippet ac-source-clang) ac-sources)))
;; ;; (defun wttr/cc-mode:auto-complete-setup ()
;; ;;   (make-local-variable 'ac-auto-start)
;; ;;   (setq ac-auto-start t)              ;auto complete using clang is CPU sensitive
;; ;;   (setq ac-sources (append '(ac-source-clang ac-source-yasnippet) ac-sources)))
;; ;; (if wttr/os:osxp
;; ;;     (progn 
;; ;;       ;; (require 'rtags-ac)
;; ;;       ;; (setq ac-sources (append '(ac-source-yasnippet ac-source-rtags) ac-sources))
;; ;;       ;; (setq rtags-completions-enabled t)
;; ;;       ;;clang-async
;; ;;       ;; (wttr/plugin:prepend-to-load-path "clang-async")
;; ;;       ;; (require 'auto-complete-clang-async)
;; ;;       (defun ac-cc-mode-setup ()
;; ;;         (interactive)
;; ;;         ;; (setq ac-clang-complete-executable "~/.emacs.d/plugins/clang-async/clang-complete")
;; ;;         (setq ac-sources '( ac-source-yasnippet ac-source-variables ac-source-words-in-all-buffer)))
;; ;;         ;;  (setq ac-sources (append '(ac-source-clang-async ac-source-yasnippet) ac-sources))
;; ;;         ;;  (setq ac-sources '(ac-source-clang-async ac-source-yasnippet ac-source-words-in-all-buffer ac-source-functions ac-source-words-in-all-buffer))
;; ;;         ;; (ac-clang-launch-completion-process))
;; ;;       (add-hook 'c-mode-common-hook 'ac-cc-mode-setup)
;; ;;       (add-hook 'auto-complete-mode-hook 'ac-common-setup)))

;; (if wttr/os:linuxp
;;     (progn 
;;       ;; (require 'rtags-ac)
;;       ;; (setq ac-sources (append '(ac-source-yasnippet ac-source-rtags) ac-sources))
;;       ;; (setq rtags-completions-enabled t)
;;       ;;clang-async
;;       ;; (wttr/plugin:prepend-to-load-path "clang-async")
;;       ;; (require 'auto-complete-clang-async)
;;       (defun ac-cc-mode-setup ()
;;         (interactive)
;;         ;; (setq ac-clang-complete-executable "~/.emacs.d/plugins/clang-async/clang-complete")
;;         ;; (setq ac-sources '(ac-source-clang-async ac-source-yasnippet ac-source-variables))
;;         (setq ac-sources (append '(ac-source-yasnippet ) ac-sources))
;;         ;;  (setq ac-sources '(ac-source-clang-async ac-source-yasnippet ac-source-words-in-all-buffer ac-source-functions ac-source-words-in-all-buffer))
;;         ;; (ac-clang-launch-completion-process)
;;         )
;;       (add-hook 'c-mode-common-hook 'ac-cc-mode-setup)
;;       (add-hook 'auto-complete-mode-hook 'ac-common-setup)))
