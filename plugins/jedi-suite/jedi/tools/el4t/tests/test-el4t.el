;;; test-el4t.el --- Tests for EL4T

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

;;

;;; Code:

(require 'ert)

(ert-deftest el4t-package-el-loadable ()
  (should (locate-library "package")))

(ert-deftest el4t-package-installed ()
  "Check that library can be installed using package.el (see ../Carton)."
  (should (require 'queue)))

(ert-deftest el4t-check-emacs-version ()
  (let ((testing-emacs-version
         (with-temp-buffer
           (erase-buffer)
           (call-process (getenv "EL4T_EMACS") nil '(t nil) nil
                         "-Q" "--batch" "--eval" "(print emacs-version)")
           (goto-char (point-min))
           (read (current-buffer)))))
    (should (equal testing-emacs-version emacs-version))))

;;; test-el4t.el ends here
