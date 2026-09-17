;;; core-diff.el --- Configure Emacs diff options

;; Mike Barker <mike@thebarkers.com>
;; Created: August 13th, 2026
;; Updated: September 17th, 2026

;;; Commentary:
;; Configure Emacs diff options
;; diff-mode.el, ediff.wind.el

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:

(use-package diff
  :ensure nil
  :custom
  ;; Move +/- indicators to the fringe for cleaner diffs
  (diff-font-lock-prettify t))

(use-package ediff
  :ensure nil
  :custom
  ;; Configure Ediff to use a single frame and split windows horizontally
  (ediff-window-setup-function 'ediff-setup-windows-plain)
  (ediff-split-window-function 'split-window-horizontally))

(provide 'core-diff)
;;; core-diff.el ends here.
