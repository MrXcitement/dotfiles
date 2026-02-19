;;; init.el --- My Emacs initialization file

;; Mike Barker <mike@thebarkers.com>
;; Created: November 23rd, 2025
;; Updated: February 18th, 2026

;;; Commentary:
;; The primary `init' file for emacs. This file specifies how to
;; initialize Emacs for you and how to customize its various optional
;; features.

;;; History
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:

;;; Check for valid emacs version
;; Emacs < 29 are too old, just error and exit.
(when (< emacs-major-version 29)
  (error "Your Emacs v%s is too old -- this config requires v29 or higher"
         emacs-version))

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
(require 'packages-eglot)
(require 'packages-evil)
(require 'packages-git-gutter)
(require 'packages-magit)
(require 'packages-markdown)
(require 'packages-mise)
(require 'packages-minibuffer)
(require 'packages-nerd-icons)
(require 'packages-themes)
(require 'packages-undo-tree)
(require 'packages-yasnippet)

;;; Intialize emacs, after packages loaded.
(require 'init-keymaps)

;;; end of init.el
