;; -*- coding: utf-8 -*-
(wttr/plugin:prepend-to-load-path "gtags")
(wttr/prepend-to-exec-path "~/.emacs.d/extra-bin/gtags")
(autoload 'gtags-mode "gtags" "" t)
(setq gtags-suggested-key-mapping t)

(add-hook 'gtags-mode-hook
  '(lambda ()
     ;use relative path to root
     (setq gtags-path-style 'root)      
     ;will not delete buffer when popup
     (setq gtags-pop-delete nil)        
     ;only use on select buffer
     (setq gtags-select-buffer-single t)
     ;mouse mapping is kinda useful, i use it
     (setq gtags-disable-pushy-mouse-mapping nil)))

(add-hook 'gtags-select-mode-hook
  '(lambda ()
     (setq hl-line-face 'underline)
     (hl-line-mode 1)))

(defun wttr/cc-mode:gtags-setup ()
  (gtags-mode 1))

(add-hook 'c-mode-hook #'wttr/cc-mode:gtags-setup)
(add-hook 'c++-mode-hook #'wttr/cc-mode:gtags-setup)


