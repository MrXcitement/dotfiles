;;; packages-minibuffer.el --- Configure minibuffer

;; Mike Barker <mike@thebarkers.com>
;; November 24th, 2025

;;; Commentary:
;; Configure the minibuffer

;;; History:
;; 2025.11.24
;; - Created.

;;; Code:

;; Use the vertico package to produce a vertical minibuffer layout.
(use-package vertico
  :ensure t
  :hook (after-init . vertico-mode))

;; Use the marginalia package to use the free space to show helpful
;; information about the options shown.
(use-package marginalia
  :ensure t
  :hook (after-init . marginalia-mode))

;; Use the orderless package to provide pattern matching when
;; searching for items.
(use-package orderless
  :ensure t
  :config
  (setq completion-styles '(orderless basic))
  (setq completion-category-defaults nil)
  (setq completion-category-overrides nil))

;; The built-in savehist package keeps a record of user inputs and
(use-package savehist
  :ensure nil ; it is built-in
  :hook (after-init . savehist-mode))

(provide 'packages-minibuffer)
;; packages-minibuffer.el
