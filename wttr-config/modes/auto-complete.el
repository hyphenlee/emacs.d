;; -*- coding: utf-8 -*-
(require 'wttr-utils)

(wttr/plugin:prepend-to-load-path "auto-complete-suite/pos-tip")
(wttr/plugin:prepend-to-load-path "auto-complete-suite/popup-el")
(wttr/plugin:prepend-to-load-path "auto-complete-suite/fuzzy-el")
(wttr/plugin:prepend-to-load-path "auto-complete-suite/auto-complete")

;; load auto-complete
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories
             (wttr/plugin:expand-file-name "auto-complete-suite/auto-complete/dict"))
(ac-config-default)

;; use pos-tip, which is better than native popup
;; 
;; NOTE:
;; If we do not require pos-tip explicitly, this feature will not be
;; triggered, even we set `ac-quick-help-prefer-pos-tip' to t, which
;; is already the default value. We can see the implementation of
;; `ac-quick-help-use-pos-tip-p' to find the reason.
(require 'pos-tip)
(setq ac-quick-help-prefer-pos-tip t)   ;default is t

;; Quick help will appear at the side of completion menu, so you can
;; easily see the help.
(setq ac-use-quick-help t)
(setq ac-quick-help-delay 1.0)

;; behavior of completion by TAB will be changed as a behavior of
;; completion by RET
;;  - After selecting candidates, TAB will behave as RET
;;  - TAB will behave as RET only on candidate remains
(setq ac-dwim t)                        

;; give a key to trigger ac when it is not automatically triggered
(ac-set-trigger-key "<C-return>")

;; make del also trigger the ac
(setq ac-trigger-commands (cons 'backward-delete-char-untabify ac-trigger-commands))

;; use fuzzy mode, its interesting
(setq ac-fuzzy-enable t)

(setq ac-clang-flags (list
		      "-fms-extensions"
		      "-fms-compatibility"
              "-IC:/Program Files (x86)/Microsoft Visual Studio 11.0/VC/include"
              "-IC:/Program Files (x86)/Microsoft Visual Studio 11.0/VC/include/sys"
		      ))


;; auto complete clang
;; (if wttr/os:windowsp 
;;     (wttr/prepend-to-exec-path "~/.emacs.d/extra-bin/clang++"))
(wttr/prepend-to-exec-path "~/extra-bin/clang")
(wttr/plugin:prepend-to-load-path "auto-complete-suite/auto-complete-clang")
(require 'auto-complete-clang)

 ;; (defun wttr/cc-mode:auto-complete-setup ()
 ;;   (make-local-variable 'ac-auto-start)
 ;;   (setq ac-auto-start nil)              ;auto complete using clang is CPU sensitive
 ;;   (setq ac-sources (append '(ac-source-yasnippet ac-source-clang) ac-sources)))
(defun wttr/cc-mode:auto-complete-setup ()
  (make-local-variable 'ac-auto-start)
  (setq ac-auto-start nil)              ;auto complete using clang is CPU sensitive
  (setq ac-sources (append '(ac-source-clang ac-source-yasnippet) ac-sources)))
(add-hook 'c-mode-hook 'wttr/cc-mode:auto-complete-setup)
(add-hook 'c++-mode-hook 'wttr/cc-mode:auto-complete-setup)

;; system specific setting
;; (let ((extra-clang-flags (cond
;;                           (wttr/host:MSWSp

;;                            (list  "-IC:/MinGW/lib/gcc/mingw32/4.8.1/include"
;;                                   "-IC:/MinGW/include"
;;                                   "-IC:/MinGW/lib/gcc/mingw32/4.8.1/include/c++"
;;                                   "-IC:/MinGW/lib/gcc/mingw32/4.8.1/include/c++/mingw32"
;;                                  "-D__MSVCRT__="))
;;                           ;; (wttr/host:HOMEp
;;                           ;;  (list  "-IC:/MinGW/include/c++/3.4.5"
;;                           ;;         "-IC:/MinGW/include"
;;                           ;;         "-IC:/MinGW/lib/gcc/mingw32/3.4.5/include"
;;                           ;;         "-IC:/MinGW/include/c++/3.4.5/mingw32"
;;                           ;;        "-D__MSVCRT__"))
;;                           (t
;;                            nil))))
;;   (setq ac-clang-flags extra-clang-flags))
;(when (string-equal (system-name) "WINTERTTR-WS")
;  (setq ac-clang-flags (mapcar (lambda (x) (concat "-I" x)) 
;                               (list "D:/src/zephyr/perf/OTHERS/STDCPP/INCLUDE"
;                                     "D:/src/zephyr/perf/TOOLS/PUBLIC/ext/crt80/inc"
;                                     "D:/src/zephyr/perf/PUBLIC/COMMON/OAK/INC"
;                                     "D:/src/zephyr/perf/PUBLIC/COMMON/SDK/INC")))
;  (setq ac-clang-flags (cons "-D_WIN32_WCE" ac-clang-flags)))

;;;
;;; auto complete go
;;;
;; (wttr/plugin:prepend-to-load-path "auto-complete-suite/auto-complete-go")
;; (require 'go-autocomplete)
