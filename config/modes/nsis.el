 (autoload 'nsis-mode "nsis-mode" "NSIS mode" t)

 (setq auto-mode-alist (append '(("\\.\\([Nn][Ss][Ii]\\)$" .
                                  nsis-mode)) auto-mode-alist))

 (setq auto-mode-alist (append '(("\\.\\([Nn][Ss][Hh]\\)$" .
                                  nsis-mode)) auto-mode-alist))
