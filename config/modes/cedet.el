;;-*- coding: utf-8 -*-
(require 'wttr-utils)

;; compile command:
;;   emacs -Q -l cedet-build.el -f cedet-build

(require 'cedet)
(add-to-list 'semantic-default-submodes 'global-semanticdb-minor-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-mru-bookmark-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-idle-scheduler-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-highlight-func-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-decoration-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-idle-local-symbol-highlight-mode)


;; Activate semantic
(require 'semantic)
(semantic-mode 1)


(require 'semantic/ia)
(require 'semantic/bovine/c)
(require 'semantic/bovine/el)


(defun wttr/cedet:init ()
  (local-set-key [(control return)] 'semantic-ia-complete-symbol-menu)
  (local-set-key "\C-c?" 'semantic-ia-complete-symbol)
  (local-set-key "\C-c=" 'semantic-decoration-include-visit)

  (local-set-key "\C-cj" 'semantic-ia-fast-jump)
  (local-set-key "\C-cq" 'semantic-ia-show-doc)
  (local-set-key "\C-cs" 'semantic-ia-show-summary)
  (local-set-key "\C-cp" 'semantic-analyze-proto-impl-toggle)

  (add-to-list 'ac-sources 'ac-source-semantic)

  )


(add-hook 'c-mode-common-hook 'wttr/cedet:init)
(add-hook 'actionscript-mode-hook 'wttr/cedet:init)
(add-hook 'lisp-mode-hook 'wttr/cedet:init)
(add-hook 'emacs-lisp-mode-hook 'wttr/cedet:init)


(require 'cedet-global)
(when (cedet-gnu-global-version-check t)
  (semanticdb-enable-gnu-global-databases 'c-mode t)
  (semanticdb-enable-gnu-global-databases 'c++mode t))


(require 'srecode/mode)
(global-srecode-minor-mode 1)

;; Enable EDE(Emacs Develpment Enviroment) mode
(global-ede-mode t)
(ede-enable-generic-projects)



;;; EDE example
                                        ;(ede-cpp-root-project "CedetTest"
                                        ;                :name "Test Cedet"
                                        ;                :file "d:/_SRC_/_mine_/__CPP__/cedet/anchor.TXT"
                                        ;                :include-path '("/"
                                        ;                                "/a"
                                        ;                                "/b"
                                        ;                               )
                                        ;                :system-include-path '()
                                        ;                :spp-table '(("BOOST_TEST_DYN_LINK" . "")))

;; Use Re-Code mode, a template mode, I use yasnippet, so ignore it.
                                        ;(global-srecode-minor-mode 1)


;; the function can be folded
                                        ;(global-semantic-tag-folding-mode 1)


;; 
;; (setq senator-minor-mode-name "SN")
;; (setq semantic-imenu-auto-rebuild-directory-indexes nil)
;; (global-semantic-mru-bookmark-mode 1)
;; 
;; (require 'semantic-decorate-include)
;; (require 'semantic-ia)
;; (require 'semantic-gcc)
;;; use need to update the specific path
;; (let ((c++-include-path-list (cond
;;                              (wttr/host:SWSp
;;                               (list "C:/MinGW/include"
;;                            "C:/MinGW/lib/gcc/mingw32/4.8.1/include"
;;                                   "C:/MinGW/lib/gcc/mingw32/4.8.1/include/c++"
;;                                   "C:/MinGW/lib/gcc/mingw32/4.8.1/include/c++/mingw32"))
;;                              (wttr/host:HOMEp
;;                               (list "C:/MinGW/include"
;;                            "C:/MinGW/lib/gcc/mingw32/4.8.1/include"
;;                                   "C:/MinGW/lib/gcc/mingw32/4.8.1/include/c++"
;;                                   "C:/MinGW/lib/gcc/mingw32/4.8.1/include/c++/mingw32"))
;;                              (t
;;                               nil))))
(if (string-equal system-type  "windows-nt")
    (let ((c++-include-path-list  (list "C:/MinGW/include"
                                        "C:/MinGW/lib/gcc/mingw32/4.8.1/include"
                                        "d:/work/rtsuite-new/utils/dcmtk-3.6.1/include"
                                        "d:/work/rtsuite-new/utils/dtl/include"
                                        "d:/work/rtsuite-new/utils/wxWidgets-2.9.4//include"
                                        "d:/work/rtsuite-new/utils/poco-1.5.2///include"
                                        "C:/MinGW/lib/gcc/mingw32/4.8.1/include/c++"
                                        "C:/MinGW/lib/gcc/mingw32/4.8.1/include/c++/mingw32")))
      (mapc (lambda (x)
              (semantic-add-system-include x 'c++-mode)
              (semantic-add-system-include x 'c-mode))
            c++-include-path-list)))
(if (string-equal system-type "darwin")
    (let ((c++-include-path-list (list
                                  "/usr/local/include/"
                                  "/usr/include"
                                  )))
      (mapc (lambda (x)
              (semantic-add-system-include x 'c++-mode)
              (semantic-add-system-include x 'c-mode))
            c++-include-path-list)))
    
;; 
;;;Getting information about tags
                                        ;
;;;The semantic-ia package implements several commands, that allows to
;;;get information about classes, functions & variables. As
;;;documentation are used comments, extracted from source code,
;;;including comments, written for Doxygen. Now following commands are
;;;implemented:
                                        ;
;;;semantic-ia-show-doc
;;;    shows documentation for function or variable, whose names is
;;;    under point. Documentation is shown in separate buffer. For
;;;    variables this command shows their declaration, including type
;;;    of variable, and documentation string, if it available. For
;;;    functions, prototype of the function is shown, including
;;;    documentation for arguments and returning value (if comments are
;;;    available);
;;;semantic-ia-show-summary
;;;    shows documentation for name under point, but information is
;;;    shown in the mini-buffer, so user will see only variable's
;;;    declaration or function's prototype;
;;;semantic-ia-describe-class
;;;    asks user for a name of the class, and return list of functions
;;;    & variables, defined in given class, and all its parent classes.
                                        ;
;;semantic-ia-fast-jump
;;semantic-mrub-switch-tag
                                        ;

                                        ;
;; ============================
;;         ecb mode
;; ============================
                                        ;(wttr/plugin:prepend-to-load-path "ecb")
;; (require 'ecb)

;; ;;error reports if i do not set this var
;; (setq stack-trace-on-error t)           
;; ;;disable tips, kinda noisy
;; (setq ecb-tip-of-the-day nil)
;; ;;use 'image style, i like this than 'ascii-guide
;; (setq ecb-tree-buffer-style 'image)
;; ;;do not remove record in history when kill-buffer
;; (setq ecb-kill-buffer-clears-history nil)
;; ;;bucket the history by major-mode
;; (setq ecb-history-make-buckets 'mode)
;; ;use manually update, c-c . r
;; ;(setq ecb-analyse-buffer-sync nil)
;; ;; start ecb in a new frame
;; (setq ecb-new-ecb-frame nil)
;; ;; use mouse 1 instead of mouse 2
;; (setq ecb-primary-secondary-mouse-buttons 'mouse-1--C-mouse-1)
;; ;; compile window
;; ;(setq ecb-compile-window-height nil)
;; ;; whether show file in directory-buffer
;; ;(setq ecb-show-sources-in-directories-buffer 'always)
;; (setq ecb-show-sources-in-directories-buffer
;;       (list "left7" "left13" "left14" "left15"))


;; (defun wttr/ecb:smart-switch-layout (layout-name)
;;   "If the layout name is not current layout, open/swtich to it.
;; Other close current ecb layout."
;;   (if (and (boundp 'ecb-minor-mode) ecb-minor-mode)
;;       (if (string-equal ecb-layout-name layout-name)
;;           (ecb-deactivate)
;;         (ecb-layout-switch layout-name))
;;     (progn
;;       (setq ecb-layout-name layout-name)
;;       (ecb-activate))))

;; (defun wttr/ecb:left-method-layout ()
;;   (interactive)
;;   (wttr/ecb:smart-switch-layout "left9"))


;; (defun wttr/ecb:left-directory-layout ()
;;   (interactive)
;;   (wttr/ecb:smart-switch-layout "left13"))


;; (defun wttr/ecb:left-directory-method-layout ()
;;   "Open left directory window, default to left15 layout"
;;   (interactive)
;;   (wttr/ecb:smart-switch-layout "left15"))

;; (global-set-key (kbd "<f11>") 'wttr/ecb:left-directory-layout)
;; (global-set-key (kbd "<f12>") 'wttr/ecb:left-method-layout)



















