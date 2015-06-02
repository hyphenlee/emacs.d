;;; ido-completing-read+-autoloads.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads (ido-completing-read+) "ido-completing-read+" "ido-completing-read+.el"
;;;;;;  (21854 37585 510315 511000))
;;; Generated autoloads from ido-completing-read+.el

(autoload 'ido-completing-read+ "ido-completing-read+" "\
ido-based method for reading from the minibuffer with completion.

See `completing-read' for the meaning of the arguments.

This function is a wrapper for `ido-completing-read' designed to
be used as the value of `completing-read-function'. Importantly,
it detects edge cases that ido cannot handle and uses normal
completion for them.

\(fn PROMPT COLLECTION &optional PREDICATE REQUIRE-MATCH INITIAL-INPUT HIST DEF INHERIT-INPUT-METHOD)" nil nil)

(defadvice ido-completing-read (around ido-cr+ activate) "\
This advice handles application of ido-completing-read+ features.

First, it ensures that `ido-cr+-enable-this-call' is set
properly. This variable should be non-nil during execution of
`ido-completing-read' if it was called from
`ido-completing-read+'.

Second, if `ido-cr+-replace-completely' is non-nil, then this
advice completely replaces `ido-completing-read' with
`ido-completing-read+'." (when (not (featurep (quote ido-completing-read+))) (require (quote ido-completing-read+))) (let ((ido-cr+-enable-this-call ido-cr+-enable-next-call) (ido-cr+-enable-next-call nil)) (if (or ido-cr+-enable-this-call (not ido-cr+-replace-completely)) ad-do-it (message "Replacing ido-completing-read") (setq ad-return-value (apply (function ido-completing-read+) (ad-get-args 0))))))

;;;***

;;;### (autoloads nil nil ("ido-completing-read+-pkg.el") (21854
;;;;;;  37585 518417 573000))

;;;***

(provide 'ido-completing-read+-autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; ido-completing-read+-autoloads.el ends here
