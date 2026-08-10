;;; init.el --- My Emacs initialization file

;; Mike Barker <mike@thebarkers.com>
;; Created: November 23rd, 2025
;; Updated: August 8th, 2026

;;; Commentary:
;; The primary `init' file for emacs. This file specifies how to
;; initialize Emacs for you and how to customize its various optional
;; features.

;;; History
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:
(message "Loading init...")

;;;
;;; Check for valid emacs version

;; Emacs < 29 are too old, just error and exit.
(when (< emacs-major-version 29)
  (error "Your Emacs v%s is too old -- this config requires v29 or higher"
         emacs-version))

;; Add the `lisp' dir in emacs init dir, to load path
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;; When debugging the init file, provide more use-package info
(when init-file-debug
  (setq use-package-verbose t
        use-package-expand-minimally nil
        use-package-compute-statistics t
        debug-on-error t))
;;;
;;; Install and configure package manager
;;; https://github.com/radian-software/straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Install use-package
(straight-use-package 'use-package)

;; Configure use-package to use straight.el by default
(use-package straight
  :custom
  (straight-use-package-by-default t))

;;; Configure core (built-in) packages and emacs settings
(message "Loading core...")
(require 'core-customize)
(require 'core-dired)
(require 'core-environment)
(require 'core-eshell)
(require 'core-files)
(require 'core-keymaps)
(require 'core-lock-buffers)
(require 'core-recentf)
(require 'core-secure)
(require 'core-server)
(require 'core-spelling)
(require 'core-ui)

;;; Initialize packages
(message "Loading packages...")
(require 'package-exec-path-from-shell)
(require 'package-auto-dark-mode)
(require 'package-corfu)
(require 'package-dashboard)
(require 'package-eglot)
(require 'package-evil)
(require 'package-git-gutter)
(require 'package-magit)
(require 'package-markdown)
(require 'package-minibuffer)
(require 'package-nerd-icons)
(require 'package-themes)
(require 'package-speedbar)
(require 'package-tree-sitter)
(require 'package-undo-tree)
(require 'package-yasnippet)

;; (require 'package-mise)

;;; end of init.el
