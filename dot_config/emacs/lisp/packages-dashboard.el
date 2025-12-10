;;; packages-dashboard.el --- Install and configure the emacs dashboard package

;; Mike Barker <mike@thebarkers.com>
;; Created: November 23rd, 2025
;; Updated: December 4th, 2025

;;; Commentary:
;; Provide a 'dashboard' window at start that provides custom information

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:
(use-package dashboard
 :ensure t
 :config
 (setq dashboard-items '((bookmarks . 5)
                         (recents   . 5)
			 (projects  . 5)))
 (setq initial-buffer-choice (lambda () (get-buffer-create dashboard-buffer-name)))
 (dashboard-setup-startup-hook))

(provide 'packages-dashboard)
;; end of packages-dashboard.el
