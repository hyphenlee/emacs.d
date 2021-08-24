;; (setq company-backends
;;       '(company-files          ; files & directory
;;          company-keywords       ; keywords
;;          company-capf
;;          company-yasnippet
;;         company-abbrev company-dabbrev
;;         ))
(setq company-backends
      '(company-yasnippet))
(defun company-yasnippet-or-completion ()
  (interactive)
  (let ((yas-fallback-behavior nil))
    (unless (yas-expand)
      (call-interactively #'company-complete-common))))

(add-hook 'company-mode-hook (lambda ()
  (substitute-key-definition 'company-complete-common
                             'company-yasnippet-or-completion
                             company-active-map)))
(setq company-idle-delay 0)



