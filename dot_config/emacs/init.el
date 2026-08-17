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

;;; Core Functionality

;; Only support Emacs v29+.
(when (< emacs-major-version 29)
  (error "Your Emacs v%s is too old -- this config requires Emacs v27 or higher"
         emacs-version))

;; when in batch mode
(when noninteractive
  (setq enable-dir-local-variables nil)
  (setq-default case-fold-search nil))

;; The initial buffer is created during startup even in non-interactive
;; sessions, and its major mode is fully initialized. Modes like `text-mode',
;; `org-mode', or even the default `lisp-interaction-mode' load extra packages
;; and run hooks, which can slow down startup.
;;
;; Using `fundamental-mode' for the initial buffer to avoid unnecessary
;; startup overhead.
(setq initial-major-mode 'fundamental-mode
      initial-scratch-message nil)

;; Ask the user whether to terminate asynchronous compilations on exit.
;; This prevents native compilation from leaving temporary files in /tmp.
(setq native-comp-async-query-on-exit t)

;; Allow for shorter responses: "y" for yes and "n" for no.
(setq read-answer-short t)
(if (boundp 'use-short-answers)
    (setq use-short-answers t)
  (advice-add 'yes-or-no-p :override #'y-or-n-p))
(setq revert-buffer-quick-short-answers t)

;; Handle the customize file
(setq custom-file (locate-user-emacs-file "custom.el"))
;; Press 'q' to quit a customize buffer, and it will be killed not just burried
(setq custom-buffer-done-kill t)
(load custom-file :no-error-if-file-is-missing)


;;; Package management

;; Install and configure straight.el package manager
;; https://github.com/radian-software/straight.el
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

;; Straight install use-package and configure straight to use-package by default
(straight-use-package 'use-package)

;; Configure use-package to use straight.el by default
(use-package straight
  :custom
  (straight-use-package-by-default t))

;;; Feature configuration

;; Require all `.el' files matching FILESPEC in DIRECTORY.
(defun my-require-features (filespec directory)
  "Require all `.el' files matching FILESPEC in DIRECTORY."
  (when (file-exists-p directory)
    (add-to-list 'load-path directory)
    (let ((pattern (wildcard-to-regexp filespec)))
      (dolist (file (directory-files directory nil pattern))
        (message "require file %s..." file)
        (require (intern (file-name-sans-extension file)) nil t)))))

;;; Require core features to configure emacs and built-in packages.
(message "Require core features...")
(my-require-features "core-*.el" (expand-file-name "lisp" user-emacs-directory))

;;; Require 3rd party packages.
(message "Require 3rd party packages...")
(my-require-features "package-*.el" (expand-file-name "lisp" user-emacs-directory))

;;; end of init.el
