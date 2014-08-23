;;; el4t.el --- Library load helper

;; Copyright (C) 2012 Takafumi Arakaki

;; Author: Takafumi Arakaki <aka.tkf at gmail.com>

;; This file is NOT part of GNU Emacs.

;; EL4T is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; EL4T is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with EL4T.
;; If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Load package.el and ert.el if they are not included in the Emacs
;; loading this script.  Do nothing if they can be loaded.  This is a
;; helper script for ../emacs.sh.

;;; Code:

(defvar el4t-lib (file-name-directory load-file-name))

(unless (locate-library "package")
  (add-to-list 'load-path (expand-file-name "package" el4t-lib)))

(unless (locate-library "ert")
  (add-to-list 'load-path (expand-file-name "ert/lisp/emacs-lisp" el4t-lib)))

(unless (fboundp 'ert-run-tests-batch-and-exit)
  (autoload 'ert-run-tests-batch-and-exit "ert-batch"))

(unless (fboundp 'ert-run-tests-interactively)
  (autoload 'ert-run-tests-interactively "ert-ui"))

;;; el4t.el ends here
