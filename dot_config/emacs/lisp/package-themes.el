;; packages-themes.el --- Install and configure themes

;; Author: Mike Barker <mike@thebarkers.com>
;; Created: November  5, 2015
;; Updated: February 13th, 2026

;;; Commentary:
;; Install theme packages

;;; Code:
(use-package leuven-theme
  :if window-system
  :ensure t)

(use-package vs-dark-theme
  :if window-system
  :ensure t)

(use-package vs-light-theme
  :if window-system
  :ensure t)

(use-package deeper-blue-theme
  :disabled
  :if (not window-system)
  :init
  (load-theme 'deeper-blue))

(provide 'packages-themes)
