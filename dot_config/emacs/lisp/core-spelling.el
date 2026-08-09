;; core-spelling.el -- initialize the spelling sub system.

;; Mike Barker <mike@thebarkers.com>
;; Created: November 24th, 2025
;; Updated: August 8th, 2026

;;; Commentary:
;; When the spelling program exists, initialize the spelling system.

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:
;;; Configure spelling
(use-package ispell
  :straight nil
  :if (executable-find "hunspell")

  :init
  (setq ispell-program-name "hunspell")
  (setq ispell-local-dictionary "en_US")

  :config
  (when (eq system-type 'darwin))
  (when (eq system-type 'gnu/linux))
  (when (eq system-type 'windows-nt)
    (setenv "LANG" "en_US")
    (setopt ispell-hunspell-dict-paths-alist '(("en_US" "c:/hunspell/en_US.aff")))))

(provide 'core-spelling)
;; core-spelling.el ends here.
