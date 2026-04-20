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
(require 'core-backup-save)
(require 'core-customize)
(require 'core-dired)
(require 'core-environment)
(require 'core-eshell)
(require 'core-lock-buffers)
(require 'core-package)
(require 'core-recentf)
(require 'core-secure)
(require 'core-server)
(require 'core-spelling)
(require 'core-ui)

;;; Initialize packages
(require 'package-auto-dark-mode)
(require 'package-corfu)
(require 'package-dashboard)
(require 'package-eglot)
(require 'package-evil)
(require 'package-git-gutter)
(require 'package-magit)
(require 'package-markdown)
(require 'package-mise)
(require 'package-minibuffer)
(require 'package-nerd-icons)
(require 'package-themes)
(require 'package-tree-sitter)
(require 'package-undo-tree)
(require 'package-yasnippet)

;;; Intialize emacs, after packages loaded.
(require 'core-keymaps)

;;; end of init.el
