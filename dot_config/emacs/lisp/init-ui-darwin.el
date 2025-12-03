;;; init-ui-darwin.el --- initialze the user interface on Darwin (macOS) systems

;; Mike Barker <mike@thebarkers.com>
;; Created: November 24th, 2025
;; Updated: December 3rd, 2025

;;; Commentary:
;; Initialize the user interface on Darwin systems

;;; Code:

;; Frame configuration for `darwin'
(defun my-after-make-frame-darwin(&optional frame)
  "Configure a new FRAME (default: selected frame) on `darwin' system"

  ;; When the frame is GUI
  (when (display-graphic-p)

    ;; set key to toggle fullscreen mode
    (global-set-key (kbd "s-<return>") 'toggle-frame-fullscreen)

    ;; set default font
    (when (member "FiraCode Nerd Font" (font-family-list))
      (set-frame-font "FiraCode Nerd Font" t t))

    ;; raise Emacs using AppleScript."
    (ns-do-applescript "tell application \"Emacs\" to activate")))

;; Change theme based on system appearence
(add-hook 'ns-system-appearance-change-functions #'my-apply-theme)

;; Emacs started in `daemon' mode.
(if (daemonp)
    (add-hook 'after-make-frame-functions 'my-after-make-frame-darwin)
  (my-after-make-frame-darwin))

(provide 'init-ui-darwin)
;;; End of init-ui-darwin.el
