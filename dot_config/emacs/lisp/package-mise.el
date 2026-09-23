;;; package-mise.el --- Install and configure the mise package
;; Mike Barker <mike@thebarkers.com>
;; Created: February 18th, 2026
;; Updated: September 23rd, 2026

;;; Commentary:
;; Install and configure the mise package.
;; https://github.com/eki3z/mise.el

;;; Code:

(when (executable-find "mise")
  (use-package mise
    :ensure t
    :hook
    (prog-mode . mise-mode)
    (eshell-mode . mise-mode)))

(provide 'package-mise)

;;; package-mise.el ends here
