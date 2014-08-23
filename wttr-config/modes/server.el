;; -*- coding: utf-8 -*-

;; server mode
;;(server-start)

(defun wttr/server-mode:kill-flag-file ()
  "Kill the server mode flag file when emacs exist"
  (if (file-exists-p "~/.emacs.d/server/server")
      (delete-file "~/.emacs.d/server/server")))

(add-hook 'kill-emacs-hook #'wttr/server-mode:kill-flag-file)

