(require 'flycheck)
(add-hook 'js-mode-hook
          (lambda () (flycheck-mode t)))
