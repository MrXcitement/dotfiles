;;; core-mouse.el --- Configure Emacs mouse options

;; Mike Barker <mike@thebarkers.com>
;; Created: August 13th, 2026
;; Updated: August 13th, 2026

;;; Commentary:
;; Configure Emacs mouse options
;; mouse.el

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:

;; Force the mouse to paste text at the active cursor position.
(setq mouse-yank-at-point t)

;; Context Menu
(when (memq 'context-menu my-ui-features)
  (when (and (display-graphic-p) (fboundp 'context-menu-mode))
    (add-hook 'after-init-hook #'context-menu-mode)))

(provide 'core-mouse)
;;; core-mouse.el ends here.
