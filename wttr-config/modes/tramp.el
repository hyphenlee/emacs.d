;; -*- coding: utf-8 -*-

;; tramp
;; 1. Download putty installer with all the tools.
;; 2. Put putty install in the path
;; 3. Generate a key with PuttyGen
;; 4. Copy public key to your server
;; 5. Append public key to your .ssh/authorized_keys file (be sure to
;; remove extraneous puttygen text, just get the key)
;; 6. Load up pageant and add your private key (this can be automated
;; on windows boot)
;; 7. Add the following to your .emacs config

;; As long as pageant is running with your key, you can edit your
;; remote files using the format ssh://user@server:path/to/file
;; (require 'tramp)
(when wttr/os:windowsp
  (wttr/prepend-to-exec-path "~/.emacs.d/extra-bin/PuTTY")
  (setq default-tramp-method "plink"))
