;;; packages-git-gutter.el --- Install and configure the `git-gutter' package.

;; Mike Barker <mike@thebarkers.com>
;; Created: May 15, 2015
;; Updated: February 18th, 2026

;;; Commentary:
;; Provide git status in the gutter of the frame and provide key
;; bindings to operate on the changes.
;; https://github.com/emacsorphanage/git-gutter

;;; Code:
(use-package git-gutter
  :ensure t
  :config
  (progn
    (global-git-gutter-mode t))

  :bind
  (("C-c C-g" . git-gutter:toggle)
   ("C-c g =" . git-gutter:popup-hunk)
   ("C-c g p" . git-gutter:previous-hunk)
   ("C-c g r" . git-gutter:revert-hunk)
   ("C-c g n" . git-gutter:next-hunk)))

(provide 'packages-git-gutter)
