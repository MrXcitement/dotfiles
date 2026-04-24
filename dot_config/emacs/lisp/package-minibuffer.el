;;; package-minibuffer.el --- Configure minibuffer

;; Mike Barker <mike@thebarkers.com>
;; Created: November 24th, 2025
;; Updated: December 4th, 2025

;;; Commentary:
;; Configure the minibuffer

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:

;; Use the vertico package to produce a vertical minibuffer layout.
;; https://github.com/minad/vertico
(use-package vertico
  :ensure t
  :hook (after-init . vertico-mode))

;; Use the marginalia package to use the free space to show helpful
;; information about the options shown.
;; https://github.com/minad/marginalia
(use-package marginalia
  :ensure t
  :hook (after-init . marginalia-mode))

;; Use the orderless package to provide pattern matching when
;; searching for items.
;; https://github.com/oantolin/orderless
(use-package orderless
  :ensure t
  :config
  (setq completion-styles '(orderless basic))
  (setq completion-category-defaults nil)
  (setq completion-category-overrides nil))

;; Simple but effective sorting and filtering for Emacs.
;; https://github.com/radian-software/prescient.el
(use-package prescient
  :ensure t
  :init
  (vertico-prescient-mode))

;; Emacs Mini-Buffer Actions Rooted in Keymaps
;; https://github.com/oantolin/embark
(use-package embark
  :ensure t
  :bind
  (("C-." . embark-act)
   ("M-." . embark-dwim)
   ("C-h B" . embark-bindings))

  :init
  (setq prefix-help-command #'embark-prefix-help-command))

;; Search and navigate via completing-read
;; https://github.com/minad/consult
(use-package consult
  :ensure t
  :bind (("C-s" . consult-line)
         ("C-x b" . consult-buffer)))

;; The built-in savehist package keeps a record of user inputs and
(use-package savehist
  :ensure nil ; it is built-in
  :hook (after-init . savehist-mode))

;; Which-key: Discover keybindings
(use-package which-key
  :ensure t
  :init (which-key-mode)
  :config
  (setq which-key-idle-delay 0.3))

(provide 'package-minibuffer)
;;; package-minibuffer.el ends here
