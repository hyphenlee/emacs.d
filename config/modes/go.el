;; -*- coding: utf-8 -*-
;; (defun auto-complete-for-go ()
;; (auto-complete-mode 1))
;; (require 'auto-complete)
;; (add-hook 'go-mode-hook 'auto-complete-for-go)
;; (with-eval-after-load 'go-mode
;; (require 'go-autocomplete))
(defun my-go-mode-hook ()
                                        ; Use goimports instead of go-fmt
  (setq gofmt-command "goimports")
  ;; (auto-complete-mode)
                                        ; Call Gofmt before saving
  (add-hook 'before-save-hook 'gofmt-before-save)
                                        ; Customize compile command to run go build
  (if (not (string-match "go" compile-command))
      (set (make-local-variable 'compile-command)
           "go build -v && go test -v && go vet"))
                                        ; Godef jump key binding
  (local-set-key (kbd "M-.") 'godef-jump)
  (local-set-key (kbd "<f12>") 'godef-jump)
  (local-set-key (kbd "C--") 'pop-tag-mark)
  (local-set-key (kbd "<mouse-4>") 'pop-tag-mark)
  (local-set-key (kbd "<mouse-5>") 'godef-jump)
  (require 'company)
  (require 'company-go)
  (yas-minor-mode)
  (setq dap-auto-configure-features '(sessions locals controls tooltip))
  (require 'dap-go)
  )
(add-hook 'go-mode-hook 'my-go-mode-hook)

