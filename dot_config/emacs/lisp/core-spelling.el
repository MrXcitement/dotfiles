;; core-spelling.el -- initialize the spelling sub system.

;; Mike Barker <mike@thebarkers.com>
;; Created: November 24th, 2025
;; Updated: August 20th, 2026

;;; Commentary:
;; If `aspell' is installed, use it, otherwise when `hunspell' is installed configure it.

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:
;;; Configure spelling
(if (executable-find "aspell")
    (progn
      ;;(setq ispell-dictionary "your_default_dictionary")
      (setq ispell-program-name "aspell")
      (setq ispell-silently-savep t))
  (when (executable-find "hunspell")
    (setq ispell-program-name "hunspell")
    (setq ispell-local-dictionary "en_US")
    (when (eq system-type 'darwin))
    (when (eq system-type 'gnu/linux))
    (when (eq system-type 'windows-nt)
      (setenv "LANG" "en_US")
      (setopt ispell-hunspell-dict-paths-alist '(("en_US" "c:/hunspell/en_US.aff"))))))

(provide 'core-spelling)
;; core-spelling.el ends here.
