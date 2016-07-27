;; -*- coding: utf-8 -*-
(require 'wttr-utils)

(when wttr/os:windowsp
  (wttr/prepend-to-exec-path "c:/Python27"))

;(add-to-list 'python-mode-hook
;             (lambda () (require 'pycomplete)))

;; python mode
;; (wttr/plugin:prepend-to-load-path "python-enhance")
(setq-default py-indent-offset 4)
(autoload 'python-mode "python-mode" "Python Mode." t)
(add-to-list 'auto-mode-alist '("\\.py$\\'" . python-mode))
(add-to-list 'auto-mode-alist '("\\.py$\\'" . elpy-mode))
(add-to-list 'interpreter-mode-alist '("python" . python-mode))

;;
;; pip install -r requirements.txt

;; jedi suite
;; (wttr/plugin:prepend-to-load-path "jedi-suite/ctable")
;; (wttr/plugin:prepend-to-load-path "jedi-suite/epc")
;; (wttr/plugin:prepend-to-load-path "jedi-suite/deferred")
;; (wttr/plugin:prepend-to-load-path "jedi-suite/jedi")
;; (setq jedi:setup-keys t)
;; (setq jedi:complete-on-dot t)

;; (autoload 'jedi:setup "jedi" nil t)
;; (add-hook 'python-mode-hook
;;           (lambda ()
;;            (jedi:setup)
;;             (jedi:ac-setup)))

