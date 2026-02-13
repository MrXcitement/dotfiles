;;; init-ui-darwin.el --- initialze the user interface on Darwin (macOS) systems

;; Mike Barker <mike@thebarkers.com>
;; Created: November 24th, 2025
;; Updated: December 5th, 2025

;;; Commentary:
;; Initialize the user interface on Darwin systems

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:

;; Only customize when on Darwin (macOS)
(when (eq system-type 'darwin)

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

  ;; When Emacs is in `daemon' mode, hook the after-make-frame
  (if (daemonp)
      (add-hook 'after-make-frame-functions
		(lambda (frame)
		  (with-selected-frame frame
		    (my-after-make-frame-darwin))))
    ;; Call my frame configuration function
    (my-after-make-frame-darwin)))

(provide 'init-ui-darwin)
;;; End of init-ui-darwin.el
