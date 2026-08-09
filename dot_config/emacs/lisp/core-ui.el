;;; core-ui.el --- Initialize the user interface

;; Mike Barker <mike@thebarkers.com>
;; Created: November 24th, 2025
;; Updated: August 8th, 2026

;;; Commentary:
;; Initialize the user interface handling text and gui modes.

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:
;; Configure UI
(use-package emacs
  :straight nil
  :config
  (blink-cursor-mode -1)
  (column-number-mode t)
  (show-paren-mode t)

  ;; Higlight current line in package menu
  (add-hook 'package-menu-mode-hook (lambda() (hl-line-mode 1)))

  ;; Line number type to relative, and display in text and program derived modes
  (setopt display-line-numbers-type 'relative)
  (add-hook 'text-mode-hook 'display-line-numbers-mode)
  (add-hook 'prog-mode-hook 'display-line-numbers-mode)

  ;; Whitespace display configuration
  (setq whitespace-line-column 80 whitespace-style
	'(face newline space-mark tab-mark newline-mark trailing lines-tail)))

;; Configure GUI
(use-package emacs
  :straight nil
  :if (display-graphic-p)

  :config
  ;; Customizable light and dark theme variables
  (defcustom my-theme-light 'tango
    "The theme to used when the `appearance' is 'light."
    :type 'symbol
    :group 'my-ui)
  (defcustom my-theme-dark 'tango-dark
    "The theme to used when the `appearance' is 'dark."
    :type 'symbol
    :group 'my-ui)

  ;; Theme application functions
  (defun my-apply-theme (appearance)
    "Load theme, taking current system APPEARANCE into consideration."
    (interactive)
    (mapc #'disable-theme custom-enabled-themes)
    (pcase appearance
      ('light (load-theme my-theme-light t))
      ('dark  (load-theme my-theme-dark t))))

  (defun my-apply-theme-light ()
    "Apply the light theme."
    (interactive)
    (my-apply-theme 'light))

  (defun my-apply-theme-dark ()
    "Apply the dark theme."
    (interactive)
    (my-apply-theme 'dark))

  ;; GUI frame configuration
  (defun my-after-make-frame (&optional frame)
    "Configure a new FRAME (default: selected frame) on any system."
    (let* ((frame (or frame (selected-frame)))
           (lines (if (display-graphic-p frame) 1 0)))
      (set-frame-parameter frame 'menu-bar-lines lines)))

  ;; Add hook to configure new GUI frames
  (add-hook 'after-make-frame-functions #'my-after-make-frame)

  ;; Emacs was started normally
  (unless (daemonp)
    (my-after-make-frame)))

;; Configure macOS GUI
(use-package emacs
  :straight nil
  :if (eq system-type 'darwin)
  :config
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

;
;; Configure Linux GUI
(use-package emacs
  :straight nil
  :if (eq system-type 'gnu/linux)
  ;; Frame configuration for `windows' systems.
  (defun my-after-make-frame-linux(&optional frame)
    "Configure a new FRAME (default: selected frame) on `linux' system"

    ;; When the frame is GUI
    (when (display-graphic-p)

      ;; Font customization
      (when (member "Monospace" (font-family-list))
	(set-face-font 'default "Monospace 11"))))

  ;; Hook make frame to apply `linux' specific configuration
  (add-hook 'after-make-frame-functions 'my-after-make-frame-linux)

  ;; Emacs not started in `daemon' mode.
  (unless (daemonp)
    (my-after-make-frame-linux)))

;; Configure Windows GUI
(use-package emacs
  :straight nil
  :if (eq system-type 'windows-nt)

  ;; Frame configuration for `windows' systems.
  (defun my-after-make-frame-windows(&optional frame)
    "Configure a new FRAME (default: selected frame) on `windows' system"

    ;; When the frame is GUI
    (when (display-graphic-p)

      ;; Font customization
      (when (member "FiraCode Nerd Font" (font-family-list))
	(set-face-font 'default "FiraCode Nerd Font 10"))))

  ;; If Emacs is in `daemon' mode, hook the after-make-frame otherwise
  ;; just call my frame configuration function
  (if (daemonp)
      (add-hook 'after-make-frame-functions 'my-after-make-frame-windows)
    (my-after-make-frame-windows)))

(provide 'core-ui)
;;; core-ui.el ends here.
