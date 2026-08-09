;;; package-evil.el --- Install and configure the `evil' and associated packages.

;; Mike Barker <mike@thebarkers.com>
;; Created: November 24th, 2025
;; Updated: August 9th, 2026

;;; Commentary:
;; Install and configure evil and associated packages.

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:

;;; evil
;; https://github.com/emacs-evil/evil
(use-package evil
  :ensure t
  :init
  (setq evil-want-keybinding nil)
  (setq evil-undo-system 'undo-redo)
  :config
  (setq evil-buffer-regexps
        '(("\*Customize" . nil)  ; Disable Evil for the any Customize,
	  ("\*eshell\*" . nil)   ; *eshell* and,
          ("SPEEDBAR" . nil)))   ; SPEEDBAR buffers.
  (defvar evil-mode-buffers '())
  (evil-mode 1))

;;; evil-collection
;; https://github.com/emacs-evil/evil-collection
(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

;;; evil-indent-plus
;; https://github.com/TheBB/evil-indent-plus
(use-package evil-indent-plus
  :after evil
  :ensure t)

;;; evil-leader
;; https://github.com/cofi/evil-leader
(use-package evil-leader
  :ensure t
  :config
  (global-evil-leader-mode t)
  (evil-leader/set-leader "<SPC>")
  (evil-leader/set-key
    "b" 'switch-to-buffer
    "e" 'find-file
    "k" 'kill-buffer
    "d x w" 'delete-trailing-whitespace
    "p f" 'project-find-file))

;;; evil-surround
;; https://github.com/emacs-evil/evil-surround
(use-package evil-surround
  :after evil
  :ensure t
  :config (global-evil-surround-mode))

(provide 'package-evil)
;; end of package-evil-mode.el
