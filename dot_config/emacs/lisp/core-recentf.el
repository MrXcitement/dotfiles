;;; core-recentf.el --- Initialize the recentf package -*- lexical-binding: t -*-

;; Mike Barker <mike@thebarkers.com>
;; Created: January 1st, 2025
;; Updated: August 9th, 2026

;;; Commentary:
;; Configure recentf recent files built-in package
;; recentf.el

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:

(require 'recentf)

;; Replace `find-file-read-only' keybinding with recentf.
(global-set-key (kbd "C-x C-r") 'recentf-open)

;; enable recent files mode.
(recentf-mode t)

;; `recentf' maintains a list of recently accessed files.
(setq recentf-max-saved-items 300) ; default is 20
(setq recentf-max-menu-items 15)

(provide 'core-recentf)
;;; core-recentf.el ends here
