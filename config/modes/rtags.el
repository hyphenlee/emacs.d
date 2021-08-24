;;(wttr/plugin:prepend-to-load-path "rtags/src/")

(defun my-compile-func()
  (interactive)
  (save-buffer)
  (recompile))

;; (require 'package)
;; (package-initialize)
;; (require 'rtags)
;; (require 'company)



(defun cc-hook-func()
  (local-unset-key (kbd "C-M-o"))
  (local-set-key (kbd "C-M-o") 'ff-find-other-file)
  (rtags-start-process-maybe)
  (local-set-key (kbd "<f5>") 'my-compile-func)
  (company-mode)
  (setq rtags-autostart-diagnostics t)
  (rtags-diagnostics)
  (setq rtags-completions-enabled t)
  (push 'company-rtags company-backends)
  (local-set-key (kbd "<C-tab>") (function company-complete))
  )
(add-hook 'c-mode-common-hook 'cc-hook-func)

;;(require 'rtags)
