;; -*- coding: utf-8 -*-

(wttr/plugin:prepend-to-load-path "actionscript-mode")
(autoload 'actionscript-mode "actionscript-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.as$" . actionscript-mode))

(defvar as-imenu-as-generic-expression
  ` (
    ("variables"
     ,(concat
        "^"                                 ; line MUST start with word char
        "[ \t]*\\(public\\|protected\\|mx_internal\\|private\\)"
        "[ \t]*\\(static\\)?"
        "[ \t]+var"
        "[ \t]+\\([a-zA-Z_][a-zA-Z0-9_]*\\)"     ; match function name
        "[ \t]*:\[ \t]*\\([a-zA-Z_][a-zA-Z0-9_]*\\)"
        ) 3)
    ;; Getters
    ("Getters"
     ,(concat
       "^"                                 ; line MUST start with word char
       "[ \t]*\\(override[ \t\n]+\\)?"                               ; no parentheses before
        "[ \t]*\\(public\\|protected\\|mx_internal\\|private\\)"
        "[ \t]+function"
        "[ \t]+"
        "\\(get[ \t]+\\([a-zA-Z_][a-zA-Z0-9_]*\\)[ \t]*\\)()"     ; getter
       ) 3)
    ;;setters
    ("setters"
     ,(concat
       "^"                                 ; line MUST start with word char
       "[ \t]*\\(override[ \t\n]+\\)?"                               ; no parentheses before
        "[ \t]*\\(public\\|protected\\|mx_internal\\|private\\)"
        "[ \t]+function"
        "[ \t]+"
        "\\(set[ \t]+\\([a-zA-Z_][a-zA-Z0-9_]*\\)[ \t]*\\)"     ; setter
        "("
        "\\([a-zA-Z_][a-zA-Z0-9_]*\\):\\([a-zA-Z_][a-zA-Z0-9_]*\\)[ \t\n]*"
        ")"
       ) 3)

    ;; Class definitions
    ("class" 
     ,(concat
         "^"                           ; beginning of line is required
         "\\(\\(public\\|protected\\|mx_internal\\|private\\)[ \t]+\\)?"
         "\\(class\\|interface\\)[ \t]+"
         "\\([a-zA-Z0-9_\\]+\\.\\)*" ; maybe the class name has prefix
         "\\("                       ; the string we want to get
         "[a-zA-Z0-9_]+"             ; class name
         "\\)"
         "[ \t\n]*"
         "\\(extends [ \t\n]*[a-zA-Z0-9_]+\\)?"
         "[ \t\n]*";;[:{]"
         "\\(implements [ \t\n]*\\([a-zA-Z0-9_]+[,][ \t\n]*\\)*[a-zA-Z0-9_]\\)?"
         "[ \t\n]*";;[:{]"
         ) 5)

    ;; General function name regexp
    (nil
     ,(concat
       "^"                                 ; line MUST start with word char
       "[ \t]*\\(override[ \t\n]+\\)?"                               ; no parentheses before
        "[ \t]*\\(public\\|protected\\|mx_internal\\|private\\)"
       "\\([ \t]+static\\)?"                               ; no parentheses before
        "[ \t]+function"
        "[ \t]+\\([a-zA-Z_][a-zA-Z0-9_]*\\)"     ; match function name
        "[ \t]*("
        "[^)]*)"
       ) 4)
    )
  "Imenu generic expression for actionscript mode.  See `imenu-generic-expression'.")



(defun actionscript-init-imenu ()
  (interactive)
  (setq imenu-generic-expression as-imenu-as-generic-expression))

(add-hook 'actionscript-mode-hook
          (lambda ()
            (actionscript-init-imenu)
            (imenu-add-menubar-index)))

(eval-after-load "which-func"
  '(add-hook 'which-func-modes 'actionscript-mode))
