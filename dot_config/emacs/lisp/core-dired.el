;;; core-dired.el --- Initialize the `dired' mode

;; Mike Barker <mike@thebarkers.com>
;; Created: November 24th, 2025
;; Updated: August 9th, 2026

;;; Commentary:
;; Any user customizations to the `dired' mode should go here.

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:
(use-package dired
  :straight nil
  :config
  ;; Highlight the current line when in dired mode.
  (add-hook 'dired-mode-hook 'hl-line-mode))

(provide 'core-dired)
;;; End of core-dired.el
