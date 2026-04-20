;; packages-auto-dark-mode.el --- Install and configure themes

;; Author: Mike Barker <mike@thebarkers.com>
;; Created: February 13th, 2026
;; Updated: February 13th, 2026

;;; Commentary:
;; Install and configure the auto-dark-mode package.
;; https://github.com/LionyxML/auto-dark-emacs

;;; Code:

;; This function is used for when emacs is being started in daemon
;; mode to enable aut-dark-mode.  It is added as a hook to the
;; variable: after-make-frame-functions and when run, it turns
;; auto-dark-mode on and then removes itself from the
;; after-make-frame-functions so that it only runs once.
(defun my-auto-dark-make-frame (frame)
  (message "my-auto-dark-make-frame: Triggered for frame %s" frame)
  (with-selected-frame frame
    (if (display-graphic-p)
        (progn
          (message "my-auto-dark-make-frame: Graphic display detected. Enabling auto-dark-mode.")
          (auto-dark-mode 1)
          (message "my-auto-dark-make-frame: Removing hook.")
          (remove-hook 'after-make-frame-functions #'my-auto-dark-make-frame))
      (message "my-auto-dark-make-frame: Non-graphic display, skipping..."))))

(use-package auto-dark
  :ensure t
  :custom
  (auto-dark-themes `((,my-theme-dark) (,my-theme-light)))
  :init
  (if (daemonp)
      (add-hook 'after-make-frame-functions #'my-auto-dark-make-frame)
    (auto-dark-mode 1)))

(provide 'packages-auto-dark-mode)
