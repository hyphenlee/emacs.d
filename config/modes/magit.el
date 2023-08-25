;; -*- coding: utf-8 -*-

;;(wttr/plugin:prepend-to-load-path "magit")
;;(autoload 'magit-status "magit" "magit" t)



(use-package magit
  :config
  (define-suffix-command magit-submodule-update-all ()
    "Update all submodules"
    :description "Update All (git submodule update --init --recursive)"
    (interactive)
    (magit-with-toplevel
      (magit-run-git-async "submodule" "update" "--init" "--recursive")))
  )
(use-package magit
  :config
  (define-suffix-command magit-submodule-update-latest ()
    "Update all submodules to latest"
    :description "Update All (git submodule foreach git pull origin master)"
    (interactive)
    (magit-with-toplevel
      (magit-run-git-async "submodule" "foreach" "--recursive" "git " "pull" "origin" "master")))
  )
(use-package magit
  :config
  (define-suffix-command magit-submodule-reset-all ()
    "Reset all submodules to latest"
    :description "Update All (git submodule foreach git pull origin master)"
    (interactive)
    (magit-with-toplevel
      (magit-run-git-async "submodule" "foreach" "--recursive" "git " "reset" "--hard" "origin/master")
      (magit-run-git-async "submodule" "foreach" "--recursive" "git " "clean" "-fd" )
      ))
  )

(eval-after-load "magit" '(transient-append-suffix 'magit-submodule "a"
                            '("U" "Update all" magit-submodule-update-all)))
(eval-after-load "magit" '(transient-append-suffix 'magit-submodule "a"
                            '("P" "Update all to latest" magit-submodule-update-latest)))
(eval-after-load "magit" '(transient-append-suffix 'magit-submodule "a"
                            '("R" "Reset all to latest" magit-submodule-reset-all)))
(setq magit-no-confirm 't)

