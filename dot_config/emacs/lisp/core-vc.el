;;; core-vc.el --- Configure Emacs vc options

;; Mike Barker <mike@thebarkers.com>
;; Created: August 13th, 2026
;; Updated: August 13th, 2026

;;; Commentary:
;; Configure Emacs vc options
;; vc-git.el

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:

(setq vc-git-print-log-follow t)
(setq vc-git-diff-switches '("--histogram"))  ; Faster algorithm for diffing.

(provide 'core-vc)
;;; core-vc.el ends here.
