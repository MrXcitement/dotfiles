;;; init-ui.el --- Initialize the user interface

;; Mike Barker <mike@thebarkers.com>
;; November 24th, 2025

;;; Commentary:
;; Initialize the user interface handling text and gui modes.
;; System specific initialization is handled in the `init-ui-<system>.el' files.

;;; History:
;; - Created.

;;; Code:

;; Customizable light and dark theme
(defcustom my-theme-light 'tango
  "The theme to used when the `appearance' is 'light."
  :type 'symbol
  :group 'my-ui)

(defcustom my-theme-dark 'tango-dark
  "The theme to used when the `appearance' is 'dark."
  :type 'symbol
  :group 'my-ui)

;; Apply theme based on system appearance
(defun my-apply-theme (appearance)
  "Load theme, taking current system APPEARANCE into consideration."
  (interactive)
  (mapc #'disable-theme custom-enabled-themes)
  (pcase appearance
    ('light (load-theme my-theme-light t))
    ('dark (load-theme my-theme-dark t))))

;; Apply light theme
(defun my-apply-theme-light ()
  "Apply the light theme"
  (interactive)
  (my-apply-theme 'light))

;; Apply dark theme
(defun my-apply-theme-dark ()
  "Apply the dark theme"
  (interactive)
  (my-apply-theme 'dark))

;; Any GUI/TUI configuration
(defun my-after-make-frame (&optional frame)
  "Configure a new FRAME (default: selected frame) on any system"

  ;; Display the menubar in GUI and hide in TUI frames
  (let ((lines (if (display-graphic-p frame) 1 0)))
    (set-frame-parameter frame 'menu-bar-lines lines)))

;; Any ui settings
(blink-cursor-mode -1)
(column-number-mode t)
(show-paren-mode t)

;; Line number type to relative, and display in text and program derived modes
(setopt display-line-numbers-type 'relative)
(add-hook 'text-mode-hook 'display-line-numbers-mode)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; Whitespace display configuration
(setq whitespace-line-column 80 whitespace-style
      '(face newline space-mark tab-mark newline-mark trailing lines-tail))

;; Add hook to configure new frames either GUI or TUI
(add-hook 'after-make-frame-functions 'my-after-make-frame)

;; Emacs was started normally
(unless (daemonp)
  (my-after-make-frame))


;;; System specific UI customization

;; Darwin (Mac OS X) UI customization
(when (eq system-type 'darwin)
  (require 'init-ui-darwin))

;; Linux UI customization
(when (eq system-type 'gnu/linux)
  (require 'init-ui-linux))

;; Windows UI customization
(when (eq system-type 'windows-nt)
  (require 'init-ui-windows))

(provide 'init-ui)
;;; init-ui.el ends here.
