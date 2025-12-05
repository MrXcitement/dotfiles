;; init-spelling.el -- initialize the spelling sub system.

;; Mike Barker <mike@thebarkers.com>
;; Created: November 24th, 2025
;; Updated: Decmeber 4th, 2025

;;; Commentary:
;; When the spelling program exists, initialize the spelling system.

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:

(when (executable-find "hunspell")
  (setq ispell-program-name "hunspell")

  (when (eq system-type 'darwin)
    (setenv "DICTIONARY" "en_US"))

  (when (eq system-type 'windows-nt)
    (setq ispell-local-dictionary "en_US")
    (setopt ispell-hunspell-dict-paths-alist '(("en_US" "c:/hunspell/en_US.aff"))))
)

(provide 'init-spelling)
;; init-spelling.el ends here.
