;;; rtags-autoloads.el --- automatically extracted autoloads
;;
;;; Code:
(add-to-list 'load-path (or (file-name-directory #$) (car load-path)))

;;;### (autoloads nil "rtags" "rtags.el" (22155 32704 0 0))
;;; Generated autoloads from rtags.el

(autoload 'rtags-bury-or-delete "rtags" "\


\(fn)" t nil)

(autoload 'rtags-next-match "rtags" "\


\(fn)" t nil)

(autoload 'rtags-previous-match "rtags" "\


\(fn)" t nil)

(autoload 'rtags-next-diag "rtags" "\


\(fn)" t nil)

(autoload 'rtags-previous-diag "rtags" "\


\(fn)" t nil)

(autoload 'rtags-preprocess-file "rtags" "\


\(fn &optional BUFFER)" t nil)

(autoload 'rtags-set-current-project "rtags" "\


\(fn)" t nil)

(autoload 'rtags-print-symbol-info "rtags" "\


\(fn &optional VERBOSE)" t nil)

(autoload 'rtags-symbol-type "rtags" "\


\(fn)" t nil)

(autoload 'rtags-print-dependencies "rtags" "\


\(fn &optional PREFIX BUFFER)" t nil)

(defvar rtags-dependency-tree-data nil)

(autoload 'rtags-references-tree "rtags" "\


\(fn)" t nil)

(autoload 'rtags-print-source-arguments "rtags" "\


\(fn &optional BUFFER)" t nil)

(autoload 'rtags-print-class-hierarchy "rtags" "\


\(fn)" t nil)

(autoload 'rtags-print-enum-value-at-point "rtags" "\


\(fn &optional LOCATION)" t nil)

(autoload 'rtags-goto-offset "rtags" "\


\(fn POS)" t nil)

(autoload 'rtags-location-stack-jump "rtags" "\


\(fn BY)" t nil)

(autoload 'rtags-enable-standard-keybindings "rtags" "\


\(fn &optional MAP PREFIX)" t nil)

(autoload 'rtags-print-current-location "rtags" "\


\(fn)" t nil)

(autoload 'rtags-location-stack-forward "rtags" "\


\(fn)" t nil)

(autoload 'rtags-location-stack-back "rtags" "\


\(fn)" t nil)

(autoload 'rtags-location-stack-reset "rtags" "\


\(fn)" t nil)

(autoload 'rtags-find-symbol-at-point "rtags" "\
Find the natural target for the symbol under the cursor and moves to that location.
For references this means to jump to the definition/declaration of the referenced symbol (it jumps to the definition if it is indexed).
For definitions it jumps to the declaration (if there is only one) For declarations it jumps to the definition.
If called with a prefix restrict to current buffer

\(fn &optional PREFIX)" t nil)

(autoload 'rtags-find-references-at-point "rtags" "\
Find all references to the symbol under the cursor.
If there's exactly one result jump directly to it. If there's more show a buffer
with the different alternatives and jump to the first one if `rtags-jump-to-first-match'
is true. References to references will be treated as references to the referenced symbol

\(fn &optional PREFIX)" t nil)

(autoload 'rtags-find-virtuals-at-point "rtags" "\
List all reimplentations of function under cursor. This includes both declarations and definitions

\(fn &optional PREFIX)" t nil)

(autoload 'rtags-find-all-references-at-point "rtags" "\


\(fn &optional PREFIX)" t nil)

(autoload 'rtags-guess-function-at-point "rtags" "\


\(fn)" t nil)

(autoload 'rtags-rename-symbol "rtags" "\


\(fn)" t nil)

(autoload 'rtags-find-symbol "rtags" "\


\(fn &optional PREFIX)" t nil)

(autoload 'rtags-find-references "rtags" "\


\(fn &optional PREFIX)" t nil)

(autoload 'rtags-find-symbol-current-file "rtags" "\


\(fn)" t nil)

(autoload 'rtags-find-references-current-file "rtags" "\


\(fn)" t nil)

(autoload 'rtags-find-symbol-current-dir "rtags" "\


\(fn)" t nil)

(autoload 'rtags-find-references-current-dir "rtags" "\


\(fn)" t nil)

(autoload 'rtags-apply-fixit-at-point "rtags" "\


\(fn)" t nil)

(autoload 'rtags-clear-diagnostics-overlays "rtags" "\


\(fn &optional BUF)" t nil)

(autoload 'rtags-is-running "rtags" "\


\(fn)" t nil)

(autoload 'rtags-cycle-overlays-on-screen "rtags" "\


\(fn)" t nil)

(autoload 'rtags-fix-fixit-at-point "rtags" "\


\(fn)" t nil)

(autoload 'rtags-restart-tracking-timer "rtags" "\


\(fn)" t nil)

(autoload 'rtags-post-command-hook "rtags" "\


\(fn)" t nil)

(autoload 'rtags-toggle-diangnostics-suspended "rtags" "\


\(fn &optional QUIET)" t nil)

(autoload 'rtags-set-diangnostics-suspended "rtags" "\


\(fn &optional QUIET)" t nil)

(autoload 'rtags-stop-diagnostics "rtags" "\


\(fn)" t nil)

(autoload 'rtags-clear-diagnostics "rtags" "\


\(fn)" t nil)

(autoload 'rtags-diagnostics "rtags" "\


\(fn &optional RESTART NODIRTY)" t nil)

(autoload 'rtags-compilation-flags "rtags" "\


\(fn)" t nil)

(autoload 'rtags-close-taglist "rtags" "\


\(fn)" t nil)

(autoload 'rtags-taglist "rtags" "\


\(fn &optional DEST-WINDOW)" t nil)

(autoload 'rtags-select "rtags" "\


\(fn &optional OTHER-WINDOW REMOVE SHOW)" t nil)

(autoload 'rtags-select-other-window "rtags" "\


\(fn &optional NOT-OTHER-WINDOW)" t nil)

(autoload 'rtags-show-in-other-window "rtags" "\


\(fn)" t nil)

(autoload 'rtags-select-and-remove-rtags-buffer "rtags" "\


\(fn)" t nil)

(autoload 'rtags-imenu "rtags" "\


\(fn)" t nil)

(autoload 'rtags-copy-and-print-current-location "rtags" "\


\(fn)" t nil)

(autoload 'rtags-find-file "rtags" "\


\(fn &optional PREFIX TAGNAME)" t nil)

(autoload 'rtags-show-rtags-buffer "rtags" "\


\(fn)" t nil)

(autoload 'rtags-fixit "rtags" "\


\(fn &optional EDIFF BUFFER)" t nil)

(autoload 'rtags-remove-other-window "rtags" "\


\(fn)" t nil)

(autoload 'rtags-update-current-project "rtags" "\


\(fn)" t nil)

(autoload 'rtags-show-target-in-other-window "rtags" "\
DEST-WINDOW : destination window. Can be nil; in this case the current window is split
according to `rtags-other-window-window-size-percentage'.
CENTER-WINDOW : if true the target window is centered.
TRY-DECLARATION-FIRST : first try to find the declaration of the item, then the
definition.

\(fn &optional DEST-WINDOW CENTER-WINDOW TRY-DECLARATION-FIRST)" t nil)

(autoload 'rtags-toggle-file-suspended "rtags" "\


\(fn)" t nil)

(autoload 'rtags-clear-suspended-files "rtags" "\


\(fn)" t nil)

(autoload 'rtags-list-suspended-files "rtags" "\


\(fn)" t nil)

(autoload 'rtags-compile-file "rtags" "\


\(fn &optional BUFFER)" t nil)

(autoload 'rtags-quit-rdm "rtags" "\


\(fn)" t nil)

(autoload 'rtags-restart-process "rtags" "\


\(fn)" t nil)

(autoload 'rtags-start-process-unless-running "rtags" "\
Launch the rtags process (rdm) if it's not already started.

\(fn)" t nil)

(autoload 'rtags-reparse-file "rtags" "\
WAIT-REPARSING : t to wait for reparsing to finish, nil for async (no waiting).

\(fn &optional BUFFER WAIT-REPARSING)" t nil)

(autoload 'rtags-maybe-reparse-file "rtags" "\


\(fn &optional BUFFER)" t nil)

(autoload 'rtags-update-completions-timer "rtags" "\


\(fn)" t nil)

(autoload 'rtags-update-completions "rtags" "\


\(fn &optional FORCE)" t nil)

(autoload 'rtags-display-summary "rtags" "\
Display a short text describing the item at point (see `rtags-get-summary-text' for
details).

If `rtags-display-summary-as-tooltip' is t, a tooltip is displayed.

\(fn &optional HIDE-EMPTY)" t nil)

(autoload 'rtags-get-include-file-for-symbol "rtags" "\
Insert #include declaration to buffer corresponding to the input symbol.

\(fn)" t nil)

(autoload 'rtags-make-member "rtags" "\


\(fn)" t nil)

(autoload 'rtags-check-includes "rtags" "\


\(fn)" t nil)

(autoload 'rtags-create-doxygen-comment "rtags" "\
Creates doxygen comment for function at point Comment will be inserted before current line. It uses yasnippet to let the user enter missing field manually.

\(fn)" t nil)

;;;***

;;;### (autoloads nil nil ("company-rtags.el" "compile-shim.el" "rtags-ac.el"
;;;;;;  "rtags-pkg.el") (22155 32704 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; End:
;;; rtags-autoloads.el ends here
