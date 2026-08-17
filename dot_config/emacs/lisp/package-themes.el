;; package-themes.el --- Install and configure themes

;; Author: Mike Barker <mike@thebarkers.com>
;; Created: November  5, 2015
;; Updated: February 13th, 2026

;;; Commentary:
;; Install theme packages

;;; Code:
(use-package leuven-theme
  :if window-system
  :ensure t)

(use-package modus-themes
  :ensure t)

(use-package vs-dark-theme
  :if window-system
  :ensure t)

(use-package vs-light-theme
  :if window-system
  :ensure t)

(use-package deeper-blue-theme
  :disabled
  :if (not window-system)
  :init
  (load-theme 'deeper-blue))

(use-package auto-dark
  :ensure t

  :config
  (setq auto-dark-themes `((,my-theme-dark) (,my-theme-light)))

  ;; This function is used for when emacs is being started in daemon
  ;; mode to enable aut-dark-mode.  It is added as a hook to the
  ;; variable: after-make-frame-functions and when run, it turns
  ;; auto-dark-mode on and then removes itself from the
  ;; after-make-frame-functions so that it only runs once.
  (defun my-auto-dark-make-frame (frame)
    (message "my-auto-dark-make-frame(%s)" frame)
    (with-selected-frame frame
      (if (display-graphic-p)
	  (progn
	    (message "my-auto-dark-make-frame: Graphic display detected. Enabling auto-dark-mode.")
	    (auto-dark-mode 1)
	    (message "my-auto-dark-make-frame: Removing hook.")
	    (remove-hook 'after-make-frame-functions #'my-auto-dark-make-frame))
	(message "my-auto-dark-make-frame: Non-graphic display, skipping..."))))

  (if (daemonp)
      (add-hook 'after-make-frame-functions #'my-auto-dark-make-frame)
    (auto-dark-mode 1)))

(provide 'package-themes)
