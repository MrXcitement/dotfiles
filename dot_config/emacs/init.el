;;; init.el --- My Emacs initialization file

;; Mike Barker <mike@thebarkers.com>
;; Created: November 23rd, 2025
;; Updated: February 13th, 2026

;;; Commentary:
;; The primary `init' file for emacs. This file specifies how to
;; initialize Emacs for you and how to customize its various optional
;; features.

;;; History
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:

;;; Check for valid emacs version
;; Emacs < 26 are too old, just error and exit.
(when (< emacs-major-version 26)
  (error "Your Emacs v%s is too old -- this config requires v26 or higher"
         emacs-version))

;; Emacs < 27 might not work, will need to manually load the early-init.el
(when (< emacs-major-version 27)
  (message "Your Emacs v%s is old -- this configuration may not work as expected since Emacs < 27."
           emacs-version)
  (load-file "early-init.el"))

;; Add the `lisp' dir in emacs init dir, to load path
(add-to-list 'load-path (concat user-emacs-directory "lisp/" ))

;;; Initialize emacs, before packages loaded.
(require 'init-backup-save)
(require 'init-customize)
(require 'init-dired)
(require 'init-environment)
(require 'init-eshell)
(require 'init-lock-buffers)
(require 'init-package)
(require 'init-recentf)
(require 'init-secure)
(require 'init-server)
(require 'init-spelling)
(require 'init-ui)
(require 'init-ui-darwin)
(require 'init-ui-linux)
(require 'init-ui-windows)

;;; Initialize packages
(require 'packages-auto-dark-mode)
(require 'packages-corfu)
(require 'packages-dashboard)
(require 'packages-evil)
(require 'packages-magit)
(require 'packages-markdown)
(require 'packages-minibuffer)
(require 'packages-nerd-icons)
(require 'packages-themes)
(require 'packages-yasnippet)

;;; Intialize emacs, after packages loaded.
(require 'init-keymaps)

;;; end of init.el
