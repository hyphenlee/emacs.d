
;; -*- coding: utf-8 -*-
(require 'wttr-utils)
(require 'cl)

(if wttr/os:windowsp
    (setq w32-enable-synthesized-fonts t))

(defconst wttr/font:ascii-font-candidates
  '("Cousine" "WenQuanYi Micro Hei Mono" "文泉驿等宽微米黑" "Consolas"))

(defconst wttr/font:non-ascii-font-candidates
  '("文泉驿等宽微米黑" "Microsoft YaHei" "MS Gothic"))

(defconst wttr/font:default-font-size 13)


(defun wttr/font:existp (font-name)
  "Check if the font with FONT-NAME exist in current system"
  (null (null (x-list-fonts font-name))))


(let ((ascii-font (find-if #'wttr/font:existp
                           wttr/font:ascii-font-candidates))
      (non-ascii-font (find-if #'wttr/font:existp
                               wttr/font:non-ascii-font-candidates))
      fontset)
  (when ascii-font
    (set-face-font 'default (font-spec :family ascii-font :size 11))
    (message "Select ascii font: %s" ascii-font))

  (when non-ascii-font
    (setq fontset (frame-parameter nil 'font))
    (dolist (script '(han kana))
      (set-fontset-font fontset script non-ascii-font nil 'prepend))
    (message "Select non-ascii font: %s" non-ascii-font)))

(cond (wttr/os:osxp
       (custom-set-faces
        '(default ((t ( :weight normal :height 120 :width normal))))))
      (wttr/os:linuxp
       (custom-set-faces
        '(default ((t ( :weight normal :height 110 :width normal))))))
      (wttr/os:win64p
       (custom-set-faces
        '(default ((t ( :weight normal :height 110 :width normal))))))
      )

(provide 'wttr-font)
