(add-hook 'load-path "~/.emacs.d/plugins/tts-mode")
(require 'tts)
(tts-voice-macsay)
(defun tts-current-buffer()
  (interactive )
  (if (get-process "say")
      (kill-process (get-process "say"))
    (progn
      (if mark-active
          (setq start (region-beginning)
                end (region-end))
        (setq start (point-min)
              end (point-max)))
    (tts-say (buffer-substring-no-properties start end)))))

