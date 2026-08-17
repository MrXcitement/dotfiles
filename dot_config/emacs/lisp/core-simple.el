;;; core-simple.el --- Configure emacs simple options

;; Mike Barker <mike@thebarkers.com>
;; Created: August 13th, 2026
;; Updated: August 13th, 2026

;;; Commentary:
;; Configure the simple.el package

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:

;;; simple.el

;; Disable ellipsis when printing s-expressions in the message buffer
(setq eval-expression-print-length nil
      eval-expression-print-level nil)

;; Preserve the system clipboard before Emacs delete/kill operations.
;;
;; By default, deleting text in Emacs overwrites your system clipboard. For
;; example, if you copy a link from a browser, switch to Emacs, and delete some
;; text, your copied link is lost. This setting fixes that by pushing the
;; clipboard contents into your paste history right before the deletion,
;; ensuring external data remains retrievable via `yank-pop'.
(setq save-interprogram-paste-before-kill t)

(provide 'core-simple)
;;; core-simple.el ends here.
