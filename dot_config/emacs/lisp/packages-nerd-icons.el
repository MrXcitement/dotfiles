;;; packages-nerd-icons.el --- Initialize nerd-icons packages

;; Mike Barker <mike@thebarkers.com>
;; November 23rd, 2025

;;; Commentary:
;; Nerd-icons.el is a library for easily using Nerd Font icons inside
;; Emacs, an alternative to all-the-icons.  It works on both GUI and
;; terminal! You only need a Nerd Font installed on your system.

;;; History:
;; 2025.11.23
;; - Created

;;; Code:

(use-package nerd-icons
  :ensure t)

(use-package nerd-icons-completion
  :ensure t
  :after marginalia
  :config
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

(use-package nerd-icons-corfu
  :ensure t
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package nerd-icons-dired
  :ensure t
  :hook
  (dired-mode . nerd-icons-dired-mode))


(provide 'packages-nerd-icons)
;;; init-nerd-icons.el ends here.
