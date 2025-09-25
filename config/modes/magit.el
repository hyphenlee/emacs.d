;; -*- coding: utf-8 -*-
(autoload 'magit-status "magit" "magit" t)
(use-package magit
  :config

  (transient-define-suffix magit-submodule-update-all ()
    "Update all submodules"
    :description "Update All (git submodule update --init --recursive)"
    (interactive)
    (magit-with-toplevel
      (magit-run-git-async "submodule" "update" "--init" "--recursive")))

(transient-define-suffix magit-submodule-update-latest ()
  "Update all submodules to latest"
  :description "Update All (git submodule foreach git pull origin main)"
  (interactive)
  (magit-with-toplevel
    (magit-run-git-async "submodule" "foreach" "--recursive" "git " "pull" "origin" "main")))
(transient-define-suffix magit-submodule-reset-all ()
  "Reset all submodules to latest"
  :description "Reset All (git submodule foreach git reset --hard --fd)"
  (interactive)
  (magit-with-toplevel
    (magit-run-git-async "submodule" "foreach" "--recursive" "git " "reset" "--hard" "origin/main")
    (magit-run-git-async "submodule" "foreach" "--recursive" "git " "clean" "-fd" )
    ))
  (transient-append-suffix 'magit-submodule "u"
    '("U" magit-submodule-update-all))
  (transient-append-suffix 'magit-submodule "u"
    '("P" magit-submodule-update-latest))
  (transient-append-suffix 'magit-submodule "u"
    '("R" magit-submodule-reset-all))
  )
;; (require 'forge)
;; (add-to-list 'ghub-insecure-hosts "192.168.1.124/api/v4")	
;; (add-to-list 'ghub-insecure-hosts "192.168.1.124")

;; (add-to-list 'forge-alist
;;                  '("192.168.1.124" "192.168.1.124/api/v4"
;;                    "192.168.1.124" forge-gitlab-repository))
;; ediff merge: keep both with d
(defun ediff-copy-both-to-C ()
  (interactive)
  (ediff-copy-diff ediff-current-difference nil 'C nil
                   (concat
                    (ediff-get-region-contents ediff-current-difference 'A ediff-control-buffer)
                    (ediff-get-region-contents ediff-current-difference 'B ediff-control-buffer))))
(defun add-d-to-ediff-mode-map () (define-key ediff-mode-map "d" 'ediff-copy-both-to-C))
(add-hook 'ediff-keymap-setup-hook 'add-d-to-ediff-mode-map)

(setq magit-no-confirm 't)

