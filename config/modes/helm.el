(require 'helm)
;; ;; (require 'helm-config)
;; (setq helm-grep-default-command "grep -a -d recurse %e -n%cH -e %p %f")

;; ;; search in folder
;; (setq helm-grep-ag-command (concat "rg"
;;                                    " --color=never"
;;                                    " --smart-case"
;;                                    " --no-heading"
;;                                    " --line-number %s %s %s")
;;       helm-grep-file-path-style 'relative)

(defun mu-helm-rg (directory &optional with-types)
  "Search in DIRECTORY with RG.
With WITH-TYPES, ask for file types to search in."
  (interactive "P")
  (require 'helm-adaptive)
  (helm-grep-ag-1 (expand-file-name directory)
                  (helm-aif (and with-types
                                 (helm-grep-ag-get-types))
                      (helm-comp-read
                       "RG type: " it
                       :must-match t
                       :marked-candidates t
                       :fc-transformer 'helm-adaptive-sort
                       :buffer "*helm rg types*"))))
(defun mu-helm-file-search (&optional with-types)
  "Search in `default-directory' with RG.
With WITH-TYPES, ask for file types to search in."
  (interactive "P")
  (mu-helm-rg default-directory with-types))
