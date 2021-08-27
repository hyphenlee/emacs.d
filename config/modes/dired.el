;; -*- coding: utf-8 -*-
(require 'utils)

;; recrusive delete and copy directory
(setq dired-recursive-deletes t)
(setq dired-recursive-copies t)

;; prevent the warning message
(put 'dired-find-alternate-file 'disabled nil)

;; normal we use the Recycle bin
(setq delete-by-moving-to-trash t)

;; use the isearch only for filename
(setq dired-isearch-filenames t)

;; we use extra function
(require 'dired-x)
;; use wdired
(require 'wdired)
(setq wdired-allow-to-change-permissions 'advanced)
(define-key dired-mode-map (kbd "r") 'wdired-change-to-wdired-mode)
(add-hook 'dired-mode-hook
          (lambda ()
            (define-key dired-mode-map (kbd "u")
              (lambda () (interactive) (find-alternate-file "..")))
            ))
(setq dired-omit-mode t)
(setq-default dired-omit-files-p t) ; Buffer-local variable
(setq dired-omit-files (concat dired-omit-files "\\|^\\..+$"))
;;(setq dired-omit-extensions (".rbo" ".rbc" ".o" "~" ".bin" ".lbin" ".so" ".a" ".ln" ".blg" ".bbl" ".elc" ".lof" ".glo" ".idx" ".lot" ".svn/" ".hg/" ".git/" ".bzr/" "CVS/" "_darcs/" "_MTN/" ".fmt" ".tfm" ".class" ".fas" ".lib" ".mem" ".x86f" ".sparcf" ".dfsl" ".pfsl" ".d64fsl" ".p64fsl" ".lx64fsl" ".lx32fsl" ".dx64fsl" ".dx32fsl" ".fx64fsl" ".fx32fsl" ".sx64fsl" ".sx32fsl" ".wx64fsl" ".wx32fsl" ".fasl" ".ufsl" ".fsl" ".dxl" ".lo" ".la" ".gmo" ".mo" ".toc" ".aux" ".cp" ".fn" ".ky" ".pg" ".tp" ".vr" ".cps" ".fns" ".kys" ".pgs" ".tps" ".vrs" ".pyc" ".pyo" ".idx" ".lof" ".lot" ".glo" ".blg" ".bbl" ".cp" ".cps" ".fn" ".fns" ".ky" ".kys" ".pg" ".pgs" ".tp" ".tps" ".vr" ".vrs"))
(setq dired-omit-extensions nil)

(defun open-in-external-app ()
  "Open the current file or dired marked files in external app."
  (interactive)
  (let ( doIt
         (myFileList
          (cond
           ((string-equal major-mode "dired-mode") (dired-get-marked-files))
           (t (list (buffer-file-name))) ) ) )

    (setq doIt (if (<= (length myFileList) 5)
                   t
                 (y-or-n-p "Open more than 5 files?") ) )

    (when doIt
      (cond
       ((string-equal system-type "windows-nt")
        (mapc (lambda (fPath) (w32-shell-execute "open" (replace-regexp-in-string "/" "\\" fPath t t)) ) myFileList))
       ((string-equal system-type "darwin")
        (mapc (lambda (fPath) (shell-command (format "open \"%s\"" fPath)) )  myFileList) )
       ((string-equal system-type "gnu/linux")
        (mapc (lambda (fPath) (let ((process-connection-type nil)) (start-process "" nil "xdg-open" fPath)) ) myFileList) ) ) )
    (local-set-key (kbd "C-c C-o") 'open-in-external-app)) )
(add-hook 'dired-mode-hook 'open-in-external-app)
(put 'dired-find-alternate-file 'disabled nil)
