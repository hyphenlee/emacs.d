;; -*- coding: utf-8 -*-
(require 'utils)
;; org-mode setting

;; (require 'org-install)
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
  (require 'org-bullets)
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
      '((sequence "TODO(t!)" "WORKING(w!)" "|" "DONE(d!)" "ABORT(a!)")
        )) 
(setq org-default-notes-file "~/note/note.org")
(define-key global-map "\C-cc" 'org-capture)
(setq org-capture-templates
      '(("t" "Todo" entry (file "~/note/gtd.org")
         "* TODO %?\n  %i\n" :clock-in t :clock-resume t)
        ("n" "Note" entry (file "~/note/note.org")
         "* %?\n  %i\n")
        ("w" "Work" entry (file "~/note/work.org")
         "* %?\n  %i\n ")
        ))

;;org-journal
;; (setq org-journal-enable-encryption 1)
(setq org-tag-alist '(("crypt" . ?e) ("laptop" . ?l)))
(setq org-journal-dir "~/note/journal")
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
(org-display-inline-images t t)
(setq org-confirm-babel-evaluate nil)
