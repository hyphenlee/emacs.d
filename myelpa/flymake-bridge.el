;;; flymake-bridge.el --- A lsp-bridge Flymake backend -*- lexical-binding: t -*-

;; Copyright (C) 2023 liuyinz

;; Author: liuyinz <liuyinz95@gmail.com>
;; Maintainer: liuyinz <liuyinz95@gmail.com>
;; Version: 0.1.0
;; Package-Requires: ((emacs "26.1") (lsp-bridge))
;; Keywords: tools
;; Homepage: https://github.com/liuyinz/flymake-bridge

;; This file is not a part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;; This file is not a part of GNU Emacs.

;;; Commentary:

;; A lsp-bridge Flymake backend for server diagnostics.
;; Enable it by calling `flymake-bridge-setup' from a
;; file-visiting buffer.  Or to add it to hooks such as:

;; (add-hook 'lsp-bridge-mode-hook #'flymake-bridge-setup)

;;; Code:

(require 'cl-lib)
(require 'flymake)
(require 'lsp-bridge)

(declare-function acm-backend-lsp-position-to-point "acm-backend-lsp")

(defface flymake-bridge-server
  '((t (:foreground "violet" :bold t)))
  "Server of current lsp-bridge as shown in the diagnostic message.")

(defun flymake-bridge (report-fn &rest _args)
  "A flymake backend for `lsp-bridge-diagnostic'.
Add this to `flymake-diagnostic-functions' to enable it.
Calls REPORT-FN directly."
  (cl-loop for diag in (seq-remove
                        (lambda (x)
                          (member (plist-get x :severity)
                                  lsp-bridge-diagnostic-hide-severities))
                        lsp-bridge-diagnostic-records)
           collect
           (flymake-make-diagnostic
            (current-buffer)
            (acm-backend-lsp-position-to-point
             (plist-get (plist-get diag :range) :start))
            (acm-backend-lsp-position-to-point
             (plist-get (plist-get diag :range) :end))
            (cl-case (plist-get diag :severity)
              (1 :error)
              (2 :warning)
              ((3 4) :note))
            (concat (when-let ((code (plist-get diag :code)))
                      (concat "[" (or (and (stringp code) code)
                                      (prin1-to-string code))
                              "] "))
                    (plist-get diag :message)
                    (when-let ((server (plist-get diag :server-name)))
                      (concat " (" (propertize server 'face
                                               'flymake-bridge-server)
                              ")"))))
           into diags
           finally (funcall report-fn diags)))

(defun flymake-bridge-ensure ()
  "Add `flymake-bridge' to diagnositc functions if not yet."
  (unless (memq 'flymake-bridge flymake-diagnostic-functions)
    (setq lsp-bridge-diagnostic-enable-overlays nil)
    (add-hook 'flymake-diagnostic-functions #'flymake-bridge nil t)
    (add-hook 'lsp-bridge-diagnostic-update-hook #'flymake-start nil t)
    (flymake-mode 1))
  (remove-hook 'lsp-bridge-diagnostic-update-hook #'flymake-bridge-ensure t))

;;;###autoload
(defun flymake-bridge-setup ()
  "Setup lsp-bridge-diagnostic integration with Flymake."
  (interactive)
  (if (< emacs-major-version 26)
      (error "Flymake-bridge requires Emacs 26 or later")
    (add-hook 'lsp-bridge-diagnostic-update-hook #'flymake-bridge-ensure nil t)))

(provide 'flymake-bridge)
;;; flymake-bridge.el ends here
