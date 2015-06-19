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

(global-set-key "\M-2" 'toggle-input-method)
(global-set-key (kbd "<M-f5>") 'wttr/w32:copy-current-file-name)
(global-set-key "\C-c\C-y" 'copy-line)
(global-set-key "\C-c\C-v" 'view-mode)
(global-set-key (kbd "M-1") 'delete-other-windows)
(global-set-key (kbd "M-0") 'delete-window)
(global-set-key (kbd "<C-S-f6>") 'kid-switch-to-shell)
(global-set-key (kbd "<C-f5>") 'w32-open-current-file-in-explorer)
(global-set-key (kbd "<C-f6>") 'w32-open-shell-from-current-file-directory)
                                        ;(global-set-key (kbd "C-c s") 'set-mark-command)
(global-set-key (kbd "C-\\") 'indent-buffer)
(global-set-key (kbd "C-x o") 'switch-window)
;;(add-hook 'js-mode-hook '(lambda ()(local-set-key (kbd "C-c s") 'hs-toggle-hiding)))
                                        ;(define-key js-mode-map (kbd "C-c s") 'hs-toggle-hiding)
;; (add-hook 'js-mode-hook '(lambda ()(local-set-key (kbd "C-c n") 'flycheck-next-error)))
                                        ;(add-hook 'js2-mode-hook '(lambda ()(local-set-key (kbd "<f5>") '(lambda ()(interactive) (shell-command "cd c:/work/rtviewer & sencha app build production")))))

(global-set-key (kbd "<f11>") 'calendar)
;;helm
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "M-m") 'helm-semantic-or-imenu)
(global-set-key (kbd "C-x b")   #'helm-mini)
(global-set-key (kbd "C-x C-b") #'helm-buffers-list)
(global-set-key (kbd "M-x") #'helm-M-x)
(global-set-key (kbd "C-x C-f") #'helm-find-files)
(global-set-key (kbd "C-x C-r") #'helm-recentf)
(global-set-key (kbd "C-x r l")   #'helm-bookmarks)
(global-set-key (kbd "C-c s") 'helm-do-ag-project-root)
(global-set-key (kbd "C-c b") 'helm-ag-pop-stack)

(global-set-key (kbd "C-c <DEL>") 'c-hungry-delete-backwards)

(defun evil-toggle-state-lhf()
  (interactive)
  (if (or (equal evil-state 'insert) (equal evil-state 'normal))
      (evil-emacs-state)
    (evil-normal-state)))

(global-set-key (kbd "C-z") 'evil-toggle-state-lhf)
(global-set-key (kbd "C-q") 'evil-force-normal-state)

(provide 'wttr-key)
