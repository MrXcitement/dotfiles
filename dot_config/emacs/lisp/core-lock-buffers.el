;;; core-lock-buffers.el --- Protect system buffers

;; Mike Barker <mike@thebarkers.com>
;; Created: November 24th, 2025
;; Updated: August 9th, 2026

;;; Commentary:
;; Lock the `*scratch*' and `*Messages*' buffers so they can not be killed.
;; https://scratch-buffer.org/2023/09/17/protecting-emacs-buffers.html

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:
(use-package emacs-lock
  :straight nil
  :config
  (with-current-buffer "*scratch*"
    (emacs-lock-mode 'kill))
  (with-current-buffer "*Messages*"
    (emacs-lock-mode 'kill)))

(provide 'core-lock-buffers)
;;; core-lock-buffers.el
