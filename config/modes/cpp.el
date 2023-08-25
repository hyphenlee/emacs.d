(add-to-list 'load-path "~/.emacs.d/myelpa/lsp")
(require 'yasnippet)
(require 'lsp-bridge)

(defun my-c-mode-hook()
  (yas-global-mode 1)
  (lsp-bridge-mode)
  (setq acm-enable-codeium 1)
  (local-set-key (kbd "M-q") 'kill-current-buffer)
  (local-set-key (kbd "<f12>") 'lsp-bridge-find-def)
  (local-set-key (kbd "C-<f12>") 'lsp-bridge-peek)
  (local-set-key (kbd "C-c r") 'lsp-bridge-rename)
  (local-set-key (kbd "S-<f12>") 'lsp-bridge-find-references)
  (local-set-key (kbd "M-<return>") 'lsp-bridge-code-action)
  (local-set-key (kbd "C-\\") 'lsp-bridge-code-format)
  )
(add-hook 'c++-mode-hook 'my-c-mode-hook)

(leaf dap-mode
  :ensure t
  :init
  (dap-mode 1)
  (dap-tooltip-mode 1)
  (dap-auto-configure-mode 1)
  (dap-ui-controls-mode 1)
  :require t dap-lldb
  :bind
  (:dap-mode-map
   ([f5] . dap-debug)
   ([f11] . dap-step-in)
   ("S-<f11>" . dap-step-out)
   ("S-<f5>" . dap-disconnect)
   ("<f10>" . dap-next)
   ("<f6>" . dap-continue)
   ("<f9>" . dap-breakpoint-toggle))
  :config
  (leaf dap-ui
    :ensure nil
    :require t
    :config
    (dap-ui-mode 1))
  :custom
  (dap-auto-configure-features . '(sessions locals breakpoints expressions repl controls tooltip))
    (dap-lldb-debug-program . `(,(expand-file-name "/usr/bin/lldb-vscode")))
  )
