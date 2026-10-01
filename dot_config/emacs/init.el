;;; init.el --- My Emacs initialization file -*- lexical-binding: t -*-

;; Mike Barker <mike@thebarkers.com>
;; Created: November 23rd, 2025
;; Updated: September 21st, 2026

;;; Commentary:
;; The primary `init' file for emacs. This file specifies how to initialize
;; Emacs and how to customize its various optional features.

;;; History
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:
(when init-file-debug
  (message "Loading init..."))

;; Only support Emacs v29 or greater.
(setq my-emacs-major-version-min 29)
(when (< emacs-major-version my-emacs-major-version-min)
  (error "This config requires Emacs v%s or higher, Emacs v%s is too old."
         emacs-version my-emacs-major-version-min))

;;; File locations

(setq custom-file (expand-file-name "custom.el" my-user-directory))
(setq custom-theme-directory (expand-file-name "themes/" my-user-directory))
(setq my-cache-directory (expand-file-name "cache/" user-emacs-directory))
(setq my-auto-save-directory (expand-file-name "auto-save/" my-cache-directory))
(setq my-backup-directory (expand-file-name "backup/" my-cache-directory))
(setq my-tramp-auto-save-directory (expand-file-name "tramp-auto-save/" my-cache-directory))
      
;; Create subdirectories if missing
(make-directory my-cache-directory t)
(make-directory my-auto-save-directory t)
(make-directory my-backup-directory t)
(make-directory my-tramp-auto-save-directory t)

;;; Customize settings

;; Load the customize settings file
(when (file-exists-p custom-file)
  (load custom-file 'noerror 'nomessage))

;;; Package management - straight.el

;; Note:
;; When using `straight.el' to manage packages, do not use
;; :ensure or the conditional :if/:unless/:when.
;; 
;; Examples:
;; replace :ensure nil
;; with    :straight (:type built-in)
;; replace (use-package :if (condition) ...)
;; with    (if (condition (use-package ...))

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
(use-package straight
  :custom
  (straight-use-package-by-default t))

;;; Initial configuration

;; The initial buffer is created during startup even in non-interactive
;; sessions, and its major mode is fully initialized. Modes like `text-mode',
;; `org-mode', or even the default `lisp-interaction-mode' load extra packages
;; and run hooks, which can slow down startup.

;; Using `fundamental-mode' for the initial buffer to avoid unnecessary startup overhead.
(setq initial-major-mode 'fundamental-mode)
(setq initial-scratch-message nil)

;; Input & prompts
;; Prevent `set-language-environment` from setting an unwanted default input method
(setq default-input-method nil)

;; Ask the user whether to terminate asynchronous compilations on exit.
;; This prevents native compilation from leaving temporary files in /tmp.
(setq native-comp-async-query-on-exit t)

;; Configure short answers by default
(setq use-short-answers t)
(setq read-answer-short t)
(setq revert-buffer-quick-short-answers t)

;;; Abbreviation 

;; Ensure the abbrev_defs file is stored in the correct location when
;; `user-emacs-directory' is modified, as it defaults to ~/.emacs.d/abbrev_defs
;; regardless of the change.
(setq save-abbrevs 'silently)
(setq dabbrev-upcase-means-case-search t)
(setq dabbrev-ignored-buffer-modes '(archive-mode docview-mode
      image-mode pdf-view-mode tags-table-mode))
(setq dabbrev-ignored-buffer-regexps
    '(;; - Buffers starting with a space (internal or temporary buffers)
        "\\` "
        ;; Tags files such as ETAGS, GTAGS, RTAGS, TAGS, e?tags, and GPATH,
        ;; including versions with numeric extensions like <123>
        "\\(?:\\(?:[EG]?\\|GR\\)TAGS\\|e?tags\\|GPATH\\)\\(<[0-9]+>\\)?"))

;;; Auth Source 

;; By default, Emacs stores sensitive authinfo credentials as unencrypted text
;; in your home directory. Use GPG to encrypt the authinfo file for enhanced
;; security.
(setq auth-sources (list "~/.authinfo.gpg"))

;;; Buffer 

;; Disable auto-adding a new line at the bottom when scrolling.
(setq next-line-add-newlines nil)

;; Disable fontification during user input to reduce lag in large buffers.
;; Also helps marginally with scrolling performance.
(setq redisplay-skip-fontification-on-input t)

