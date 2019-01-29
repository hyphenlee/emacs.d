;(wttr/plugin:prepend-to-load-path "helm")
(require 'helm)
(require 'helm-config)
(setq helm-grep-default-command "grep -a -d recurse %e -n%cH -e %p %f")
;;(defvar lhf-project-directory )
;; (defun lhf-set-project-directory()
;; (interactive)
;; (setq lhf-project-directory 
;; (helm-read-file-name 
;; "Default Search Directory:")))

;; (defun helm-do-grep-lhf ()
;;   (interactive)
;;   (require 'helm-mode)
;;   (let* ((preselection (or (dired-get-filename nil t)
;;                            (buffer-file-name (current-buffer))))
;;          (only lhf-project-directory)
;;          (prefarg (or current-prefix-arg helm-current-prefix-arg)))
;;     (helm-do-grep-1 only prefarg)))
