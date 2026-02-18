;;; packages-undo-tree --- Initialize and configure the `undo-tree' package.

;; Mike Barker <mike@thebarkers.com>
;; Created: February 18th, 2026
;; Updated: February 18th, 2026

;;; Commentary:
;; Provides a visulization to the undo buffer
;; https://www.dr-qubit.org/undo-tree.html

;;; Code:
(use-package undo-tree
  :ensure t
  :init
  (global-undo-tree-mode))

(provide 'packages-undo-tree)
