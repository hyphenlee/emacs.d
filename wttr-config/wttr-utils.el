;; -*- coding: utf-8 -*-

;; some const variable
(defconst wttr/os:windowsp (eq system-type 'windows-nt)
  "if current operation system is windows system")

(defconst wttr/os:linuxp (eq system-type 'gnu/linux)
  "if current operation system is linux")

(defconst wttr/os:win32p (and wttr/os:windowsp
                              (not (getenv "PROGRAMW6432")))
  "if current operation system is windows 32bit version")

(defconst wttr/os:win64p (and wttr/os:windowsp
                              (getenv "PROGRAMW6432"))
  "if current operation system is windows 64bit verison.")

(defconst wttr/host:MSWSp (string-equal system-name "WTTR-T5500")
  "if the currrent host is Microsoft workstation")

(defconst wttr/host:HOMEp (string-equal system-name "WTTR-HOME-T61")
  "if the current host is home laptop")

(defconst wttr/plugin:base-directory "~/.emacs.d/plugins"
  "The root directory that all the extra plugin will put in")


;; `load-path' is a list of directories where Emacs Lisp libraries
;; (`.el' and `.elc' files) are installed.
;;
;; `exec-path' is different: it is a list of directories where
;; executable programs are installed.
;;
;; Shouldn't be `exec-path' and `PATH' achieve the same goal under
;; Emacs?
;;
;; No. `exec-path' is used by Emacs to search for programs it runs
;; directly.  But `M-x grep' does not run `grep.exe' directly; it runs
;; the shell passing it a command that invokes `grep'. So it's the
;; shell that needs to find `grep.exe', and it uses PATH, of course,
;; not `exec-path'.
;;
;; So the right thing to do when you install a new program, in order
;; for Emacs to find it, is *both* to update `exec-path' *and* update
;; `PATH'. This is because some Emacs features invoke programs
;; directly, while others do that through the shell or some other
;; intermediary programs.
(defun wttr/prepend-to-exec-path (path)
  "prepend the path to the emacs intenral `exec-path' and \"PATH\" env variable.
Return the updated `exec-path'"
  (setenv "PATH" (concat (expand-file-name path)
                         path-separator
                         (getenv "PATH")))
  (setq exec-path
        (cons (expand-file-name path)
              exec-path)))

(defun wttr/log:message (message &rest args)
  "Display the warning message into *init* buffer"
  (display-warning 'wttr-config (apply 'format message args) :warning "*wttr-config*"))


;; Prepend a path to the begin of the `load-path'
(defun wttr/prepend-to-load-path (path)
  "prepend the PATH to the head of the `load-path', return updated load-path."
  (add-to-list 'load-path path))


(defun wttr/plugin:expand-file-name (relative-path &optional base-diretory)
  "Expand the RELATIVE-PATH according to BASE-DIRECORY.
If BASE-DIRECORY is nil, use `wttr/plugin:base-directory'."
  (expand-file-name relative-path (or base-diretory wttr/plugin:base-directory)))


(defun wttr/plugin:prepend-to-load-path (plugin-folder-name &optional base-diretory)
  "Prepend the plugin in BASE-DIRECTORY in the `load-path', so that you can use `require' later.
If BASE-DIRECTORY is nil, use `wttr/plugin:base-directory' as base director.
This function will also check if the plugin folder exist before prepend to `load-path'."
  (let ((full-path (wttr/plugin:expand-file-name plugin-folder-name base-diretory)))
    (cond
     ((file-exists-p full-path)
      (wttr/prepend-to-load-path full-path)
      full-path)
     (t
      (wttr/log:message "plugin dir [%s] does not exist, loading possibly failed." full-path)
      nil))))


(defun wttr/delete-trailing-whitespace-when-save ()
  "add local hook, so that when save action happens, auto remove the trailing whitespaces"
  (add-hook 'local-write-file-hooks
            (lambda ()
              (save-excursion
                (delete-trailing-whitespace)))))


(defun wttr/kill-buffer-may-have-clients ()
  "The same as kill buffer, but if this buffer is open via
emacsclient, also notify the server to close connection."
  (interactive)
  (if (and (boundp 'server-buffer-clients)
           server-buffer-clients)
      (server-kill-buffer))
  (kill-buffer (current-buffer)))


;; setup startup window size
(when wttr/os:windowsp
  (defun wttr/w32-restore-frame ()
    "Restore a minimized frame"
    (interactive)
    (w32-send-sys-command 61728))

  (defun wttr/w32-maximize-frame ()
    "Maximize the current frame"
    (interactive)
    (w32-send-sys-command 61488)))


(provide 'wttr-utils)
