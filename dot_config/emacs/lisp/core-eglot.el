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

(use-package eglot
  :ensure nil ; Built-in to Emacs 29+
  :config
  ;; Optimization & Logging
  (if my-debug
      (setq eglot-events-buffer-config '(:size 2000000 :format full))
    (setq jsonrpc-event-hook nil)
    (setq eglot-events-buffer-config '(:size 0 :format short)))
  :custom
  (eglot-report-progress my-debug) ; Prevent minibuffer spam
  (eglot-autoshutdown t) ; Shut down after killing last managed buffer
  (eglot-sync-connect 0) ; Connect asynchronously in background
  (eglot-extend-to-xref t) ; Activate in cross-referenced non-project files
  (eglot-code-action-indications '(eldoc-hint)) ; Disable margin indicators
  :hook
  (ruby-mode . eglot-ensure))

(provide 'core-eglot)
;;; core-eglot.el ends here.
