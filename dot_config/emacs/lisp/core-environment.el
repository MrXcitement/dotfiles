;;; core-environment.el --- Initialize the system environment

;; Mike Barker <mike@thebarkers.com>
;; Created: November 24th, 2025
;; Updated: August 8th, 2026

;;; Commentary:
;; Configure environment settings

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:
(use-package emacs
  :straight nil
  :init
  ;; Force the current directory to be the users home dir
  (setq default-directory "~/")

  :config
  ;; Darwin (mac os x) environment setup here...
  (when (eq system-type 'darwin)
    ;; Use the provided elisp version of ls
    (require 'ls-lisp)
    (setq ls-lisp-use-insert-directory-program nil))

  ;; Linux environment here...
  (when (eq system-type 'linux))

  ;; Windows environment here...
  (when (eq system-type 'windows-nt)))

(provide 'core-environment)
;;; core-environment.el ends here.
