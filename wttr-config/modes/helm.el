(wttr/plugin:prepend-to-load-path "helm")
(require 'helm-config)
(helm-mode 1)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
