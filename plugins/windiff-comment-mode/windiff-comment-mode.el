;;; windiff-comment-mode.el --- mode for visit the windiff comment

;; Author   : winterTTr <winterTTr@gmail.com>
;; Version  : 1.0
;; Keywords : windiff comment compilation

(defun wdc-backward-search-filename ()
  "Search the filename backwards, as the file name line is before
the real line-number line."
  (save-match-data
    (search-backward-regexp wdc-filename-pattern)
    (match-string 1)))


(defconst wdc-filename-pattern
  "^File:\\(.+\\), Total comments:[0-9]+$"
  "The regex string that used to find the file name for windiff comment mode")

(defconst windiff-comment-regexp-alist
  '(("^Comment #[0-9]+, L\\([0-9]+\\) of.*$" wdc-backward-search-filename 1))
  "Rules that need to match format of the windiff comment")

(define-compilation-mode windiff-comment-mode "Windiff-Comment"
  "Used to easily visit the information in windiff comments result."
  (set (make-local-variable 'compilation-error-regexp-alist)
        windiff-comment-regexp-alist)
  (set (make-local-variable 'compilation-search-path)
       (list (ido-read-directory-name "Base directory:" (getenv "WDC-SEARCH-PATH")))))

(provide 'windiff-comment-mode)
















