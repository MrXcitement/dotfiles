;;; packages-cc-mode.el --- Configure cc-mode settings

;; Mike Barker <mike@thebarkers.com>
;; November 23rd, 2025

;;; Commentary:
;; Configure the c major mode

;;; History:
;; 2025.11.23
;; - Created.

;;; Code:
(use-package cc-mode
  :config
  (add-hook 'c-mode-hook
	    (lambda()
	      ;; Use 'extra-line at top/bottom in c-mode only
	      (setq-local comment-style 'extra-line)))
  :custom
  (c-basic-offset 4))

(provide 'packages-cc-mode)
