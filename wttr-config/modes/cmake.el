;;(setq load-path (cons (expand-file-name "/opt/emacs_plugins") load-path))  
(require 'cmake-mode)
(setq auto-mode-alist  
      (append '(("CMakeLists\\.txt\\'" . cmake-mode)  
                ("\\.cmake\\'" . cmake-mode))  
              auto-mode-alist))
