;;; package-treesit-auto.el --- Module package-treesit-auto.

;; Mike Barker <mike@thebarkers.com>
;; Created: September 15th, 2026
;; Updated:

;;; Commentary:
;; Configure package-treesit-auto.

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:

(use-package treesit-auto
  :ensure t
  :custom
  (treesit-auto-install 'prompt)
  :config
  (global-treesit-auto-mode))

(provide 'package-treesit-auto)
;;; package-treesit-auto.el ends here.
