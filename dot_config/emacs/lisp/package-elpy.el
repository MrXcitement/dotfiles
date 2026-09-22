;;; package-elpy.el --- Install and configure the `elpy' package.  -*- no-byte-compile: t; lexical-binding: t; -*-

;; Mike Barker <mike@thebarkers.com>
;; Created: May 15, 2015
;; Updated: September 21st, 2026

;;; Commentary:
;; Provides a python programming toolset.

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:
(when (or (executable-find "python3")
	  (executable-find "python"))
  (use-package elpy
    :disabled
    :ensure t
    :defer t
    :init
    (advice-add 'python-mode :before 'elpy-enable)))

(provide 'package-elpy)
