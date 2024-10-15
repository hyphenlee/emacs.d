;; -*- coding: utf-8 -*-
(autoload 'magit-status "magit" "magit" t)


;; (defun magit-submodule-update-all ()
;;   "Update all submodules"
;;   :description "Update All (git submodule update --init --recursive)"
;;   (interactive)
;;   (magit-with-toplevel
;;     (magit-run-git-async "submodule" "update" "--init" "--recursive")))
;; (defun magit-submodule-update-latest ()
;;   "Update all submodules to latest"
;;   :description "Update All (git submodule foreach git pull origin main)"
;;   (interactive)
;;   (magit-with-toplevel
;;     (magit-run-git-async "submodule" "foreach" "--recursive" "git " "pull" "origin" "main")))
;; (defun magit-submodule-reset-all ()
;;   "Reset all submodules to latest"
;;   :description "Update All (git submodule foreach git pull origin main)"
;;   (interactive)
;;   (magit-with-toplevel
;;     (magit-run-git-async "submodule" "foreach" "--recursive" "git " "reset" "--hard" "origin/main")
;;     (magit-run-git-async "submodule" "foreach" "--recursive" "git " "clean" "-fd" )
;;     ))
;; (eval-after-load "magit" '(transient-append-suffix 'magit-submodule "u"
;;                             '("U" "Update all" magit-submodule-update-all)))
;; (eval-after-load "magit" '(transient-append-suffix 'magit-submodule "u"
;;                             '("P" "Update all to latest" magit-submodule-update-latest)))
;; (eval-after-load "magit" '(transient-append-suffix 'magit-submodule "u"
;;                             '("R" "Reset all to latest" magit-submodule-reset-all)))

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
  :description "Update All (git submodule foreach git pull origin main)"
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
(require 'forge)
(add-to-list 'ghub-insecure-hosts "192.168.1.124/api/v4")	
(add-to-list 'ghub-insecure-hosts "192.168.1.124")

(add-to-list 'forge-alist
                 '("192.168.1.124" "192.168.1.124/api/v4"
                   "192.168.1.124" forge-gitlab-repository))

(setq magit-no-confirm 't)

