;;; package-powershell.el --- Install and configure the `powershell' package.

;; Mike Barker <mike@thebarkers.com>

;;; Commentary:
;; Provide an powershell shell buffer when on windows.

;;; History:

;;; Code:
(when (eq system-type 'windows-nt)
  (use-package powershell
    :disabled
    :ensure t
    :config
    (require 'powershell nil t)))

(provide 'package-powershell)
