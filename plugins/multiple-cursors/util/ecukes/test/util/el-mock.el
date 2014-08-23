;;; el-mock.el --- Tiny Mock and Stub framework in Emacs Lisp
;; $Id: el-mock.el,v 1.22 2010/05/04 08:49:20 rubikitch Exp $

;; Copyright (C) 2008, 2010  rubikitch

;; Author: rubikitch <rubikitch@ruby-lang.org>
;; Keywords: lisp, testing, unittest
;; URL: http://www.emacswiki.org/cgi-bin/wiki/download/el-mock.el

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;; Emacs Lisp Mock is a library for mocking and stubbing using
;; readable syntax. Most commonly Emacs Lisp Mock is used in
;; conjunction with Emacs Lisp Expectations, but it can be used in
;; other contexts.

;;; Commands:
;;
;; Below are complete command list:
;;
;;
;;; Customizable Options:
;;
;; Below are customizable option list:
;;

;; Emacs Lisp Mock provides two scope interface of mock and stub:
;; `with-mock' and `mocklet'. `with-mock' only defines a
;; scope. `mocklet' is more sophisticated interface than `with-mock':
;; `mocklet' defines local mock and stub like `let', `flet', and
;; `macrolet'.

;; Within `with-mock' body (or argument function specified in
;; `mock-protect'), you can create a mock and a stub. To create a
;; stub, use `stub' macro. To create a mock, use `mock' macro.
  
;; For further information: see docstrings.
;; [EVAL IT] (describe-function 'with-mock)
;; [EVAL IT] (describe-function 'mocklet)
;; [EVAL IT] (describe-function 'stub)
;; [EVAL IT] (describe-function 'mock)


;;; Bug Report:
;;
;; If you have problem, send a bug report via M-x mock-send-bug-report.
;; The step is:
;;  0) Setup mail in Emacs, the easiest way is:
;;       (setq user-mail-address "your@mail.address")
;;       (setq user-full-name "Your Full Name")
;;       (setq smtpmail-smtp-server "your.smtp.server.jp")
;;       (setq mail-user-agent 'message-user-agent)
;;       (setq message-send-mail-function 'message-smtpmail-send-it)
;;  1) Be sure to use the LATEST version of el-mock.el.
;;  2) Enable debugger. M-x toggle-debug-on-error or (setq debug-on-error t)
;;  3) Use Lisp version instead of compiled one: (load "el-mock.el")
;;  4) Do it!
;;  5) If you got an error, please do not close *Backtrace* buffer.
;;  6) M-x mock-send-bug-report and M-x insert-buffer *Backtrace*
;;  7) Describe the bug using a precise recipe.
;;  8) Type C-c C-c to send.
;;  # If you are a Japanese, please write in Japanese:-)

;;; History:

