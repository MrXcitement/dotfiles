;;; package-tree-sitter.el --- Load the tree sitter packages

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

(use-package treesit-auto
  :after tree-sitter
  :ensure t
  :custom
  (treesit-auto-install 'prompt)
  :config
  (global-treesit-auto-mode))

(provide 'package-tree-sitter)
;;; end of package-tree-siter
