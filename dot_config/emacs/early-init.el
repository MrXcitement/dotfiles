;;; early-init.el --- Early initialization

;; Mike Barker <mike@thebarkers.com>
;; Created: November 23rd, 2025
;; Updated: December 4th, 2025


;;; Commentary:
;; I have added this file in an attempt to speed up Emacs' startup time.
;; Tweak garbage collector settings to decrease startup time, saved .5 seconds.
;; https://www.gnu.org/software/emacs/manual/html_node/elisp/Init-File.html#index-early-init-file
;; https://www.gnu.org/software/emacs/manual/html_node/elisp/Startup-Summary.html

;;; History:
;; See my dotfiles and emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:

;;; Disable grabage collection, re-enable in the emacs-startup-hook

;; Backup GC variables
(defvar my-backup-gc-cons-threshold gc-cons-threshold)
(defvar my-backup-gc-cons-percentage gc-cons-percentage)

;; Increase GC threshold during startup to 50MB
(setq gc-cons-threshold most-positive-fixnum)
(setq gc-cons-percentage 1.0)

;;; Language

;; UTF-8
(set-language-environment "UTF-8")

;; Set-language-environment sets default-input-method, which is unwanted.
(setq default-input-method nil)

;;; UI

;; Remove "For information about GNU Emacs..." message at startup
(advice-add 'display-startup-echo-area-message :override #'ignore)

;; Suppress the vanilla startup screen completely. We've disabled it with
;; `inhibit-startup-screen', but it would still initialize anyway.
(advice-add 'display-startup-screen :override #'ignore)

;; The initial buffer is created during startup even in non-interactive
;; sessions, and its major mode is fully initialized. Modes like `text-mode',
;; `org-mode', or even the default `lisp-interaction-mode' load extra packages
;; and run hooks, which can slow down startup.
;;
;; Using `fundamental-mode' for the initial buffer to avoid unnecessary
;; startup overhead.
(setq initial-major-mode 'fundamental-mode
    initial-scratch-message nil)

;; Turn off ui elements
(tool-bar-mode -1)
(setq inhibit-splash-screen t)

;; Disable GUI dialogs because they are inconsistent across systems, desktop
;; environments, and themes, and they don't match the look of Emacs.
(setq use-file-dialog nil)
(setq use-dialog-box nil)

;;; Security
(setq gnutls-verify-error t)  ; Prompts user if there are certificate issues
(setq tls-checktrust t)  ; Ensure SSL/TLS connections undergo trust verification
(setq gnutls-min-prime-bits 3072)  ; Stronger GnuTLS encryption

;; After emacs has started...
;; Tell us how long it took to start and how many times the GC ran
;; Reset the GC threshold to 8KB
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold my-backup-gc-cons-threshold)
            (setq gc-cons-percentage my-backup-gc-cons-percentage)
            (message "Emacs ready in %.2f seconds with %d garbage collections."
                     (float-time (time-subtract after-init-time before-init-time))
                     gcs-done)
            ))

(provide 'early-init)
;;; End of early-init.el
