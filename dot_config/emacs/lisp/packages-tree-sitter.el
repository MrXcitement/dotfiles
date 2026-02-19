;;; packages-tree-sitter.el --- Load the tree sitter packages

;; Mike Barker <mike@thebarkers.com>
;; Created: December 18th, 2025
;; Updated:

;;; Commentary:
;; Load the tree-sitter and tree-sitter-lang packages
;; https://emacs-tree-sitter.github.io/

;;; Code

(use-package tree-sitter
  :ensure t
  :config
  (add-to-list 'major-mode-remap-alist
	       '(python-mode . python-ts-mode)))

(use-package tree-sitter-langs
  :after tree-sitter
  :ensure t
  :custom (global-tree-sitter-mode t))

(provide 'packages-tree-sitter)
;;; end of packages-tree-siter
