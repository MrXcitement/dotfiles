;;; package-exec-path-from-shell.el --- Install and configure the `exec-path-from-shell' package.

;; Mike Barker <mike@thebarkers.com>
;; Created: March 16th, 2023
;; Updated: August 9th, 2026

;;; Commentary:
;; On a Darwin (macOS) system, copy environment variables from the
;; user's shell by asking your shell to print out the variables of
;; interest, then copying them into the Emacs environment.
;; See: https://github.com/purcell/exec-path-from-shell

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:
(use-package exec-path-from-shell
  :if (eq system-type 'darwin)
  :ensure t
  :config
  ;; Only run exec-path-from-shell-initialize when PATH has not
  ;; allready been injected
  (unless (bound-and-true-p ns-emacs-plus-injected-path)
    (exec-path-from-shell-initialize)))

(provide 'package-exec-path-from-shell)
