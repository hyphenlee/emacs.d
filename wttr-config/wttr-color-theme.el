;; -*- coding: utf-8 -*-
(require 'wttr-utils)

;; Color Theme
(wttr/plugin:prepend-to-load-path "color-theme-6.6.0")
(require 'color-theme)

;; Color theme subdued
;(require 'color-theme-subdued)
;(color-theme-subdued)
(color-theme-initialize)
(color-theme-blue-sea)

;(wttr/plugin:prepend-to-load-path "color-theme-solarized")
;(require 'color-theme-solarized)
;(color-theme-solarized-dark)

(provide 'wttr-color-theme)
