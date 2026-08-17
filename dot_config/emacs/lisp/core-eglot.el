;;; core-eglot.el --- Configure Emacs eglot options

;; Mike Barker <mike@thebarkers.com>
;; Created: August 13th, 2026
;; Updated: August 13th, 2026

;;; Commentary:
;; Configure Emacs eglot options
;; eglot.el, jsonrpc.el

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:

(setq eglot-report-progress my-debug)  ; Prevent minibuffer spam
(setq eglot-autoshutdown t)  ; Shut down after killing last managed buffer

;; A setting of nil or 0 means Eglot will not block the UI at all, allowing
;; Emacs to remain fully responsive, although LSP features will only become
;; available once the connection is established in the background.
(setq eglot-sync-connect 0)

;; Activate Eglot in cross-referenced non-project files
(setq eglot-extend-to-xref t)

;; Disable margin indicators to prevent line-height shifts caused by emoji font
;; rendering issues. This disables both `left-fringe' and `margin' indicators.
(setq eglot-code-action-indications '(eldoc-hint))

;; Eglot optimization
;;
(if my-debug
    (setq eglot-events-buffer-config '(:size 2000000 :format full))
  ;; This reduces log clutter to improves performance.
  (setq jsonrpc-event-hook nil)
  ;; Reduce memory usage and avoid cluttering *EGLOT events* buffer
  ;(setq eglot-events-buffer-size 0)  ; Deprecated
  (setq eglot-events-buffer-config '(:size 0 :format short)))


(provide 'core-eglot)
;;; core-eglot.el ends here.
