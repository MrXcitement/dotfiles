;;; init.el --- My Emacs initialization file

;; Mike Barker <mike@thebarkers.com>
;; October 10, 2007

;;; Commentary:

;;; History

;;; Code:

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

;;; Initialize emacs, no packages, yet!
(require 'init-customize)
(require 'init-dired)
(require 'init-environment)
(require 'init-eshell)
(require 'init-keymaps)
(require 'init-lock-buffers)
(require 'init-package)
(require 'init-backup-save)
(require 'init-server)
(require 'init-spelling)
(require 'init-ui)

;;; Initialize packages
(require 'packages-dashboard)
(require 'packages-evil)
(require 'packages-corfu)
(require 'packages-nerd-icons)
(require 'packages-minibuffer)

(provide 'init)
;;; end of init.el
