;;; core-python.el --- Configure Emacs python options

;; Mike Barker <mike@thebarkers.com>
;; Created: August 13th, 2026
;; Updated: August 13th, 2026

;;; Commentary:
;; Configure Emacs python options
;; python.el

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:

;; Do not notify the user each time Python tries to guess the indentation offset
(setq python-indent-guess-indent-offset-verbose nil)

(use-package eglot
  :ensure t
  :hook
  ((python-ts-mode . eglot-ensure)
   (python-ts-mode . flyspell-prog-mode)
   (python-ts-mode . hs-minor-mode)
   (python-ts-mode . (lambda () (set-fill-column 88)))))

(provide 'core-python)
;;; core-python.el ends here.