;; $Log: el-mock.el,v $
;; Revision 1.22  2010/05/04 08:49:20  rubikitch
;; Added bug report command
;;
;; Revision 1.21  2010/03/29 12:17:35  rubikitch
;; Fix an error when stubbed value is nil
;;
;; Revision 1.20  2010/03/26 06:25:08  rubikitch
;; more mock :times support
;;
;; Revision 1.19  2010/03/26 02:52:01  rubikitch
;; document
;;
;; Revision 1.18  2010/03/26 02:48:34  rubikitch
;; mock :times support / refactoring
;;
;; Revision 1.17  2008/08/28 19:04:48  rubikitch
;; Implement `not-called' mock.
;;
;; Revision 1.16  2008/08/28 18:23:28  rubikitch
;; unit test: use dont-compile
;;
;; Revision 1.15  2008/04/18 18:02:24  rubikitch
;; bug fix about symbol
;;
;; Revision 1.14  2008/04/13 18:23:43  rubikitch
;; removed `message' advice.
;; mock-suppress-redefinition-message: suppress by empty message
;;
;; Revision 1.13  2008/04/12 17:36:11  rubikitch
;; raise mock-syntax-error when invalid `mock' and `stub' spec.
;;
;; Revision 1.12  2008/04/12 17:30:33  rubikitch
;; inhibit using `mock' and `stub' outside `mock-protect' function.
;;
;; Revision 1.11  2008/04/12 17:10:42  rubikitch
;; * added docstrings.
;; * `stublet' is an alias of `mocklet'.
;;
;; Revision 1.10  2008/04/12 16:14:16  rubikitch
;; * allow omission of return value
;; * (mock foo 2) and (stub foo 2) cause error now
;; * arranged test
;;
;; Revision 1.9  2008/04/12 15:10:32  rubikitch
;; changed mocklet syntax
;;
;; Revision 1.8  2008/04/12 14:54:16  rubikitch
;; added Commentary
;;
;; Revision 1.7  2008/04/10 16:14:02  rubikitch
;; fixed advice-related bug
;;
;; Revision 1.6  2008/04/10 14:08:32  rubikitch
;; *** empty log message ***
;;
;; Revision 1.5  2008/04/10 14:01:48  rubikitch
;; arranged code/test
;;
;; Revision 1.4  2008/04/10 12:57:00  rubikitch
;; mock verify
;;
;; Revision 1.3  2008/04/10 07:50:10  rubikitch
;; *** empty log message ***
;;
;; Revision 1.2  2008/04/10 07:48:04  rubikitch
;; New functions:
;; stub/setup
;; stub/teardown
;; stub/parse-spec
;;
;; refactored with-stub-function
;;
;; Revision 1.1  2008/04/10 07:37:54  rubikitch
;; Initial revision
;;

;;; Code:

