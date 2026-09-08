;;; package-eshell-starship.el --- Configure the package `eshell-starship'

;; Mike Barker <mike@thebarkers.com>
;; Created: September 8th, 2026
;; Updated: September 8th, 2026

;;; Commentary:
;; Configure the package `eshell-starship'
;; https://github.com/siddharthverma314/eshell-starship
;; I have forked the repository and am using my fork.

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:

(use-package eshell-starship
  :straight (eshell-starship :type git :host github :repo "mrxcitement/eshell-starship")
  :config
  (eshell-starship-setup))

(provide 'package-eshell-starship)
;;; package-eshell-starship.el ends here.
