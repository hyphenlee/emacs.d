;; -*- coding: utf-8 -*-

(wttr/plugin:prepend-to-load-path "fsharp-mode")
(add-to-list 'auto-mode-alist '("\\.fs[iylx]?$" . fsharp-mode))
(autoload 'fsharp-mode "fsharp" "Major mode for editing F# code." t)
(autoload 'run-fsharp "inf-fsharp" "Run an inferior F# process." t)

(cond
 (wttr/host:MSWSp
  (setq inferior-fsharp-program "\"C:/Program Files (x86)/Microsoft F#/v4.0/Fsi.exe\"")
  (setq fsharp-compiler "\"C:/Program Files (x86)/Microsoft F#/v4.0/Fsc.exe\""))
 (wttr/host:HOMEp
  (setq inferior-fsharp-program "\"C:/Program Files/Microsoft F#/v4.0/Fsi.exe\"")
  (setq fsharp-compiler "\"C:/Program Files/Microsoft F#/v4.0/Fsc.exe\""))
 (t
  nil))
