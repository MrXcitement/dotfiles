;;; core-comint.el --- Configure Emacs comint options

;; Mike Barker <mike@thebarkers.com>
;; Created: August 13th, 2026
;; Updated: August 13th, 2026

;;; Commentary:
;; Configure Emacs comint options
;; ansi-color.el, comint.el

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:

(setq ansi-color-for-comint-mode t ; Renders native ANSI colors in the shell
      comint-prompt-read-only t
      comint-buffer-maximum-size 4096)

(provide 'core-comint)
;;; core-comint.el ends here.
