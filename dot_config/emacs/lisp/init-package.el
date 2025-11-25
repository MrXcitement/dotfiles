;;; init-package.el --- Initialize the package manager and the installed packages

;; Mike Barker <mike@thebarkers.com>
;; November 24th, 2025

;;; Commentary:
;; Initialize and configure `package.el' package.
;; Initialize and configure the `use-package' package.

;;; History:
;; - Created.

;;; Code:

(require 'package)
(package-initialize)

;; Initialize the package-archives to be used.
(setq package-archives '(("melpa"        . "https://melpa.org/packages/")
                         ("gnu"          . "https://elpa.gnu.org/packages/")
                         ("nongnu"       . "https://elpa.nongnu.org/nongnu/")
                         ("melpa-stable" . "https://stable.melpa.org/packages/")))

(setq package-archive-priorities '(("gnu"    . 99)
                                   ("nongnu" . 80)
                                   ("melpa"  . 70)
                                   ("melpa-stable" . 50)))

;; Higlight the selected package
(add-hook 'package-menu-mode-hook (lambda() (hl-line-mode 1)))

;; Install and configure the `use-package' package.
(when (< emacs-major-version 29)
  (unless (package-installed-p 'use-package)
    (unless package-archive-contents
      (package-refresh-contents))
    (package-install 'use-package)))

;; Do not show the buffer that contains any warnings produced by the byte compiler
(add-to-list 'display-buffer-alist
             '("\\`\\*\\(Warnings\\|Compile-Log\\)\\*\\'"
               (display-buffer-no-window)
               (allow-no-window . t)))

(provide 'init-package)
;;; init-packages.el ends here.
