;; -*- coding: utf-8 -*-
(when (boundp 'windmove-default-keybindings)
  (windmove-default-keybindings 'meta))
(global-set-key (kbd "M-j") 'windmove-down)
(global-set-key (kbd "M-k") 'windmove-up)
(global-set-key (kbd "M-h") 'windmove-left)
(global-set-key (kbd "M-l") 'windmove-right)
