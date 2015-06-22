;; -*- coding: utf-8 -*-
(require 'wttr-utils)

;; org-mode setting

                                        ; always use english times format
(setq system-time-locale "C")

                                        ; add new path at the begining
(setq load-path (cons "~/.emacs.d/plugins/org-mode/lisp/" load-path) )
                                        ; we also turn on contrib : htmlize.el
(setq load-path (cons "~/.emacs.d/plugins/org-mode/contrib/lisp/" load-path) )


(require 'org-install)
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(setq org-agenda-files
      (list "~/todo_list.org"))
(setq org-insert-mode-line-in-empty-file t)
(setq org-hierarchical-todo-statistics t)


(defun wttr/org-mode-setup ()
  (define-key org-mode-map (kbd "C-c i") #'(lambda ()
                                             (interactive)
                                             (org-time-stamp 4))))
(add-hook 'org-mode-hook #'wttr/org-mode-setup)


;; work flow for the gomez
(setq org-todo-keyword-faces
      '(
        ;; bug workflow
        ("OPEN" . (:foreground "PeachPuff" ) )
        ("REOPEN" . (:foreground "PeachPuff" ) )
        ("STEPPING" . (:foreground "LawnGreen") )
        ("BLOCK" .  (:foreground "IndianRed" ) )
        ("PENDING" . (:foreground "DarkGreen"))
        ("MOVE" . (:foreground "DeepSkyBlue" :weight bold))
        ("FIXED" . (:foreground "DeepSkyBlue" :weight bold))
        ("DUPLICATE" . (:foreground "DeepSkyBlue" :weight bold))
        ("WAD" .  (:foreground "DeepSkyBlue" :weight bold) )
        ("IRREPRODUCIBLE" .  (:foreground "DeepSkyBlue" :weight bold) )
        ;; type workflow
        ("Paul"   (:foreground "DarkSlateGray" ) )
        ("Hunter"   (:foreground "DarkSlateGray" ) )
        ("Drizzt"   (:foreground "DarkSlateGray" ) )
        ("Sean"   (:foreground "DarkSlateGray" ) )
        ("Kirill"   (:foreground "DarkSlateGray" ) )
        ;; todo workflow
        ("TODO" . (:foreground "PeachPuff") )
        ("DONE" . (:foreground "DeepSkyBlue" :weight bold) )
        )) 

;; setting for the inline source code.
                                        ;(setq org-src-lang-modes
                                        ;      (append org-src-lang-modes
                                        ;              '( ("latex" . latex-mode)
                                        ;                 ("powershell" . powershell-mode))))
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
(setq org-export-with-sub-superscripts nil)
(setq org-todo-keywords
      '((sequence "TODO(t!)" "WORKING(w!)" "|" "DONE(d@/!)" "ABORT(a@/!)")
        )) 
(setq org-default-notes-file "~/org/notes.org")
(define-key global-map "\C-cc" 'org-capture)
(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/note/gtd.org" "Tasks")
         "* TODO %?\n  %i\n  %a")
        ("n" "Note" entry (file+headline "~/note/note.org" "Notes")
         "* %?\n  %i\n  %a")
        ("j" "Journal" entry (file+datetree "~/note/journal.org")
         "* %?\nEntered on %U\n  %i\n  %a")))
(setq org-journal-dir "~/note/diary/")
