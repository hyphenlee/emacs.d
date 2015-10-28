
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


;; (setq default-frame-alist
;;       (cons '(font . "fontset-Consolas") default-frame-alist))

;; Very useful tools when you want to know the font description under win32
;(w32-select-font nil nil)

;; test example:
;; Chinese : 测试
;; Katakana: わたし
;; Hirakana: ワタシ

;; background knowledge:
;; =================================================
;; http://stackoverflow.com/questions/7176276/what-is-script-name-symbol-means-for-emacs-set-fontset-font-function/7178821#7178821
;; 
;; what is "script name symbol" means for emacs set-fontset-font function?
;; (char-table-extra-slot char-script-table 0)
;; (list-character-sets)
;;
;; charset-script-alist
;; script-representative-chars
;; char-script-table
;; =================================================

;; former used II
;(create-fontset-from-fontset-spec
; "-outline-Cousine-normal-normal-normal-*-*-*-*-*-*-*-fontset-Cousine")
;(set-fontset-font "fontset-Cousine" 'ascii "Cousine")
;(set-fontset-font "fontset-Cousine" 'han "Microsoft YaHei")
;(set-frame-font "fontset-Cousine" nil t)


;;; former used, leave here for reference
;; Font
;(create-fontset-from-fontset-spec
; (concat
;  "-outline-Bitstream Vera Sans Mono-bold-normal-normal-mono-14-*-*-*-c-*-fontset-BVSM,"
;  "chinese-gb2312:-outline-YaHei Consolas Hybrid-normal-normal-normal-mono-*-*-*-*-c-*-gb2312.1980-0,"
;  "sjis:-outline-MS Gothic-normal-normal-normal-mono-13-*-*-*-c-*-jisx0208-sjis" ) )
;;(create-fontset-from-fontset-spec
; (concat
;  "-outline-Consolas-normal-normal-normal-mono-18-*-*-*-c-*-fontset-Consolas,"
;  "ascii:-outline-Consolas-normal-r-normal-normal-18-*-*-*-c-*-iso8859-1,"
;  "chinese-gb2312:-outline-YaHei Consolas Hybrid-normal-normal-normal-sans-*-*-*-*-p-*-gb2312*-0,"
;  "chinese-gbk:-outline-YaHei Consolas Hybrid-normal-normal-normal-sans-*-*-*-*-p-*-gb2312*-0,"
;  "sjis:-outline-MS Gothic-normal-normal-normal-mono-13-*-*-*-c-*-jisx0208-sjis" ) )
;(set-default-font "fontset-Consolas")
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
