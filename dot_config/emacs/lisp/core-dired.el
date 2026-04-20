;;; init-dired.el --- Initialize the `dired' mode

;; Mike Barker <mike@thebarkers.com>
;; Created: November 24th, 2025
;; Updated: December 4th, 2025

;;; Commentary:
;; Any user customizations to the `dired' mode should go here.

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:

;; Highlight the current line when in dired mode.
(add-hook 'dired-mode-hook
	  (lambda() (hl-line-mode 1)))


(provide 'init-dired)
;;; End of init-dired.el
