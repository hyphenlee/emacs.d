;;; cmake-format.el --- Format CMake scripts using cmake-format -*- lexical-binding: t; -*-

;;; Commentary:

;; This file is an adaption of code from go-mode.el
;; see https://github.com/dominikh/go-mode.el
;; Copyright 2019 Simon Reiser
;; Copyright 2013 the go-mode Authors.  All rights reserved.
;; Use of this source code is governed by a BSD-style
;; license that can be found in the LICENSE file.

;; Author: Simon Reiser, the go-mode Authors
;; Version: 0.1.0
;; Keywords: languages CMake cmake-format
;; Package-Requires: ((emacs "25.1"))
;; URL: https://github.com/simonfxr/cmake-format.el
;;
;; This file is not part of GNU Emacs.

;;; Code:
(require 'cl)
(defcustom cmake-format-command "cmake-format"
  "The 'cmake-format' command."
  :type 'string
  :group 'cmake-format)

(defcustom cmake-format-args nil
  "Additional arguments to pass to cmake-format."
  :type '(repeat string)
  :group 'cmake-format)

(defcustom cmake-format-show-errors 'buffer
  "Where to display cmake-format error output.
It can either be displayed in its own buffer, in the echo area, or not at all.
Please note that Emacs outputs to the echo area when writing
files and will overwrite the formatter's echo output if used from inside
a `before-save-hook'."
  :type '(choice
          (const :tag "Own buffer" buffer)
          (const :tag "Echo area" echo)
          (const :tag "None" nil))
  :group 'cmake-format)

(defun cmake-format--apply-rcs-patch (patch-buffer)
  "Apply an RCS-formatted diff from PATCH-BUFFER to the current buffer."
  (let ((target-buffer (current-buffer))
        ;; Relative offset between buffer line numbers and line numbers
        ;; in patch.
        ;;
        ;; Line numbers in the patch are based on the source file, so
        ;; we have to keep an offset when making changes to the
        ;; buffer.
        ;;
        ;; Appending lines decrements the offset (possibly making it
        ;; negative), deleting lines increments it. This order
        ;; simplifies the forward-line invocations.
        (line-offset 0)
        (column (current-column)))
    (save-excursion
      (with-current-buffer patch-buffer
        (goto-char (point-min))
        (while (not (eobp))
          (unless (looking-at "^\\([ad]\\)\\([0-9]+\\) \\([0-9]+\\)")
            (error "Invalid rcs patch or internal error in cmake-format--apply-rcs-patch"))
          (forward-line)
          (let ((action (match-string 1))
                (from (string-to-number (match-string 2)))
                (len  (string-to-number (match-string 3))))
            (cond
             ((equal action "a")
              (let ((start (point)))
                (forward-line len)
                (let ((text (buffer-substring start (point))))
                  (with-current-buffer target-buffer
                    (decf line-offset len)
                    (goto-char (point-min))
                    (forward-line (- from len line-offset))
                    (insert text)))))
             ((equal action "d")
              (with-current-buffer target-buffer
                (cmake-format--goto-line (- from line-offset))
                (incf line-offset len)
                (cmake-format--delete-whole-line len)))
             (t
              (error "Invalid rcs patch or internal error in cmake-format--apply-rcs-patch")))))))
    (move-to-column column)))

;;;###autoload
(defun cmake-format-buffer ()
  "Format the current buffer using cmake-format."
  (interactive)
  (let ((tmpfile (let ((temporary-file-directory (expand-file-name ".")))
                   (make-nearby-temp-file "cmake-format" nil ".cmake.tmp")))
        (patchbuf (get-buffer-create "*cmake-format patch*"))
        (err-buf (if cmake-format-show-errors (get-buffer-create "*cmake-format Errors*")))
        (coding-system-for-read 'utf-8)
        (coding-system-for-write 'utf-8)
        (our-fmt-args cmake-format-args))
    (unwind-protect
        (save-restriction
          (widen)
          (if err-buf
              (with-current-buffer err-buf
                (setq buffer-read-only nil)
                (erase-buffer)))
          (with-current-buffer patchbuf
            (erase-buffer))

          (write-region nil nil tmpfile)

          (setq our-fmt-args
                (append our-fmt-args
                        (list "-i" (file-local-name tmpfile))))
          (message "Calling cmake-format: %s %s" cmake-format-command our-fmt-args)
          ;; We're using err-buf for the mixed stdout and stderr output. This
          ;; is not an issue because gofmt -w does not produce any stdout
          ;; output in case of success.
          (if (zerop (apply #'process-file cmake-format-command nil err-buf nil our-fmt-args))
              (progn
                ;; There is no remote variant of ‘call-process-region’, but we
                ;; can invoke diff locally, and the results should be the same.
                (if (zerop (let ((local-copy (file-local-copy tmpfile)))
                             (unwind-protect
                                 (call-process-region
                                  (point-min) (point-max) "diff" nil patchbuf
                                  nil "-n" "-" (or local-copy tmpfile))
                               (when local-copy (delete-file local-copy)))))
                    (message "Buffer is already formatted")
                  (cmake-format--apply-rcs-patch patchbuf)
                  (message "Applied cmake-format"))
                (if err-buf (cmake-format--kill-error-buffer err-buf)))
            (message "Running cmake-format failed")
            (if err-buf (cmake-format--process-errors (buffer-file-name) tmpfile err-buf))))

      (kill-buffer patchbuf)
      (delete-file tmpfile))))

(defun cmake-format--process-errors (filename tmpfile err-buf)
  "Write errors from running cmake-format TMPFILE into ERR-BUF. FILENAME specifies the original `buffer-name'."
  (with-current-buffer err-buf
    (if (eq cmake-format-show-errors 'echo)
        (progn
          (message "%s" (buffer-string))
          (cmake-format--kill-error-buffer err-buf))
      ;; Convert the gofmt stderr to something understood by the compilation mode.
      (goto-char (point-min))
      (insert "cmake-format errors:\n")
      (let ((truefile tmpfile))
        (while (search-forward-regexp
                (concat "^\\(" (regexp-quote (file-local-name truefile))
                        "\\):")
                nil t)
          (replace-match (file-name-nondirectory filename) t t nil 1)))
      (compilation-mode)
      (display-buffer err-buf))))

(defun cmake-format--kill-error-buffer (err-buf)
  "Hide Window showing ERR-BUF and kill the buffer."
  (let ((win (get-buffer-window err-buf)))
    (if win
        (quit-window t win)
      (kill-buffer err-buf))))

(defun cmake-format--goto-line (line)
  "Like (goto-line LINE) but zero based."
  (goto-char (point-min))
  (forward-line (1- line)))

(defun cmake-format--delete-whole-line (&optional arg)
  "Delete the current line without putting it in the `kill-ring'.
Derived from function `kill-whole-line'.  ARG is defined as for that
function."
  (setq arg (or arg 1))
  (if (and (> arg 0)
           (eobp)
           (save-excursion (forward-visible-line 0) (eobp)))
      (signal 'end-of-buffer nil))
  (if (and (< arg 0)
           (bobp)
           (save-excursion (end-of-visible-line) (bobp)))
      (signal 'beginning-of-buffer nil))
  (cond ((zerop arg)
         (delete-region (progn (forward-visible-line 0) (point))
                        (progn (end-of-visible-line) (point))))
        ((< arg 0)
         (delete-region (progn (end-of-visible-line) (point))
                        (progn (forward-visible-line (1+ arg))
                               (unless (bobp)
                                 (backward-char))
                               (point))))
        (t
         (delete-region (progn (forward-visible-line 0) (point))
                        (progn (forward-visible-line arg) (point))))))

(defun cmake-format--before-save ()
  "Hook run from `before-save-hook'."
  (if cmake-format-mode
      (cmake-format-buffer)))

;;;###autoload
(define-minor-mode cmake-format-mode
  "Automatically run cmake-format before saving."
  :lighter "cmake-format"
  (if cmake-format-mode
      (add-hook 'before-save-hook #'cmake-format--before-save)))

(provide 'cmake-format)

;;; cmake-format.el ends here