;; Use forward slashes between the folders and name of the file in a buffer.
;; This is used when you have multiple buffers with the same named file and
;; will create a unique buffer name.
(setq uniquify-buffer-name-style 'forward)

;;; Comint 

(setq ansi-color-for-comint-mode t) ; Renders native ANSI colors in the shell
(setq comint-prompt-read-only t)
(setq comint-buffer-maximum-size 4096)

;;; Customize 

;; Exiting a customize buffer should kill it.
(setq custom-buffer-done-kill t)

;;; Dired 

;; The `ls' command on darwin and bsd systems doesn't support --dired
(when (or (eq system-type 'darwin) (eq system-type 'berkeley-unix))
  (setq dired-use-ls-dired nil))

;; On `darwin' or `bsd' systems, if `gls' is installed use it with the `gls-args'.
(let ((gls-args "--group-directories-first -ahlv"))
  (when (or (eq system-type 'darwin) (eq system-type 'berkeley-unix))
    (if-let* ((gls (executable-find "gls")))
        (setq insert-directory-program gls)
      (setq gls-args nil)))
  (when gls-args
    (setq dired-listing-switches gls-args)))

;; Configure dired behavior
(setq dired-clean-confirm-killing-deleted-buffers nil)
(setq dired-create-destination-dirs 'ask)
(setq dired-deletion-confirmer 'y-or-n-p)
(setq dired-dwim-target t)  ; Propose a target for intelligent moving/copying
(setq dired-filter-verbose nil)
(setq dired-free-space nil)
(setq dired-kill-when-opening-new-dired-buffer t)
(setq dired-mouse-drag-files t)
(setq dired-movement-style 'bounded-files)
(setq dired-recursive-copies 'always)
(setq dired-recursive-deletes 'top)
(setq dired-vc-rename-file t)

;; Keep dired clean by hiding dotfiles
(setq dired-omit-verbose nil)
(setq dired-omit-files (concat "\\`[.]\\'" "\\|^\\."))

;; Sort directories first 
(setq ls-lisp-verbosity nil)
(setq ls-lisp-dirs-first t)

;; This is a higher-level predicate that wraps `dired-directory-changed-p'
;; with additional logic. This `dired-buffer-stale-p' predicate handles remote
;; files, wdired, unreadable dirs, and delegates to dired-directory-changed-p
;; for modification checks.
(setq auto-revert-remote-files nil)

;; Auto refresh Dired buffers, but only if the directory's modification time has
;; changed on disk. Using `dired-directory-changed-p' is efficient: it avoids
;; the unconditional re-renders of `t', and skips the heavy overhead of
;; `dired-buffer-stale-p' (which makes blocking I/O calls for every inserted
;; subdirectory, causing UI freezes on remote/network drives).
(setq dired-auto-revert-buffer 'dired-directory-changed-p)

;; Automatically revert destination Dired buffers after file operations
;; (e.g., copying or renaming), but skip remote directories to prevent
;; TRAMP network latency and UI freezes.
(defun my--local-dir-p (dir)
  "Return non-nil if DIR is a local directory."
  (not (file-remote-p dir)))
(setq dired-do-revert-buffer #'my--local-dir-p)

;; Hide dot files
(add-hook 'dired-mode-hook #'dired-omit-mode)

;; Hide details
(add-hook 'dired-mode-hook #'dired-hide-details-mode)

;; Highlight the current line when in dired mode.
(add-hook 'dired-mode-hook #'hl-line-mode)

;;; Environment 

;; Force the current directory to be the users home dir
(setq default-directory "~/")

;; Darwin (macOS) environment setup here...
(when (eq system-type 'darwin))

;; Linux environment here...
(when (eq system-type 'linux))

;; Windows environment here...
(when (eq system-type 'windows-nt))

;;; Files

;; File Handling & Trash
(setq delete-by-moving-to-trash (not noninteractive))
(setq remote-file-name-inhibit-delete-by-moving-to-trash t)
(setq confirm-nonexistent-file-or-buffer nil)
(setq large-file-warning-threshold (* 100 1024 1024)) ; 100 MB
(setq create-lockfiles nil)

;; Auto-Save Settings
(setq auto-save-no-message t)
(setq auto-save-include-big-deletions t)
(setq kill-buffer-delete-auto-save-files t)
(setq auto-save-list-file-prefix my-auto-save-directory)
(setq tramp-auto-save-directory my-tramp-auto-save-directory)

;; Configure auto-save paths (TRAMP & local)
(let ((auto-dir my-auto-save-directory))
  (setq auto-save-file-name-transforms
        `(("\\`/[^/]*:\\([^/]*/\\)*\\([^/]*\\)\\'" ,(file-name-concat auto-dir "tramp-\\2-") sha1)
          ("\\`/\\([^/]+/\\)*\\([^/]+\\)\\'" ,(file-name-concat auto-dir "\\2-") sha1))))

;; Backups (Disabled, but configured cleanly if re-enabled)
(setq make-backup-files nil)
(setq backup-by-copying t)
(setq backup-by-copying-when-linked t)
(setq delete-old-versions t)
(setq version-control t)
(setq kept-new-versions 5)
(setq kept-old-versions 5)

;; Where backups should be stored
(setq backup-directory-alist
      `((".*" . , my-backup-directory)
        (,tramp-file-name-regexp nil)))

;;; Findfile 

;; Speed up 'find-library' and reduce completion clutter by excluding internal
;; helper files. This provides a library-focused list.
(setq find-library-include-other-files nil)

;; Ignoring this is acceptable since it will redirect to the buffer regardless.
(setq find-file-suppress-same-file-warnings t)

;; Automatically resolve symlinks to their true paths. This sets the correct
;; working directory so C-x C-f opens in the right folder and version control
;; tools recognize the Git repository.
(setq find-file-visit-truename t)

;; Automatically follow a symlink to its source if that source is managed
;; by a version control system, rather than asking for permission.
(setq vc-follow-symlinks t)

;; Protect the system from code injection vulnerabilities when browsing files.
;; Disabling local 'eval' expressions ensures that opening a malicious project
;; or third-party script cannot execute arbitrary Lisp code on your machine.
(setq enable-local-eval nil)

;;; Help 

;; Enhance `apropos' and related functions to perform more extensive searches
(setq apropos-do-all t)

;; Prevents help command completion from triggering autoload.
;; Loading additional files for completion can slow down help commands and may
;; unintentionally execute initialization code from some libraries.
(setq help-enable-completion-autoload nil)
(setq help-enable-autoload nil)
(setq help-enable-symbol-autoload nil)
(setq help-window-select t)  ;; Focus new help windows when opened

;;; Keymaps

;; Make C-g a little more helpful
;; https://protesilaos.com/codelog/2024-11-28-basic-emacs-configuration/
(defun my-keyboard-quit ()
  "Do-What-I-Mean behaviour for a general `keyboard-quit'.

The generic `keyboard-quit' does not do the expected thing when
the minibuffer is open.  Whereas we want it to close the
minibuffer, even without explicitly focusing it.

The DWIM behaviour of this command is as follows:

- When the region is active, disable it.
- When a minibuffer is open, but not focused, close the minibuffer.
- When the Completions buffer is selected, close it.
- In every other case use the regular `keyboard-quit'."
  (interactive)
  (cond
   ((region-active-p)
    (keyboard-quit))
   ((derived-mode-p 'completion-list-mode)
    (delete-completion-window))
   ((> (minibuffer-depth) 0)
    (abort-recursive-edit))
   (t
    (keyboard-quit))))

;; Enhanced keyboard quit
(keymap-global-set "C-g" #'my-keyboard-quit)

;; Window navigation (<C-c + Arrow Keys>)
(keymap-global-set "C-c <left>" #'windmove-left)
(keymap-global-set "C-c <right>" #'windmove-right)
(keymap-global-set "C-c <up>" #'windmove-up)
(keymap-global-set "C-c <down>" #'windmove-down)

;; Darwin (Mac OS X) key bindings

(when (eq system-type 'darwin)
  ;; Make fn-backspace delete forward
  (keymap-global-set "<kp-delete>" #'delete-char) 
  (keymap-global-set "s-<return>" #'toggle-frame-fullscreen)
  (keymap-global-set "s-=" #'text-scale-increase)
  (keymap-global-set "s--" #'text-scale-decrease)
  (keymap-global-set "s-0" (lambda () (interactive) (text-scale-set 0))))

;; Linux key mappings

(when (eq system-type 'linux))

;; Windows key mappings

(when (eq system-type 'windows-nt))

;;; Killing 

;; Remove duplicates from the kill ring to reduce clutter
(setq kill-do-not-save-duplicates t)

;; Preserve the system clipboard before Emacs delete/kill operations.
;; By default, deleting text in Emacs overwrites your system clipboard. For
;; example, if you copy a link from a browser, switch to Emacs, and delete some
;; text, your copied link is lost. This setting fixes that by pushing the
;; clipboard contents into your paste history right before the deletion,
;; ensuring external data remains retrievable via `yank-pop'.
(setq save-interprogram-paste-before-kill t)

;;; Lisp 

;; Disable ellipsis when printing s-expressions in the message buffer
(setq eval-expression-print-length nil)
(setq eval-expression-print-level nil)

;; Speed up 'find-library' and reduce completion clutter by excluding
;; internal helper files. This provides a library-focused list.
(setq find-library-include-other-files nil)

;;; Minibuffer 

;; Allow nested minibuffers
(setq enable-recursive-minibuffers t)

;; Keep the cursor out of the read-only portions of the.minibuffer
(setq minibuffer-prompt-properties
 '(read-only t intangible t cursor-intangible t face minibuffer-prompt))

(add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

;;; Mouse 

;; Force the mouse to paste text at the active cursor position.
(setq mouse-yank-at-point t)

;;; Prog-mode 

;; Show unprettified symbol at point
(setq prettify-symbols-unprettify-at-point 'right-edge)

;; --- Editing & Comment Behavior ---
;; Ensures that empty lines within the commented region are also commented out.
(setq comment-empty-lines t)
;; Enable multi-line commenting.
(setq comment-multi-line t)
;; A longer delay can be annoying as it causes a noticeable pause after each deletion.
(setq delete-pair-blink-delay 0.03)

;;; Text mode 

;; --- Display & Frame Settings ---
;; Avoid automatic frame resizing when adjusting settings.
(setq global-text-scale-adjust-resizes-frames nil)
;; If enabled and `truncate-lines' is disabled, soft wrapping will not occur
;; when the window is narrower than `truncate-partial-width-windows' characters.
(setq truncate-partial-width-windows nil)

;; --- Line Wrapping Defaults ---
;; Continue wrapped lines at whitespace rather than breaking in the middle of a word.
(setq word-wrap t)
;; Disable wrapping by default due to its performance cost.
(setq truncate-lines t)

;; --- Tabs & Indentation Defaults ---
;; Prefer spaces over tabs. Spaces offer a more consistent default compared to 8-space tabs.
(setq indent-tabs-mode nil)
(setq tab-width 4)
;; Configure automatic indentation to be triggered exclusively by newline and DEL characters.
(setq electric-indent-chars '(?\n ?\^?))
;; Only affect leading indentation.
(setq tabify-regexp (rx line-start (zero-or-more ?\t) ?\s (one-or-more blank)))

;; --- TAB Completion Behavior ---
;; Enable indentation and completion using the TAB key.
(setq tab-always-indent 'complete)
(setq tab-first-completion 'word-or-paren-or-punct)

;; --- Search Settings ---
;; Eliminate delay before highlighting search matches.
(setq lazy-highlight-initial-delay 0)

;; --- Line Formatting & Filling ---
;; We often split terminals and editor windows or place them side-by-side.
(setq fill-column 80)
;; Disable end-of-line spacing from the typewriter era.
(setq sentence-end-double-space nil)
;; Ensure line ends with a newline (POSIX standard).
(setq require-final-newline t)
;; Prevent filling commands from inserting line breaks inside hidden text properties.
(setq fill-nobreak-invisible t)

;; --- Performance & Completion ---
;; Perf: Reduce command completion overhead.
(setq read-extended-command-predicate #'command-completion-default-include-p)

;;; Theme 

;; Customizable dark and light theme variables
(defcustom my-theme-dark 'tango-dark
  "The theme to used when the `appearance' is 'dark."
  :type 'symbol
  :group 'my)

(defcustom my-theme-light 'tango
  "The theme to used when the `appearance' is 'light."
  :type 'symbol
  :group 'my)

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

;;; UI 

(blink-cursor-mode -1)
(column-number-mode t)
(show-paren-mode t)

;; Highlighting the current window, reducing clutter and improving performance
(setq hl-line-sticky-flag nil)
(setq global-hl-line-sticky-flag nil)

;; Higlight current line in package menu
(add-hook 'package-menu-mode-hook (lambda() (hl-line-mode 1)))

;; Line number size
(setopt display-line-numbers-width 3)
(setopt display-line-numbers-widen t)

;; Line number type to relative, and display in text and program derived modes
(setopt display-line-numbers-type 'relative)
(add-hook 'text-mode-hook 'display-line-numbers-mode)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; By default, Emacs "updates" its ui more often than it needs to
(setq which-func-update-delay 1.0)
(with-no-warnings
  ;; Obsolete in >= 30.1
  (setq idle-update-delay which-func-update-delay))

;; Never show the hello file
(defalias #'view-hello-file #'ignore)

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

;; Border and window divider setup
(setq window-divider-default-bottom-width 1
      window-divider-default-places t
      window-divider-default-right-width 1)

;; Scrolling
(setq fast-but-imprecise-scrolling t)
(setq scroll-error-top-bottom t)
(setq scroll-preserve-screen-position t)
(setq scroll-conservatively 20)
(setq auto-window-vscroll nil)

;; Horizontal scrolling
(setq hscroll-margin 2
      hscroll-step 1)

;; Cursor
(when (bound-and-true-p blink-cursor-mode)
  (blink-cursor-mode -1))
(setq blink-matching-paren nil)
(setq highlight-nonselected-windows nil)

;; Frame & UI Initialization (Daemon + GUI + TTY support)

;; Configure the font for all new frames
(defun my-configure-frame-font (frame)
  "Set appropriate font for FRAME according to system type."
  (let* ((sys system-type)
         (font-info (pcase sys
                      ('darwin     '("12" . ("0xProto Nerd Font" "FiraCode Nerd Font" "Menlo")))
                      ('gnu/linux  '("10" . ("0xProto Nerd Font" "FiraCode Nerd Font" "Monospace")))
                      ('windows-nt '("10" . ("0xProto Nerd Font" "FiraCode Nerd Font" "Cascadia Code" "Consolas")))))
         (size (car font-info))
         (font-priority (cdr font-info))
         ;; Check font list specifically for the graphical display frame
         (available-fonts (font-family-list frame))
         (chosen-font (seq-find (lambda (font) (member font available-fonts)) font-priority)))
    (when chosen-font
      (when init-file-debug
	(message "Setting font for frame %s: %s %s" frame chosen-font size))
      (set-face-attribute 'default frame :font (format "%s-%s" chosen-font size)))))

;; Configure the frame ui
(defun my-setup-frame-ui (frame)
  "Configure UI components dependent on whether FRAME is GUI or terminal."
  (with-selected-frame frame
    (if (display-graphic-p frame)
        ;; GUI-specific configuration
        (progn
          (my-configure-frame-font frame)
	  ;; Turn ON menu-bar on all GUI frames
	  (set-frame-parameter frame 'menu-bar-lines 1)
          
          ;; macOS GUI specific keybindings & behavior
	  (when (eq system-type 'darwin)
	    ;; Keymapings for macOS gui
	    ;; (keymap-global-set "s-<return>" #'toggle-frame-fullscreen)
	    ;; (keymap-global-set "s-=" #'text-scale-increase)
	    ;; (keymap-global-set "s--" #'text-scale-decrease)
	    ;; (keymap-global-set "s-0" (lambda () (interactive) (text-scale-set 0)))
	    ;; Bring emacs frame to the front
	    (select-frame-set-input-focus frame))

	  ;; Linux GUI frames
	  (when (eq system-type 'gnu/linux))

	  ;; Windows GUI frames
	  (when (eq system-type 'windows-nt)))
      
      ;; Terminal-specific configuration (if needed)
      ;; Disable menu bar and mouse
      (set-frame-parameter frame 'menu-bar-lines 0)
      (xterm-mouse-mode 0))))

;; Hook for newly created frames (handles `emacsclient -c` and daemon background frames)
(add-hook 'after-make-frame-functions #'my-setup-frame-ui)

;; Run configuration immediately for non-daemon startup
(unless (daemonp)
  (my-setup-frame-ui (selected-frame)))

;;; Undo 

(setq undo-limit (* 13 160000))
(setq undo-strong-limit (* 13 240000))
(setq undo-outer-limit (* 13 24000000))

;;; autorevert (built-in)

;; Auto-revert buffers when modified externally
(use-package autorevert
  :straight (:type built-in)
  :custom
  (global-auto-revert-non-file-buffers t)
  (global-auto-revert-ignore-modes '(Buffer-menu-mode))
  :config
  (global-auto-revert-mode 1))

;;; bookmark (built-in)

(use-package bookmark
  :straight (:type built-in)
  :custom
  ;; This setting forces Emacs to save bookmarks immediately after each change.
  ;; Benefit: you never lose bookmarks if Emacs crashes.
  (bookmark-save-flag 1))

;;; cc-mode (built-in)

(use-package cc-mode
  :disabled
  :straight (:type built-in)
  :config
  (add-hook 'c-mode-hook
	    (lambda()
	      ;; Use 'extra-line at top/bottom in c-mode only
	      (setq-local comment-style 'extra-line)))
  :custom
  (c-basic-offset 4))

;;; cedet-mode (built-in)

(use-package cedet
  :disabled
  :straight (:type built-in)
  :config
  (progn
    (require 'cedet)
    ;; Turn on EDE (Project handling mode)
    (global-ede-mode t)
    (semantic-mode 1)))

;;; compile (built-in)

(use-package compile
  :straight (:type built-in)
  :custom
  (compilation-ask-about-save nil)
  (compilation-always-kill t)
  ;; Parse up to 2048 characters per line in compilation buffers. This
  ;; safely catches deep errors and long paths without risking hangs.
  (compilation-max-output-line-length 2048)
  (compilation-scroll-output 'first-error))

;;; diff (built-in)

(use-package diff
  :straight (:type built-in)

  :custom
  ;; Move +/- indicators to the fringe for cleaner diffs
  (diff-font-lock-prettify t))

;;; ediff (built-in)

(use-package ediff
  :straight (:type built-in)
  :custom
  ;; Configure Ediff to use a single frame and split windows horizontally
  (ediff-window-setup-function 'ediff-setup-windows-plain)
  (ediff-split-window-function 'split-window-horizontally))

;;; editorconfig (built-in >=30)
(when (>= emacs-major-version 30)
  (add-to-list 'straight-built-in-pseudo-packages 'editorconfig))

(use-package editorconfig
  :straight t
  :config
  (editorconfig-mode 1))
  
;;; eglot (built-in)

(use-package eglot
  :straight (:type built-in)
  :config
  ;; Optimization & Logging
  (if init-file-debug
      (setq eglot-events-buffer-config '(:size 2000000 :format full))
    (setq jsonrpc-event-hook nil)
    (setq eglot-events-buffer-config '(:size 0 :format short)))
  :custom
  (eglot-report-progress init-file-debug) ; Prevent minibuffer spam
  (eglot-autoshutdown t) ; Shut down after killing last managed buffer
  (eglot-sync-connect 0) ; Connect asynchronously in background
  (eglot-extend-to-xref t) ; Activate in cross-referenced non-project files
  (eglot-code-action-indications '(eldoc-hint))) ; Disable margin indicators

;;; emacs-lock (built-in)

;; Lock buffers so they can not be killed
(use-package emacs-lock
  :config
  (with-current-buffer "*scratch*" (emacs-lock-mode 'kill))
  (with-current-buffer "*Messages*" (emacs-lock-mode 'kill)))

;;; epg (built-in)

(use-package epg
  :straight (:type built-in)
  :custom
  (epg-pinentry-mode 'loopback))
  
;;; eshell (built-in)

;; Open an eshell buffer at the current buffers directory.
(defun my-eshell-here ()
  "Opens up a new shell in the current directory.

The eshell is renamed to match that directory to make multiple eshell windows easier.
If the eshell window is already showing, it will be closed instead."
  (interactive)
  (let* ((parent (if (buffer-file-name)
                     (file-name-directory (buffer-file-name))
                   default-directory))
         (name (car (last (split-string parent "/" t))))
         (eshell-buf-name (concat "*eshell: " name "*"))
         (existing-window (get-buffer-window eshell-buf-name))
         (existing-buffer (get-buffer eshell-buf-name)))
    (if existing-window
        (delete-window existing-window)
	  (let ((height (/ (window-total-height) 3)))
        (split-window-vertically (- height))
        (other-window 1)
        (if existing-buffer
            (switch-to-buffer existing-buffer)
          (eshell "new")
          (rename-buffer eshell-buf-name))))))

;; A command to quit the eshell buffer and delete the window
(defun eshell/q ()
  (insert "exit")
  (eshell-send-input)
  (delete-window))

(use-package eshell
  :straight (:type built-in)
  :bind
  ("C-`" . my-eshell-here)

  :custom
  (eshell-history-size 1024)
  (eshell-save-history-on-exit t)
  (eshell-ask-to-save-history always))

;;; flymake (builtin)

(use-package flymake
  :straight (:type built-in)
  :custom
  (flymake-show-diagnostics-at-end-of-line nil)
  (flymake-wrap-around nil))

;;; hideshow (built-in)

;; toggle hiding block on/off
;; will revert to using selective display if it fails
(defun my-toggle-hiding (column)
      (interactive "P")
      (if hs-minor-mode
          (if (condition-case nil
                  (hs-toggle-hiding)
                (error t))
              (hs-show-all))
        (my-toggle-selective-display column)))

;; toggle selective display of to the current column
(defun my-toggle-selective-display (column)
      (interactive "P")
      (set-selective-display
       (or column
           (unless selective-display
             (1+ (current-column))))))

;; rules used to handle hiding nxml sections
(defun my-nxml-forward-sexp-func (pos)
  (my-nxml-forward-element))

(defun my-nxml-forward-element ()
  (let ((nxml-sexp-element-flag)
  	(outline-regexp "\\s *<\\([h][1-6]\\|html\\|body\\|head\\)\\b"))
    (setq nxml-sexp-element-flag (not (looking-at "<!--")))
    (unless (looking-at outline-regexp)
      (condition-case nil
  	  (nxml-forward-balanced-item 1)
  	(error nil)))))

(use-package hideshow
  :bind
  (("C-c =" . my-toggle-hiding)
   ("C-c +" . my-toggle-selective-display))

  :config
  ;; nxml-mode config to hide/show blocks
  (add-to-list 'hs-special-modes-alist
               '(nxml-mode
                 "<!--\\|<[^/>]>\\|<[^/][^>]*[^/]>"
                 ""
                 "<!--"                        ; won't work on its own; uses syntax table
                 my-nxml-forward-sexp-func
                 nil                           ; my-nxml-hs-adjust-beg-func
                 ))
  ;; html-mode config to hide/show blocks
  (add-to-list 'hs-special-modes-alist
		       '(html-mode
		         "<!--\\|<[^/>]>\\|<[^/][^>]*"
		         "</\\|-->"
		         "<!--"
		         sgml-skip-tag-forward
		         nil))
  :hook
  ;; hook into the following major modes
  (c-mode-common-hook    . hs-minor-mode)
  (emacs-lisp-mode-hook  . hs-minor-mode)
  (java-mode-hook        . hs-minor-mode)
  (lisp-mode-hook        . hs-minor-mode)
  (perl-mode-hook        . hs-minor-mode)
  (sh-mode-hook          . hs-minor-mode)
  (nxml-mode-hook        . hs-minor-mode)
  (html-mode-hook        . hs-minor-mode))


;;; icomplete (built-in)

;; Do not delay displaying completion candidates in `fido-mode' or
;; `fido-vertical-mode'
(use-package icomplete
  :straight (:type built-in)
  :custom
  (icomplete-compute-delay 0.01))

;;; imenu (built-in)

(use-package imenu
  :straight (:type built-in)
  :custom
  ;; Automatically rescan the buffer for Imenu entries when `imenu' is invoked
  ;; This ensures the index reflects recent edits.
  (imenu-auto-rescan t)
  ;; Prevent truncation of long function names in `imenu' listings
  (imenu-max-item-length 160))

;;; ispell (built-in)

;; configure ispell if a spelling tool is installed
;; prefer `aspell' over `hunspell'
(use-package ispell
  :straight (:type built-in)
  :init
  (cond
   ((executable-find "aspell")
    (setq ispell-program-name "aspell"))
   ((executable-find "hunspell")
    (setq ispell-program-name "hunspell")))
  :custom
  (ispell-silently-savep t)
  (ispell-local-dictionary "en_US"))

;; Darwin (macOS) specific config
(when (eq system-type 'darwin))

;; Linux specific config
(when (eq system-type 'gnu/linux))

;; Windows specific config
(when (eq system-type 'windows-nt)
  (use-package ispell
    :straight (:type built-in)
    :custom
    (ispell-hunspell-dict-paths-alist '(("en_US" "c:/hunspell/en_US.aff")))
    :config
    (setenv "LANG" "en_US")))

;;; python (built-in)

(use-package treesit
  :straight (:type built-in)
  :config
  (add-to-list 'major-mode-remap-alist '(python-mode . python-ts-mode)))

(use-package python
  :straight (:type built-in)
  :custom
  ;; Do not notify the user each time Python tries to guess the indentation offset
  (python-indent-guess-indent-offset-verbose nil)
  :hook
  ((python-ts-mode . eglot-ensure)
   (python-ts-mode . flyspell-prog-mode)
   (python-ts-mode . hs-minor-mode)))

;;; recentf (built-in)

(use-package recentf
  :straight (:type built-in)
  :bind
  ;; Replace `find-file-read-only' keybinding with recentf.
  ("C-x C-r" . recentf-open)
  :custom
  ;; `recentf' maintains a list of recently accessed files.
  (recentf-max-saved-items 300) ; default is 20
  (recentf-max-menu-items 15))

;;; savehist (built-in)

;; The built-in savehist package keeps a record of user inputs and
(use-package savehist
  :straight (:type built-in)
  :custom
  (history-length 300)
  (savehist-additional-variables
   '(register-alist                   ; macros
     mark-ring global-mark-ring       ; marks
     search-ring regexp-search-ring)) ; searches
  :hook (after-init . savehist-mode))

;;; saveplace (built-in)

;; Save cursor location across sessions
(use-package saveplace
  :straight (:type built-in)
  :custom
  (save-place-file (expand-file-name "saveplace" my-cache-directory))
  (save-place-limit 600)
  :config
  (save-place-mode 1))

;;; server (built-in)

;; For non-daemon emacs start the server if not already running.
(unless (daemonp)
  (use-package server
    :straight (:type built-in)
    :config
    (unless (server-running-p)
      (server-start))))

;;; shell (built-in)

(use-package shell
  :straight (:type built-in)
  :custom
  (sh-indent-after-continuation 'always))

;;; tramp (built-in)

(use-package tramp
  :straight (:type built-in)
  :custom
  (tramp-verbose 1)
  (remote-file-name-inhibit-cache 50)
  ;; Disable lockfiles and auto-saves for remote files to eliminate lag
  (remote-file-name-inhibit-locks t)
  (remote-file-name-inhibit-auto-save-visited t))

;;; treesitter (built-in)

(use-package treesit
  :straight (:type built-in)
  :config
  (add-to-list 'major-mode-remap-alist
	       '(python-mode . python-ts-mode)))

;;; vc (built-in)

(use-package vc
  :straight (:type built-in)
  :custom
  (vc-git-print-log-follow t)
  (vc-git-diff-switches '("--histogram")))  ; Faster algorithm for diffing.

;; which-key (built-in)
(use-package which-key
  :straight (:type built-in)
  :init
  (which-key-mode)
  :custom
  (which-key-idle-delay 0.3))

;;; whitespace (built-in)

(use-package whitespace
  :straight (:type built-in)
  :custom
  (whitespace-line-column nil)
  (whitespace-style '(face newline space-mark tab-mark newline-mark trailing lines-tail)))

;;; xref (built-in)

(use-package xref
  :straight (:type built-in)
  :custom
  ;; Enable completion in the minibuffer instead of the definitions buffer
  (xref-show-definitions-function 'xref-show-definitions-completing-read)
  (xref-show-xrefs-function 'xref-show-definitions-completing-read))
  
;;; Require external packages.

;; Require all files matching FILESPEC in DIRECTORY.
(defun my-require-features (filespec directory)
  "Require all `.el' files matching FILESPEC in DIRECTORY."
  (when (file-exists-p directory)
    (add-to-list 'load-path directory)
    (let ((pattern (wildcard-to-regexp filespec)))
      (dolist (file (directory-files directory nil pattern))
	(when init-file-debug
	  (message "require file %s..." file))
        (require (intern (file-name-sans-extension file)) nil t)))))

(when init-file-debug
  (message "Require external packages..."))
(my-require-features "package-*.el" (expand-file-name "lisp" user-emacs-directory))

;;; end of init.el
