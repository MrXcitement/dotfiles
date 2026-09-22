;;; package-undo-tree --- Initialize and configure the `undo-tree' package. -*- no-byte-compile: t; lexical-binding: t; -*-

;; Mike Barker <mike@thebarkers.com>
;; Created: February 18th, 2026
;; Updated: September 21st, 2026

;;; Commentary:
;; Provides a visulization to the undo buffer
;; https://www.dr-qubit.org/undo-tree.html

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:
(use-package undo-tree
  :ensure t
  :config
  (setq undo-tree-auto-save-history nil)
  :init
  (global-undo-tree-mode))

(provide 'package-undo-tree)
