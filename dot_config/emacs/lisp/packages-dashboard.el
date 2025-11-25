;;; packages-dashboard.el --- Install and configure the emacs dashboard package

;; Mike Barker <mike@thebarkers.com>
;; November 23rd, 2025

;;; Commentary:
;; Provide a 'dasboard' window at start that provides custom information

;;; History:
;; 2025.11.23
;; - Created.

;;; Code:
(use-package dashboard
 :ensure t
 :bind (:map dashboard-mode-map
        ("g" . 'dashboard-refresh-buffer))
 :config
 (setq dashboard-items '((bookmarks . 5)
                         (recents   . 5)
			 (projects  . 5)))
 (dashboard-setup-startup-hook))

(provide 'packages-dashboard)
;; end of packages-dashboard.el
