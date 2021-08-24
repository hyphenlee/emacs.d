;; -*- coding: utf-8 -*-

;; we do not need to setup the grep command, use the correct exec-path
;; and "PATH" env is enough
(require 'grep)
(grep-apply-setting
 'grep-find-use-xargs 'exec)

(grep-apply-setting 'grep-highlight-matches 'always)

(if wttr/os:windowsp
    (grep-apply-setting
     'grep-find-template
     (concat "find . <X> -type f <F> -exec "
             "E:/Tools/emacs/.emacs.d/extra-bin/gnuwin32/grep.exe <C> -nH -e <R> {} \";\"")))


(defun wttr/customized:rgrep ()
  (interactive)
  (grep-apply-setting
   'grep-find-template
     (concat "find . <X> -type f <F> -exec "
             (expand-file-name "~/.emacs.d/extra-bin/gnuwin32/grep.exe")
             " <C> -nH -e <R> {} \";\""))
  (call-interactively 'rgrep))


(defun wttr/customized:rgrep-using-ack ()
  (interactive)
  (grep-apply-setting
   'grep-find-template
     (concat "\""
             (executable-find "perl")
             "\" \""
             (expand-file-name "~/.emacs.d/extra-bin/ack/ack-standalone.pl")
             "\" --nogroup --color <R>"))
  (call-interactively 'rgrep))



(require 'compile)
(require 'thingatpt)

(defvar ack-command
  (concat "\""
          (executable-find "perl")
          "\" \""
          (expand-file-name "~/.emacs.d/extra-bin/ack/ack-standalone.pl")
          "\"")
  "The command run by the ack function.")

(defvar ack-mode-font-lock-keywords
  '(("^\\(Compilation\\|Ack\\) started.*"
     (0 '(face nil message nil help-echo nil mouse-face nil) t))))

(defvar ack-use-search-in-buffer-name t
  "If non-nil, use the search string in the ack buffer's name.")

(define-compilation-mode ack-mode "Ack"
  "Specialization of compilation-mode for use with ack."
  nil)

(defun ack (dir pattern args)
  "Run ack, with user-specified ARGS, and collect output in a buffer.
While ack runs asynchronously, you can use the \\[next-error] command to
find the text that ack hits refer to. The command actually run is
defined by the ack-command variable."
  (interactive (list (read-file-name "Run ack in directory: " nil "" t)
                     (read-string "Search for: " (thing-at-point 'symbol))
                     (read-string "Ack arguments: " "-i" nil "-i" nil)
                     ))
                                        ; Get dir into an the right state, incase a file name was used
  (setq dir (abbreviate-file-name
             (file-name-as-directory (expand-file-name dir))))
  ;; Check that it's really a directory.
  (or (file-directory-p dir)
      (error "ack needs a directory: %s" dir))

  (let (compile-command
        (compilation-error-regexp-alist grep-regexp-alist)
        (compilation-directory default-directory)
        (ack-full-buffer-name (concat "*ack-" pattern "*")))
    ;; (save-some-buffers (not compilation-ask-about-save) nil)
    ;; lambda defined here since compilation-start expects to call a function to get the buffer name
    (compilation-start (concat ack-command " " args " " pattern " " dir) 'ack-mode
                       (when ack-use-search-in-buffer-name
                         (function (lambda (ignore)
                                     ack-full-buffer-name)))
                       (regexp-quote pattern))))

;; (provide 'ack-emacs)





;; for windows perl need to install Win32::Console::ANSI
;; perl -MCPAN -e shell
;; ftp://freesoft.cgi.gov.cn/pub/languages/perl/CPAN
;; install Win32::Console::ANSI

;; (grep-apply-setting
;;  'grep-find-template 
;;  "\"c:/Program Files/git/bin/perl.exe\"
;;  "\"E:/Tools/emacs/.emacs.d/extra-bin/ack/ack-standalone.pl\"
;;  --color --nogroup <R>")

;(when wttr/os:windowsp
;  (defadvice grep-expand-template
;    (around grep-expand-template-w32-around (template &optional regexp files dir excl))
;    "A patch for the windows system, as the [find . -iname \"balabala\" -exec grep \"grep-bala\" {} ;] will
;result as a seperate windows process [grep grep-balaba file-name-from-find].
;When grep-bala contains *, this will lead to very wierd result as the paramter is not quoted in new process.
;So I patch it."
;    (cond
;     ((string-match-p "^find.*grep" template)
;      (let ((regexp (format "\"%s\"" regexp)))
;        ad-do-it))
;     ((string-match-p "^grep.*" template)
;      ad-do-it)
;     (t
;      ad-do-it)))
;  (ad-activate 'grep-expand-template))



;(grep-apply-setting
; 'grep-find-command
; '("E:/Tools/Emacs/bin/find.exe . -type f -exec E:/Tools/Emacs/bin/grep.exe -nH -ie  {} NUL \";\"" . 80 ) )
;(grep-apply-setting
; 'grep-command
; "E:/Tools/Emacs/bin/grep.exe -nH -ie ")
;(grep-apply-setting
; 'grep-find-template
; "E:/Tools/Emacs/bin/find.exe . <X> -type f <F> -exec E:/Tools/Emacs/bin/grep.exe <C> -nH -ie <R> {} NUL \";\"" )
;(setq grep-program "grep.exe")
;(setq find-program "find.exe")
