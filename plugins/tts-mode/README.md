tts-mode
========

TTS mode in emacs


how to INSTALL it?
------------------

1. Download the source code
2. add the following line into emacs init file
   (add-to-list 'load-path "path/to/tts-mode")

   ;; configure tts engine's command path if needed
   ; (setq espeak-program "/usr/bin/espeak")
   ; (setq festival-program "/usr/bin/festival")
   ; (setq say-program "/usr/bin/say");

   ;; require tts
   (require 'tts)
3. start tts-mode 
   M-x tts
4. change the voice
   M-x tts-voice

------------------