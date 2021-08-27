;; -*- coding: utf-8 -*-
(defconst os:windowsp (eq system-type 'windows-nt))
(defconst os:osxp (eq system-type 'darwin))
(defconst os:linuxp (eq system-type 'gnu/linux))
(provide 'utils)
