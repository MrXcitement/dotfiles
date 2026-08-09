;;; core-customize.el --- Configure the customize file

;; Mike Barker <mike@thebarkers.com>
;; Created: November 23rd, 2025
;; Updated: August 9th, 2026

;;; Commentary:
;; Store the customize settings in a 'custom.el' file in the users emacs directory

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:
(use-package emacs
  :straight nil
  :init
  (setq custom-file (locate-user-emacs-file "custom.el"))
  ;; Press 'q' to quit a customize buffer, and it will be killed not just burried
  (setq custom-buffer-done-kill t)
  :config
  (load custom-file :no-error-if-file-is-missing))

(provide 'core-customize)
;;; core-customize.el ends here.
