;;; packages-eglot.el --- Install and configure eglot package

;; Mike Barker <mike@thebarkers.com>
;; Created: February 18th, 2026
;; Updated:


;;; Commentary:
;; Install and configure the eglot package

;;; Code:

(use-package eglot
  :ensure t
  :hook
  ((python-ts-mode . eglot-ensure)
   (python-ts-mode . flyspell-prog-mode)
   (python-ts-mode . hs-minor-mode)
   (python-ts-mode . (lambda () (set-fill-column 88)))))

(provide 'packages-eglot)

;;; packages-eglot.el ends here
