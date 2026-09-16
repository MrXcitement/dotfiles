;;; package-powershell-ts-mode.el --- Install and configure the `powershell-ts-mode' package.

;; Mike Barker <mike@thebarkers.com>
;; Created: September 16th, 2026
;; Updated: September 16th, 2026

;;; Commentary:
;; Configure the powershell-ts-mode package.
;; https://github.com/dmille56/powershell-ts-mode

;;; History:

;;; Code:
(use-package powershell-ts-mode
  :straight (:host github :repo "dmille56/powershell-ts-mode")
  :config
  (setq powershell-ts-enable-imenu-top-level-vars nil))

(provide 'package-powershell-ts-mode)
