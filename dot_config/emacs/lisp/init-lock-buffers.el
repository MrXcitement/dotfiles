;;; init-lock-buffers.el --- Protect system buffers

;; Mike Barker <mike@thebarkers.com>
;; Created: November 24th, 2025
;; Updated: Decmeber 4th, 2025

;;; Commentary:
;; Lock the `*scratch*' and `*Messages*' buffers so they can not be killed.

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:

(save-excursion
  (set-buffer "*scratch*")
  (emacs-lock-mode 'kill)
  (set-buffer "*Messages*")
  (emacs-lock-mode 'kill))

(provide 'init-lock-buffers)
;;; init-lock-buffers.el
