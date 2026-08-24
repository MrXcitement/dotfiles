;;; core-ui.el --- Initialize the user interface

;; Mike Barker <mike@thebarkers.com>
;; Created: November 24th, 2025
;; Updated: August 24th, 2026

;;; Commentary:
;; Initialize the user interface handling text and gui modes.
;; C source, frame.el, hl-line.el, mouse.el, mule-cmds.el, mule-util.el,
;; paren.el, simple.el, time.el, window.el

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:

(blink-cursor-mode -1)
(column-number-mode t)
(show-paren-mode t)

;; Highlighting the current window, reducing clutter and improving performance
(setq hl-line-sticky-flag nil)
(setq global-hl-line-sticky-flag nil)
;; Higlight current line in package menu
(add-hook 'package-menu-mode-hook (lambda() (hl-line-mode 1)))

;; Line numbers

(setopt display-line-numbers-width 3)
(setopt display-line-numbers-widen t)

;; Line number type to relative, and display in text and program derived modes
(setopt display-line-numbers-type 'relative)
(add-hook 'text-mode-hook 'display-line-numbers-mode)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; Whitespace display configuration
(setq whitespace-line-column nil  ; Use the value of `fill-column'
      whitespace-style
      '(face newline space-mark tab-mark newline-mark trailing lines-tail))

;; By default, Emacs "updates" its ui more often than it needs to
(setq which-func-update-delay 1.0)
(with-no-warnings
  ;; Obsolete in >= 30.1
  (setq idle-update-delay which-func-update-delay))

(defalias #'view-hello-file #'ignore)  ; Never show the hello file

;; No beeping or blinking
(setq visible-bell nil)
(setq ring-bell-function #'ignore)

;; Position underlines at the descent line instead of the baseline.
(setq x-underline-at-descent-line t)

(setq truncate-string-ellipsis "…")

(setq display-time-default-load-average nil) ; Omit load average

;; Prefer vertical splits over horizontal ones
(setq split-width-threshold 170
      split-height-threshold nil)

;; Show parenthesis

(setq show-paren-delay 0.1
      show-paren-highlight-openparen t
      show-paren-when-point-inside-paren t
      show-paren-when-point-in-periphery t)

;; Frames and windows

(setq resize-mini-windows 'grow-only)
(setq max-mini-window-height 0.33)

;; The native border "uses" a pixel of the fringe on the rightmost
;; splits, whereas `window-divider-mode' does not.
(setq window-divider-default-bottom-width 1
      window-divider-default-places t
      window-divider-default-right-width 1)

;; Scrolling

;; Enables faster scrolling. This may result in brief periods of inaccurate
;; syntax highlighting, which should quickly self-correct.
(setq fast-but-imprecise-scrolling t)

;; Move point to top/bottom of buffer before signaling a scrolling error.
(setq scroll-error-top-bottom t)

;; Keep screen position if scroll command moved it vertically out of the window.
(setq scroll-preserve-screen-position t)

;; Emacs recenters the window when the cursor moves past `scroll-conservatively'
;; lines beyond the window edge. A value over 101 disables recentering; the
;; default (0) is too eager. Here it is set to 20 for a balanced behavior.
(setq scroll-conservatively 20)

;; 1. Preventing automatic adjustments to `window-vscroll' for long lines.
;; 2. Resolving the issue of random half-screen jumps during scrolling.
(setq auto-window-vscroll nil)

;; Horizontal scrolling
(setq hscroll-margin 2
      hscroll-step 1)

;; Cursor

;; The blinking cursor is distracting and interferes with cursor settings in
;; some minor modes that try to change it buffer-locally (e.g., Treemacs).
(when (bound-and-true-p blink-cursor-mode)
  (blink-cursor-mode -1))

;; Don't blink the paren matching the one at point, it's too distracting.
(setq blink-matching-paren nil)

;; Reduce rendering/line scan work by not rendering cursors or regions in
;; non-focused windows.
(setq highlight-nonselected-windows nil)

;; Configure macOS
(when (eq system-type 'darwin)

  ;; Frame configuration for `darwin'
  (defun my-after-make-frame-darwin(&optional frame)
    "Configure a new FRAME (default: selected frame) on `darwin' system"

    (message "my-after-make-frame-darwin(%s)" frame)

    ;; When the frame is GUI
    (when (display-graphic-p)

      ;; set key to toggle fullscreen mode
      (global-set-key (kbd "s-<return>") 'toggle-frame-fullscreen)

      ;; set default font
      (when (member "FiraCode Nerd Font" (font-family-list))
        (set-frame-font "FiraCode Nerd Font" t t))

      ;; raise Emacs using AppleScript."
      (ns-do-applescript "tell application \"Emacs\" to activate")))

  ;; If Emacs is in `daemon' mode, hook the after-make-frame 
  (when (daemonp)
    (add-hook 'after-make-frame-functions 'my-after-make-frame-darwin))

  ;; Always call my frame configuration function
  (my-after-make-frame-darwin))

;; Configure Linux
(when (eq system-type 'gnu/linux)

  ;; Frame configuration for `windows' systems.
  (defun my-after-make-frame-linux(&optional frame)
    "Configure a new FRAME (default: selected frame) on `linux' system"

    (message "my-after-make-frame-linux(&optional %s)" frame)

    ;; When the frame is GUI
    (when (display-graphic-p)

      ;; Default Font
      (let* ((font-priority '("0xProto Nerd Font"  "FiraCode Nerd Font" "Monospace"))
             (available-fonts (font-family-list))
             (chosen-font (seq-find (lambda (font) (member font available-fonts)) font-priority)))
        (when chosen-font
          (set-face-font 'default (format "%s 10" chosen-font))))))

  ;; If Emacs is in `daemon' mode, hook the after-make-frame 
  (when (daemonp)
    (add-hook 'after-make-frame-functions 'my-after-make-frame-linux))
  
  ;; Always call my frame configuration function
  (my-after-make-frame-linux))

;; Configure Windows
(when (eq system-type 'windows-nt)

  ;; Frame configuration for `windows' systems.
  (defun my-after-make-frame-windows(&optional frame)
    "Configure a new FRAME (default: selected frame) on `windows' system"

    (message "my-after-make-frame-windows(&optional %s)" frame)

    ;; When the frame is GUI
    (when (display-graphic-p)

      ;; Font customization
      (when (member "FiraCode Nerd Font" (font-family-list))
        (set-face-font 'default "FiraCode Nerd Font 10"))))

  ;; If Emacs is in `daemon' mode, hook the after-make-frame 
  (when (daemonp)
    (add-hook 'after-make-frame-functions 'my-after-make-frame-windows))
  
  ;; Always call my frame configuration function
  (my-after-make-frame-windows))


(provide 'core-ui)
;;; core-ui.el ends here.
