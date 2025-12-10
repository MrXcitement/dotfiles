;;; packages-evil.el --- Install and configure the `evil' and associated packages.

;; Mike Barker <mike@thebarkers.com>
;; Created: November 24th, 2025
;; Updated: December 4th, 2025

;;; Commentary:
;; Install and configure evil and associated packages.

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:
(use-package evil
  :ensure t
  :init
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1))

(use-package evil-collection
   :after evil
   :ensure t
   :config
   (evil-collection-init))

;; (use-package evil-indent-textobject
;;   :after evil
;;   :ensure t)

;; (use-package evil-leader
;;   :ensure t
;;   :config
;;   (global-evil-leader-mode t)
;;   (evil-leader/set-leader "<SPC>")
;;   (evil-leader/set-key
;;     "s s" 'swiper
;;     "d x w" 'delete-trailing-whitespace
;;     "e" 'counsel-find-file
;;     "b" 'switch-to-buffer
;;     "k" 'kill-buffer))

(use-package evil-surround
  :after evil
  :ensure t
  :config (global-evil-surround-mode))

(use-package powerline-evil
  :after evil
  :ensure t
  :config
  (powerline-evil-vim-color-theme)))

(provide 'packages-evil)
;; end of packages-evil-mode.el
