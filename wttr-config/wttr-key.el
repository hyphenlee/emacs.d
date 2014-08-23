;; -*- coding: utf-8 -*-
(require 'wttr-utils)
(defun kid-switch-to-shell ()
  (interactive)
  (when (null (cdr (window-list)))
    (split-window-vertically))
  (let ((file buffer-file-name))
    (other-window 1)
    (shell)
    (when file
      (end-of-buffer)
      (when (looking-back shell-prompt-pattern)
        (insert "cd " (file-name-directory file))
        (call-interactively 'comint-send-input)))))
;; open file in current buffer from outer explorer
(defun w32-open-current-file-in-explorer ()
  "open the current buffer file in windows explorer"
  (interactive)
  (let ((file buffer-file-name))
    (when file
      (w32-shell-execute
       nil
       "explorer.exe"
       (concat "/e,/select," (replace-in-string file "/" "\\\\") )))))
; open external shell from current file directory
(defun w32-open-shell-from-current-file-directory ()
  "open cmd from current file directory"
  (interactive)
  (let ((file buffer-file-name))
    (when (and file (file-name-directory file))
      (w32-shell-execute
       nil
       "cmd.exe"
       (concat "/k cd /d" (file-name-directory file))))))
(defun wttr/w32:copy-current-file-name (&optional prefix)
  (interactive "p")
  (cond
   ((equal prefix 1)
    (kill-new (buffer-name)))
   ((equal prefix 4)
    (kill-new (or (buffer-file-name)
                  (buffer-name))))))

(global-set-key (kbd "<M-f5>") 'wttr/w32:copy-current-file-name)
(global-set-key "\C-c\C-y" 'copy-line)
(global-set-key "\C-c\C-v" 'view-mode)
(global-set-key (kbd "M-1") 'delete-other-windows)
(global-set-key (kbd "M-0") 'delete-window)
(global-set-key (kbd "<C-S-f6>") 'kid-switch-to-shell)
(global-set-key (kbd "<C-f5>") 'w32-open-current-file-in-explorer)
(global-set-key (kbd "<C-f6>") 'w32-open-shell-from-current-file-directory)
(provide 'wttr-key)
