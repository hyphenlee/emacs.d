;; -*- coding: utf-8 -*-
(require 'utils)
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
       (concat "/e,/select," (replace-regexp-in-string "/" "\\\\" file) )))))
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
(global-set-key (kbd "M-1") 'helm-bookmarks)
(global-set-key (kbd "M-3") #'helm-find-files)
(global-set-key (kbd "M-2") #'helm-mini)
(global-set-key (kbd "M-0") 'delete-window)
(global-set-key (kbd "M-q") 'kill-current-buffer)
(global-set-key (kbd "<C-S-f6>") 'kid-switch-to-shell)
(global-set-key (kbd "<C-f5>") 'w32-open-current-file-in-explorer)
(global-set-key (kbd "<C-f6>") 'w32-open-shell-from-current-file-directory)
                                        ;(global-set-key (kbd "C-c s") 'set-mark-command)
;; (global-set-key (kbd "C-\\") 'indent-buffer)
(global-set-key (kbd "C-x o") 'switch-window)
(global-set-key (kbd "<f11>") 'calendar)
;;helm
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "M-m") 'helm-semantic-or-imenu)
;; (global-set-key (kbd "C-x b")   #'helm-mini)
(global-set-key (kbd "C-x C-b") #'helm-buffers-list)
(global-set-key (kbd "M-x") #'helm-M-x)
(global-set-key (kbd "C-c M-x") #'execute-extended-command)
(global-set-key (kbd "C-x C-f") #'helm-find-files)
(global-set-key (kbd "C-x C-r") #'helm-recentf)
(global-set-key (kbd "C-x r l")   #'helm-bookmarks)
(global-set-key (kbd "C-c s") 'helm-do-ag-project-root)
(global-set-key (kbd "C-c f") 'mu-helm-file-search)
(global-set-key (kbd "C-c <DEL>") 'c-hungry-delete-backwards)
(global-set-key (kbd "M-[") 'avy-goto-word-1)
;;magit
(global-set-key (kbd "M-4") 'magit-status)

(defun evil-toggle-state-lhf()
  (interactive)
  (if (or (equal evil-state 'insert) (equal evil-state 'normal))
      (evil-emacs-state)
    (evil-normal-state)))

(global-set-key (kbd "C-z") 'evil-toggle-state-lhf)

(global-set-key [remap forward-word] 'forward-symbol)
(global-set-key [remap backward-word] 'backward-symbol)


;;magit
(with-eval-after-load 'magit
  (define-key magit-status-mode-map (kbd "M-1") nil)
  (define-key magit-log-mode-map (kbd "M-1") nil)
  (define-key magit-status-mode-map (kbd "M-2") nil)
  (define-key magit-log-mode-map (kbd "M-2") nil)
  (define-key magit-status-mode-map (kbd "M-3") nil)
  (define-key magit-log-mode-map (kbd "M-3") nil)
  (define-key magit-status-mode-map (kbd "M-4") nil)
  (define-key magit-log-mode-map (kbd "M-4") nil)
  )
(global-set-key (kbd "C-c u") 'lhf-update-repos)
(global-set-key (kbd "C-c p") 'project-find-file)
(global-set-key (kbd "M-o") 'helm-projectile-find-other-file)
(global-set-key (kbd "C-<tab>") 'switch-to-next-buffer)
(global-set-key (kbd "C-S-<tab>") 'switch-to-prev-buffer)
(global-set-key (kbd "C-;") 'ace-jump-mode)

(provide 'key)
