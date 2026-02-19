;;; packages-mise.el --- Install and configure the mise package
;; Mike Barker <mike@thebarkers.com>
;; Created: February 18th, 2026
;; Updated: February 18th, 2026

;;; Commentary:
;; Install and configure the mise package.
;; https://github.com/eki3z/mise.el

;;; Code:

(use-package mise
  :ensure t
  :hook
  (after-init-hook . global-mise-mode))

(provide 'packages-mise)

;;; packages-mise.el ends here
