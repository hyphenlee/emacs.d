;;; the following is only needed if you install org-page manually
(require 'org-page)
(setq op/repository-directory "https://github.com/hyphenlee/hyphenlee.github.io.git")
(setq op/repository-directory "C:/blog")
(setq op/site-domain "https://hyphenlee.github.io")
;;; for commenting, you can choose either disqus or duoshuo
(setq op/personal-disqus-shortname "hyphensblog")
;; (setq op/personal-duoshuo-shortname "your_duoshuo_shortname")
;;; the configuration below are optional
(setq op/personal-google-analytics-id "UA-59619368-1")
(setq op/site-main-title "Let it be")
(setq op/site-sub-title "Don't leave this world without anything left.")
(setq op/personal-github-link "https://github.com/hyphenlee")
;; (setq op/personal-avatar "/media/img/profile.jpg")
(defun lhf/public-blog ()
  (interactive)
  (let ()
    (cd op/repository-directory)
    (save-some-buffers t nil)
    (shell-command "git commit -am \"post\"")
    (op/do-publication t nil nil)
    (shell-command "git commit -am \"post\"")
    (shell-command "git push")
    (op/git-change-branch op/repository-directory op/repository-org-branch)))




