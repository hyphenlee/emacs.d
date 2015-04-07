;(wttr/plugin:prepend-to-load-path "helm")
(require 'helm)
(require 'helm-config)
(global-set-key (kbd "C-c f") 'helm-do-grep)
