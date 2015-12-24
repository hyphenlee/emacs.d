;;; espeak.el --- emacs interface for espeak

(defgroup espeak nil
  "A TTS engine - espeak can provide 
more international language. For myself chinese."
  :tag "The espeak TTS engine"
  :version "0.1"
  :group 'tts)

(defcustom espeak-program "/usr/local/bin/espeak"
  "Location of the espeak program"
  :type '(file :must-match t)
  :group 'espeak)

(defcustom espeak-buffer nil
  "Buffer attached to espeak-process"
  :group 'espeak)

(defvar espeak-process nil
  "Process handle for the espeak program.")

(defvar espeak-process-alist nil
  "alist collect of processes.")

(defvar espeak-process-name "espeak"
  "default process name")

(defvar espeak-name-args-alist '(("espeak" . ("-v" "default"))
                                 ("espeak" . ("-v" "zh")))
  "alist for name and args")

(defvar espeak-prog-args '("-v" "default")
  "espeak process args.")

(defun espeak-start ()
  "Start espeak process."
  (interactive)
  (let ((process (get-process espeak-process-name))
        (args (cdr (assoc espeak-process-name espeak-name-args-alist)))) 
    (unless (processp process)
      (setq process (eval `(start-process espeak-process-name 
                                          espeak-buffer espeak-program 
                                          ,@args))))
    (unless (processp (cdr (assoc espeak-process-name espeak-process-alist)))
      (add-to-list 'espeak-process-alist (cons espeak-process-name  process))))
  )
 
(defun espeak-stop ()
  "Stop espeak process."
  (interactive)
  (when (processp espeak-process)
    (kill-process espeak-process)
    (sit-for 1))
  (setq espeak-process nil))

(defun espeakp ()
  "Return `t' if a espeak process is running, unless nil"
  (let ((espeakp (processp (cdr (assoc espeak-process-name espeak-process-alist)))))
    (when (not espeakp)
      (espeak-start)
      (setq espeakp t))
    espeakp))

(defun espeak-say (text)
  "Say Text via espeak process"
  (interactive "sText: ")
  (when (espeakp)
    (process-send-string (cdr (assoc espeak-process-name espeak-process-alist)) (concat text "\n"))))

(provide 'espeak)
