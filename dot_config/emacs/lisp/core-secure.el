;;; core-secure.el --- Configure security settings -*- lexical-binding: t -*-

;; Mike Barker <mike@thebarkers.com>
;; Created: January 29th, 2026
;; Updated: August 8th, 2026

;;; Commentary:
;; Setup any security related settings here.
;; for example: auth-source, EasyPG assistand (epa), etc.

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:
(use-package epg
  :straight nil
  :init
  (setq epa-pinentry-mode 'loopback))

(provide 'core-secure)
;;; core-secure.el ends here
