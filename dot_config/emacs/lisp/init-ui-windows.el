;;; init-ui-windows.el --- initialze the user interface on Windows systems

;; Mike Barker <mike@thebarkers.com>
;; Created: November 24th, 2025
;; Updated: December 4th, 2025

;;; Commentary:
;; Initialize the user interface on Windows systems

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:

;; Frame configuration for `windows' systems.
(defun my-after-make-frame-windows(&optional frame)
  "Configure a new FRAME (default: selected frame) on `windows' system"

  ;; When the frame is GUI
  (when (display-graphic-p)

    ;; Font customization
    (when (member "FiraCode Nerd Font" (font-family-list))
      (set-face-font 'default "FiraCode Nerd Font 10"))))

;; Windows UI customization
(when (eq system-type 'windows-nt)

  ;; If Emacs is in `daemon' mode, hook the after-make-frame otherwise
  ;; just call my frame configuration function
  (if (daemonp)
      (add-hook 'after-make-frame-functions 'my-after-make-frame-windows)
    (my-after-make-frame-windows)))

(provide 'init-ui-windows)
;;; End of init-ui-windows
