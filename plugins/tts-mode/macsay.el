;;; macsay.el --- Mac OS X's nativel tts engine.

;; Copyright (C) 2013  zxsu

;; Author: zxsu <suzp1984@gmail.com>
;; Keywords: 

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; 2013-10-05 12:53 zxsu <suzp1984@gmail.com> init

;;; Code:

(defgroup say nil
  "Mac OS X's native tts engine"
  :tag "Mac OS X's TTS engine"
  :version "0.1"
  :group 'tts)

(defcustom say-program "/usr/bin/say"
  "Mac OS X's tts engine -- say"
  :type '(file :must-match t)
  :group 'say)

(defcustom say-buffer nil
  "Buffer attached to say-process"
  :group 'say) 

(defvar say-process nil
  "Process handle for say program")

(defvar say-process-alist nil
  "alist collect of processes.")

(defvar say-process-name "say")


(defun say-start ()
  "start say process"
  (interactive)
  (let ((process (get-process say-process-name))
        (args))
    (unless (processp process)
      (setq process (eval `(start-process say-process-name
                                          say-buffer say-program ,@args)))
      (setq say-process process))
    )
  )

(defun say-stop ()
  "Stop say process"
  (interactive)
  (when (processp (get-process "say"))
    (kill-process (get-process "say"))
    (sit-for 1))
  (setq say-process nil))

(defun sayp ()
  "return `t' if a say process is running, unless nil"
  (let ((sayp (processp (get-process "say"))))
    (when (not sayp)
      (say-start)
      (setq sayp t))
    sayp))

(defun say-say (text)
  "Say text via say process"
  (interactive "sText: ")
;;  (when (sayp)
;;    (process-send-string say-process text)
    (start-process say-process-name say-buffer 
                   say-program text))

(provide 'macsay)
;;; macsay.el ends here
