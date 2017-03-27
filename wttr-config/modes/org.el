;; -*- coding: utf-8 -*-
(require 'wttr-utils)
;; org-mode setting

(require 'org-install)
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(global-set-key "\C-ca" 'org-agenda)
(setq org-agenda-files
      (list "~/note/gtd.org" "~/note/note.org" "~/note/work.org"))
(setq org-insert-mode-line-in-empty-file t)
(setq org-hierarchical-todo-statistics t)


(defun wttr/org-mode-setup ()
  (define-key org-mode-map (kbd "C-c i") #'(lambda ()
                                             (interactive)
                                             (org-time-stamp 4)))
  (org-bullets-mode)
  )
(add-hook 'org-mode-hook #'wttr/org-mode-setup)
(setq org-src-preserve-indentation t)
(setq org-src-ask-before-returning-to-edit-buffer nil)
(setq org-src-fontify-natively t)

;; startup settings i like
(setq org-startup-folded 'content)
(setq org-startup-indented t)
                                        ; (setq org-startup-align-all-tables t)
(setq org-startup-with-inline-images t)
(setq org-hide-leading-stars t)



;; export settings
;;;; prevent the _ to become a sub title
;; (setq org-export-with-sub-superscripts nil)
(setq org-todo-keywords
      '((sequence "TODO(t!)" "WORKING(w!)" "|" "DONE(d@/!)" "ABORT(a@/!)")
        )) 
(setq org-default-notes-file "~/org/notes.org")
(define-key global-map "\C-cc" 'org-capture)
(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/note/gtd.org" "Tasks")
         "* TODO %?\n  %i\n  %a" :clock-in t :clock-resume t)
        ("n" "Note" entry (file+headline "~/note/note.org" "Notes")
         "* %?\n  %i\n  %a")
        ))

;;org-journal
(setq org-journal-dir "~/note/diary/")
;; (setq org-journal-enable-encryption 1)
(setq org-tag-alist '(("crypt" . ?e) ("laptop" . ?l)))

;;org-babel
(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (C . t)
   (org . t)
   (python . t)
   (shell . t)
   (ruby . t)
   ))

(advice-add 'org-agenda-quit :before 'org-mobile-push)
(advice-add 'org-agenda-quit :before 'org-mobile-pull)

(defun my-dnd-func (event)
  (interactive "e")
  (goto-char (nth 1 (event-start event)))
  (x-focus-frame nil)
  (let* ((payload (car (last event)))
         (type (car payload))
         (fname (car payload))
         (img-regexp "\\(png\\|jp[e]?g\\)\\>")
         (img-folder (format "%s/%s" org-img-base-folder (file-name-base buffer-file-name)))
         (new-fname (format "%s/%s" img-folder (file-name-nondirectory fname)))
         )
    (cond
     ;; insert image link with caption
     ;; ((and  (eq 'drag-n-drop (car event))
     ;;        (string-match img-regexp fname))
     ;;  (insert "#+ATTR_HTML: :width 480 :align center")
     ;;  (org-indent-line)
     ;;  (insert (concat  "\n#+CAPTION: " (read-input "Caption: ")))
     ;;  (org-indent-line)
     ;;  (if (not (f-exists? img-folder)) (mkdir img-folder) ())
     ;;  (copy-file fname new-fname t)
     ;;  (insert (format "\n[[%s]]" new-fname))
     ;;  (org-indent-line)
     ;;  (message (format "insert %s" new-fname))
     ;;  )
     ;; (org-display-inline-images t t))
     ;; insert image link
     ((and  (eq 'S-drag-n-drop (car event))

            (string-match img-regexp fname))
      (insert (format "[[%s]]" fname))
      (message (format "insert %s" fname))
      )
     ;; (org-display-inline-images t t))
     ;; C-drag-n-drop to open a file
     ((and  (eq 'C-drag-n-drop (car event))
            (eq 'file type))
      (find-file fname))
     ((and (eq 'M-drag-n-drop (car event))
           (eq 'file type))
      (insert (format "[[attachfile:%s]]" fname)))
     ;; regular drag and drop on file
     ((eq 'file type)
      (insert (format "[[%s]]\n" fname)))
     (t
      (error "I am not equipped for dnd on %s" payload)))))
(define-key org-mode-map (kbd "<drag-n-drop>") 'my-dnd-func)
(define-key org-mode-map (kbd "<S-drag-n-drop>") 'my-dnd-func)
(define-key org-mode-map (kbd "<C-drag-n-drop>") 'my-dnd-func)
(define-key org-mode-map (kbd "<M-drag-n-drop>") 'my-dnd-func)
(setq org-img-base-folder "~/note/img")
(org-display-inline-images t t)
