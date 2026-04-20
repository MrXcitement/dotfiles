;;; packages-dashboard.el --- Install and configure the emacs dashboard package

;; Mike Barker <mike@thebarkers.com>
;; Created: November 23rd, 2025
;; Updated: February 14th, 2026

;;; Commentary:
;; Provide a 'dashboard' window at start that provides custom information

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:
(use-package dashboard
  :ensure t
  :config
  (setq dashboard-banner-logo-title (format "Welcome to Emacs %s!" emacs-version))
  (setq dashboard-startup-banner (expand-file-name "emacs.png" user-emacs-directory))
  (setq dashboard-items '((bookmarks . 5)
			  (recents   . 5)
			  (projects  . 5)))
  (dashboard-setup-startup-hook))

;; When running as a daemon, set the initial buffer to open the dashboard
(when (daemonp)
  (setq initial-buffer-choice 'dashboard-open))

(provide 'packages-dashboard)
;; end of packages-dashboard.el
