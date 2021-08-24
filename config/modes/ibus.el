(wttr/plugin:prepend-to-load-path "ibus")
(require 'ibus)
(add-hook 'after-init-hook 'ibus-mode-on)