(eval-when-compile (require 'cl))
(require 'advice)

(defvar -stubbed-functions nil)
(defvar -mocked-functions nil)
(defvar mock-verify-list nil)
(defvar in-mocking nil)

;;;; stub setup/teardown
(defun stub/setup (funcsym value)
  (mock-suppress-redefinition-message
   (lambda ()
     (when (fboundp funcsym)
       (put funcsym 'mock-original-func (symbol-function funcsym)))
     (ad-safe-fset funcsym `(lambda (&rest x) ,value)))))

(defun stub/teardown (funcsym)
  (mock-suppress-redefinition-message
   (lambda ()
     (let ((func (get funcsym 'mock-original-func)))
       (if (not func)
           (fmakunbound funcsym)
         (ad-safe-fset funcsym func)
         ;; may be unadviced
         )))))
    
;;;; mock setup/teardown
(defun mock/setup (func-spec value times)
  (mock-suppress-redefinition-message
   (lambda ()
     (let ((funcsym (car func-spec)))
       (when (fboundp funcsym)
         (put funcsym 'mock-original-func (symbol-function funcsym)))
       (put funcsym 'mock-call-count 0)
       (ad-safe-fset funcsym
                     `(lambda (&rest actual-args)
                        (incf (get ',funcsym 'mock-call-count))
                        (add-to-list 'mock-verify-list
                                     (list ',funcsym ',(cdr func-spec) actual-args ,times))
                        ,value))))))

(defun not-called/setup (funcsym)
  (mock-suppress-redefinition-message
   (lambda ()
     (let ()
       (when (fboundp funcsym)
         (put funcsym 'mock-original-func (symbol-function funcsym)))
       (ad-safe-fset funcsym
                     `(lambda (&rest actual-args)
                        (signal 'mock-error '(called))))))))

(defalias 'mock/teardown 'stub/teardown)

;;;; mock verify
(put 'mock-error 'error-conditions '(mock-error error))
(put 'mock-error 'error-message "Mock error")
(defun mock-verify ()
  (loop for f in -mocked-functions
        when (equal 0 (get f 'mock-call-count))
        do (signal 'mock-error (list 'not-called f)))
  (loop for args in mock-verify-list
        do
        (apply 'mock-verify-args args)))

(defun mock-verify-args (funcsym expected-args actual-args expected-times)
  (loop for e in expected-args
        for a in actual-args
        do
        (unless (eq e '*)               ; `*' is wildcard argument
          (unless (equal (eval e) a)
            (signal 'mock-error (list (cons funcsym expected-args)
                                      (cons funcsym actual-args))))))
  (let ((actual-times (or (get funcsym 'mock-call-count) 0)))
    (and expected-times (/= expected-times actual-times)
         (signal 'mock-error (list (cons funcsym expected-args)
                                   :expected-times expected-times
                                   :actual-times actual-times)))))
;;;; stub/mock provider
(defun mock-protect (body-fn)
  "The substance of `with-mock' macro.
Prepare for mock/stub, call BODY-FN, and teardown mock/stub.

For developer:
When you adapt Emacs Lisp Mock to a testing framework, wrap test method around this function."
  (let (mock-verify-list
        -stubbed-functions
        -mocked-functions
        (in-mocking t))
    ;; (setplist 'mock-original-func nil)
    ;; (setplist 'mock-call-count nil)
    (unwind-protect
        (funcall body-fn)
      (mapc #'stub/teardown -stubbed-functions)
      (unwind-protect
          (mock-verify)
        (mapc #'mock/teardown -mocked-functions)))))

;;;; message hack
(defun mock-suppress-redefinition-message (func)
  "Erase \"ad-handle-definition: `%s' got redefined\" message."
  (prog1
      (funcall func)
    (message "")))
(put 'mock-syntax-error 'error-conditions '(mock-syntax-error error))
(put 'mock-syntax-error 'error-message "Mock syntax error")

;;;; User interface
(defmacro with-mock (&rest body)
  "Execute the forms in BODY. You can use `mock' and `stub' in BODY.
The value returned is the value of the last form in BODY.
After executing BODY, mocks and stubs are guaranteed to be released.

Example:
  (with-mock
    (stub fooz => 2)
    (fooz 9999))                  ; => 2
"
  `(mock-protect
    (lambda () ,@body)))
(defalias 'with-stub 'with-mock)

(defmacro stub (function &rest rest)
  "Create a stub for FUNCTION.
Stubs are temporary functions which accept any arguments and return constant value.
Stubs are removed outside `with-mock' (`with-stub' is an alias) and `mocklet'.

Synopsis:
* (stub FUNCTION)
  Create a FUNCTION stub which returns nil.
* (stub FUNCTION => RETURN-VALUE)
  Create a FUNCTION stub which returns RETURN-VALUE.


Example:
  (with-mock
    (stub foo)
    (stub bar => 1)
    (and (null (foo)) (= (bar 7) 1)))     ; => t
"
  (let ((value (cond ((plist-get rest '=>))
                     ((memq '=> rest) nil)
                     ((null rest) nil)
                     (t (signal 'mock-syntax-error '("Use `(stub FUNC)' or `(stub FUNC => RETURN-VALUE)'"))))))
    `(if (not in-mocking)
         (error "Do not use `stub' outside")
       (stub/setup ',function ',value)
       (push ',function -stubbed-functions))))

(defmacro mock (func-spec &rest rest)
    "Create a mock for function described by FUNC-SPEC.
Mocks are temporary functions which accept specified arguments and return constant value.
If mocked functions are not called or called by different arguments, an `mock-error' occurs.
Mocks are removed outside `with-mock' and `mocklet'.

Synopsis:
* (mock (FUNCTION ARGS...))
  Create a FUNCTION mock which returns nil.
* (mock (FUNCTION ARGS...) => RETURN-VALUE)
  Create a FUNCTION mock which returns RETURN-VALUE.
* (mock (FUNCTION ARGS...) :times N)
  FUNCTION must be called N times.
* (mock (FUNCTION ARGS...) => RETURN-VALUE :times N)
  Create a FUNCTION mock which returns RETURN-VALUE.
  FUNCTION must be called N times.

Wildcard:
The `*' is a special symbol: it accepts any value for that argument position.

Example:
  (with-mock
    (mock (f * 2) => 3)
    (mock (g 3))
    (and (= (f 9 2) 3) (null (g 3))))     ; => t
  (with-mock
    (mock (g 3))
    (g 7))                                ; (mock-error (g 3) (g 7))
"
  (let* ((times (plist-get rest :times))
         (value (cond ((plist-get rest '=>))
                      ((memq '=> rest) nil)
                      ((null rest) nil)
                      ((not times) (signal 'mock-syntax-error '("Use `(mock FUNC-SPEC)' or `(mock FUNC-SPEC => RETURN-VALUE)'"))))))
    `(if (not in-mocking)
         (error "Do not use `mock' outside")
       (mock/setup ',func-spec ',value ,times)
       (push ',(car func-spec) -mocked-functions))))

(defmacro not-called (function)
  "Create a not-called mock for FUNCTION.
Not-called mocks are temporary functions which raises an error when called.
If not-called functions are called, an `mock-error' occurs.
Not-called mocks are removed outside `with-mock' and `mocklet'.

Synopsis:
* (not-called FUNCTION)
  Create a FUNCTION not-called mock.

Example:
  (with-mock
    (not-called f)
    t)     ; => t
  (with-mock
    (not-called g)
    (g 7)) ; => (mock-error called)
"
  (let ()
    `(if (not in-mocking)
         (error "Do not use `not-called' outside")
       (not-called/setup ',function)
       (push ',function -mocked-functions))))


(defun mock-parse-spec (spec)
  (cons 'progn
        (mapcar (lambda (args)
                  (if (eq (cadr args) 'not-called)
                      `(not-called ,(car args))
                    (cons (if (consp (car args)) 'mock 'stub)
                        args)))
                spec)))

(defun mocklet-function (spec body-func)
  (with-mock
    (eval (mock-parse-spec spec))
    (funcall body-func)))

(defmacro mocklet (speclist &rest body)
  "`let'-like interface of `with-mock', `mock', `not-called' and `stub'.

Create mocks and stubs described by SPECLIST then execute the forms in BODY.
SPECLIST is a list of mock/not-called/stub spec.
The value returned is the value of the last form in BODY.
After executing BODY, mocks and stubs are guaranteed to be released.

Synopsis of spec:
Spec is arguments of `mock', `not-called' or `stub'.
* ((FUNCTION ARGS...))                  : mock which returns nil
* ((FUNCTION ARGS...) => RETURN-VALUE)  ; mock which returns RETURN-VALUE
* ((FUNCTION ARGS...) :times N )        ; mock to be called N times
* ((FUNCTION ARGS...) => RETURN-VALUE :times N )  ; mock to be called N times
* (FUNCTION)                            : stub which returns nil
* (FUNCTION => RETURN-VALUE)            ; stub which returns RETURN-VALUE
* (FUNCTION not-called)                 ; not-called FUNCTION

Example:
  (mocklet (((mock-nil 1))
            ((mock-1 *) => 1)
            (stub-nil)
            (stub-2 => 2))
    (and (null (mock-nil 1))    (= (mock-1 4) 1)
         (null (stub-nil 'any)) (= (stub-2) 2))) ; => t
"
  `(mocklet-function ',speclist (lambda () ,@body)))

(defalias 'stublet 'mocklet)

(put 'with-mock 'lisp-indent-function 0)
(put 'with-stub 'lisp-indent-function 0)
(put 'mocklet 'lisp-indent-function 1)
(put 'stublet 'lisp-indent-function 1)

;;;; Bug report
(defvar mock-maintainer-mail-address
  (concat "rubiki" "tch@ru" "by-lang.org"))
(defvar mock-bug-report-salutation
  "Describe bug below, using a precise recipe.

When I executed M-x ...

How to send a bug report:
  1) Be sure to use the LATEST version of el-mock.el.
  2) Enable debugger. M-x toggle-debug-on-error or (setq debug-on-error t)
  3) Use Lisp version instead of compiled one: (load \"el-mock.el\")
  4) If you got an error, please paste *Backtrace* buffer.
  5) Type C-c C-c to send.
# If you are a Japanese, please write in Japanese:-)")
(defun mock-send-bug-report ()
  (interactive)
  (reporter-submit-bug-report
   mock-maintainer-mail-address
   "el-mock.el"
   (apropos-internal "^mock-" 'boundp)
   nil nil
   mock-bug-report-salutation))


(provide 'el-mock)

;;; el-mock.el ends here
