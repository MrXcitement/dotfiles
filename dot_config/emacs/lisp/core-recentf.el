;;; core-recentf.el --- Initialize the recentf package -*- lexical-binding: t -*-

;; Mike Barker <mike@thebarkers.com>
;; Created: January 1st, 2025
;; Updated: August 9th, 2026

;;; Commentary:
;; Configure recentf recent files built-in package

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:
(use-package recentf
  :straight nil
  :bind
  ;; Replace `find-file-read-only' keybinding with recentf.
  ("C-x C-r" . recentf-open)

  :init
  ;; 50 files ought to be enough.
  (setq recentf-max-saved-items 50)

  :config
  ;; enable recent files mode.
  (recentf-mode t))

(provide 'core-recentf)
;;; core-recentf.el ends here
