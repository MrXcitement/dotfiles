;;; core-diff.el --- Configure Emacs diff options

;; Mike Barker <mike@thebarkers.com>
;; Created: August 13th, 2026
;; Updated: August 13th, 2026

;;; Commentary:
;; Configure Emacs diff options
;; diff-mode.el, ediff.wind.el

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:

;; Diff

;; Move +/- indicators to the fringe for cleaner diffs
(setq diff-font-lock-prettify t)

;; Ediff

;; Configure Ediff to use a single frame and split windows horizontally
(setq ediff-window-setup-function 'ediff-setup-windows-plain
      ediff-split-window-function 'split-window-horizontally)

(provide 'core-diff)
;;; core-diff.el ends here.
