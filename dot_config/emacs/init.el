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
(message "Loading init...")

;; Only support Emacs v29+.
(when (< emacs-major-version 29)
  (error "Your Emacs v%s is too old -- this config requires Emacs v27 or higher"
         emacs-version))

;;; Package management configuration - `straight.el'

;; ** Note **
;; When using `straight.el' to manage packages, do not use
;; :ensure or :if/:unless/:when.
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

;; Configure use-package to use straight.el by default
(use-package straight
  :custom
  (straight-use-package-by-default t))

;;; Customize file
;; Define and load the customize file
;; TODO: Should this happen first, last or somewhere in-between?
(setq custom-file (expand-file-name "custom.el" my-user-directory))
(load custom-file :no-error-if-file-is-missing)

;;; Core Functionality
;; TODO: Configuration in this section needs to be reviewed!

 ;; The initial buffer is created during startup even in non-interactive
 ;; sessions, and its major mode is fully initialized. Modes like `text-mode',
 ;; `org-mode', or even the default `lisp-interaction-mode' load extra packages
;; and run hooks, which can slow down startup.

 ;; Using `fundamental-mode' for the initial buffer to avoid unnecessary
 ;; startup overhead.
(setq initial-major-mode 'fundamental-mode
      initial-scratch-message nil)

 ;; Set-language-environment sets default-input-method, which is unwanted.
(setq default-input-method nil)

 ;; Ask the user whether to terminate asynchronous compilations on exit.
 ;; This prevents native compilation from leaving temporary files in /tmp.
(setq native-comp-async-query-on-exit t)

 ;; Allow for shorter responses: "y" for yes and "n" for no.
(setq read-answer-short t
      revert-buffer-quick-short-answers t)

;; Allow for shorter responses: "y" for yes and "n" for no.
(if (boundp 'use-short-answers)
    (setq use-short-answers t)
  (advice-add 'yes-or-no-p :override #'y-or-n-p))

;; Short y or n for reverted buffers
(setq revert-buffer-quick-short-answers t)

;;; Abbreviation 

(use-package emacs
  :custom
  ;; Ensure the abbrev_defs file is stored in the correct location when
  ;; `user-emacs-directory' is modified, as it defaults to ~/.emacs.d/abbrev_defs
  ;; regardless of the change.
  (save-abbrevs 'silently)
  (dabbrev-upcase-means-case-search t)
  (dabbrev-ignored-buffer-modes
        '(archive-mode image-mode docview-mode tags-table-mode
                       pdf-view-mode tags-table-mode))
  (dabbrev-ignored-buffer-regexps
        '(;; - Buffers starting with a space (internal or temporary buffers)
          "\\` "
          ;; Tags files such as ETAGS, GTAGS, RTAGS, TAGS, e?tags, and GPATH,
          ;; including versions with numeric extensions like <123>
          "\\(?:\\(?:[EG]?\\|GR\\)TAGS\\|e?tags\\|GPATH\\)\\(<[0-9]+>\\)?")))

;;; Auth Source 

;; By default, Emacs stores sensitive authinfo credentials as unencrypted text
;; in your home directory. Use GPG to encrypt the authinfo file for enhanced
;; security.
(use-package emacs
  :custom
  (auth-sources (list "~/.authinfo.gpg")))

;;; Buffer 

(use-package emacs
  :custom
  ;; Disable auto-adding a new line at the bottom when scrolling.
  (next-line-add-newlines nil)
  ;; Disable fontification during user input to reduce lag in large buffers.
  ;; Also helps marginally with scrolling performance.
  (redisplay-skip-fontification-on-input t)
  ;; Use forward slashes between the folders and name of the file in a buffer.
  ;; This is used when you have multiple buffers with the same named file and
  ;; will create a unique buffer name.
  (uniquify-buffer-name-style 'forward))

;;; Comint 

(use-package emacs
  :custom
  (ansi-color-for-comint-mode t) ; Renders native ANSI colors in the shell
  (comint-prompt-read-only t)
  (comint-buffer-maximum-size 4096))

;;; Customize 

(use-package emacs
  :custom
  ;; Exiting a customize buffer should kill it.
  (custom-buffer-done-kill t))

;;; Dired 

;; Configure dired behavior
(use-package emacs
  :config
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
  :custom
  (dired-clean-confirm-killing-deleted-buffers nil)
  (dired-create-destination-dirs 'ask)
  (dired-deletion-confirmer 'y-or-n-p)
  (dired-dwim-target t)  ; Propose a target for intelligent moving/copying
  (dired-filter-verbose nil)
  (dired-free-space nil)
  (dired-kill-when-opening-new-dired-buffer t)
  (dired-mouse-drag-files t)
  (dired-movement-style 'bounded-files)
  (dired-recursive-copies 'always)
  (dired-recursive-deletes 'top)
  (dired-vc-rename-file t)
  ;; Keep dired clean by hiding dotfiles
  (dired-omit-verbose nil)
  (dired-omit-files (concat "\\`[.]\\'" "\\|^\\."))
  ;; Sort directories first 
  (ls-lisp-verbosity nil)
  (ls-lisp-dirs-first t)
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
  (dired-auto-revert-buffer 'dired-directory-changed-p)
  ;; Revert destination Dired buffers after file operations.
  ;; Skip remote directories to prevent TRAMP network latency and UI freezes.
  (dired-do-revert-buffer (lambda (dir)
                            (not (file-remote-p dir))))
  :hook
  (dired-mode-hook . dired-omit-mode)
  ;; Hide details
  (dired-mode-hook . dired-hide-details-mode)
  ;; Highlight the current line when in dired mode.
  (dired-mode-hook . hl-line-mode))

;;; Environment 

(use-package emacs
  :custom
  ;; Force the current directory to be the users home dir
  (default-directory "~/"))

;; Darwin (macOS) environment setup here...
(when (eq system-type 'darwin))

;; Linux environment here...
(when (eq system-type 'linux))

;; Windows environment here...
(when (eq system-type 'windows-nt))

;;; Files (start)
;; TODO: This section needs to be reviewed! It is doing alot and most likely not
;; at the right time, e.g. cache directory should be configured much earlier...

(defcustom my-cache-directory (expand-file-name "cache/" user-emacs-directory)
  "Base directory for Emacs cache files.

All entries in `my-cache-paths' are resolved relative to this
directory.  Choose one of the presets or supply any custom directory path.
Changes take effect after restarting Emacs."
  :type `(choice
          (const     :tag "Inside Emacs config  (cache/ in user-emacs-directory)"
                     ,(expand-file-name "cache/" user-emacs-directory))
          (const     :tag "System temp          (/tmp/emacs-cache/)" "/tmp/emacs-cache/")
          (directory :tag "Custom directory"))
  :group 'my)

;; Make the cache directory
(make-directory my-cache-directory t)

;; Configure auto-save settings ...

;; Enable auto-save to safeguard against crashes or data loss. The
;; `recover-file' or `recover-session' functions can be used to restore
;; auto-saved data.
(setq auto-save-no-message t)

(let ((auto-save-dir (expand-file-name "auto-save/" my-cache-directory)))

  ;; Create directories if they don't exist
  (make-directory auto-save-dir t)

  ;; File Auto-save settings
  (setq auto-save-list-file-prefix auto-save-dir)
  (setq auto-save-file-name-transforms
        `(( ,".*" ,auto-save-dir t))))

;; Do not auto-disable auto-save after deleting large chunks of
;; text.
(setq auto-save-include-big-deletions t)

(setq auto-save-list-file-prefix
      (expand-file-name "autosave/" user-emacs-directory))
(setq tramp-auto-save-directory
      (expand-file-name "tramp-autosave/" user-emacs-directory))

;; WHY??? create a function and then just call it?
;; I would have expected it to be assigned to a hook or something???
(defun my-setup-auto-save-transforms ()
  "Configure `auto-save-file-name-transforms' for local and remote files.
This should be called after changing `auto-save-list-file-prefix'."
  (setq auto-save-file-name-transforms
        `(("\\`/[^/]*:\\([^/]*/\\)*\\([^/]*\\)\\'"
           ;; Redirect TRAMP (remote) file auto-saves to the local machine
           ;; (prefixed with "tramp-") to prevent Emacs from hanging due to
           ;; network latency during auto-save operations.
           ,(file-name-concat auto-save-list-file-prefix "tramp-\\2-") sha1)
          ("\\`/\\([^/]+/\\)*\\([^/]+\\)\\'"
           ;; Redirect absolute file paths auto-saves to the
           ;; `auto-save-list-file-prefix' directory. This appends the base
           ;; filename to the prefix, avoiding #file.txt# files across the system.
           ,(file-name-concat auto-save-list-file-prefix "\\2-") sha1)))

  (when (memq system-type '(windows-nt cygwin ms-dos))
    (push `("\\`\\(/\\|[a-zA-Z]:/\\|//\\)\\([^/]+/\\)*\\([^/]+\\)\\'"
            ,(file-name-concat auto-save-list-file-prefix "\\3-") sha1)
          auto-save-file-name-transforms)))

(my-setup-auto-save-transforms)

;; Ensure the directory for auto-save session logs exists with restricted
;; permissions.
(when auto-save-default
  (let ((auto-save-dir (file-name-directory auto-save-list-file-prefix)))
    (unless (file-exists-p auto-save-dir)
      (with-file-modes #o700
        (make-directory auto-save-dir t)))))

(setq kill-buffer-delete-auto-save-files t)

;; Remove duplicates from the kill ring to reduce clutter
(setq kill-do-not-save-duplicates t)

;; Configure file backup settings ...

;; Disable backup files (e.g., filename~). Note that `auto-save-default'
;; remains enabled by default. Even with `make-backup-files' backups disabled,
;; Emacs will still generate temporary recovery files (e.g., #filename#) for
;; unsaved buffers. This protects your active work from sudden crashes while
;; ensuring the file system is cleaned up immediately upon a successful save.
(setq make-backup-files nil)

(let ((backup-dir    (expand-file-name "backup/" my-cache-directory)))

  ;; Create directories if they don't exist
  (make-directory backup-dir t)

  ;; File Backup settings
  (setq backup-directory-alist
        `((".*" . ,backup-dir)
          (,tramp-file-name-regexp nil))))

(setq backup-by-copying t)
(setq backup-by-copying-when-linked t)
(setq delete-old-versions t)  ; Delete excess backup versions silently
(setq version-control t)  ; Use version numbers for backup files
(setq kept-new-versions 5)
(setq kept-old-versions 5)

;; Configure file settings ...

;; Delete by moving to trash in interactive mode
(setq delete-by-moving-to-trash (not noninteractive))
(setq remote-file-name-inhibit-delete-by-moving-to-trash t)

;; Increase threshold for large-file warning to reduce prompts when opening
;; moderately large files while still preserving safeguards for large files.
(setq large-file-warning-threshold (* 100 1024 1024)) ; 100 Mb

;; Disable the creation of lockfiles (e.g., .#filename).
;; Modern workflows rely on `global-auto-revert-mode' to handle external file
;; changes gracefully, making the restrictive nature of lockfiles unnecessary.
(setq create-lockfiles nil)

;; Auto revert

;; Auto-revert in Emacs is a feature that automatically updates the contents of
;; a buffer to reflect changes made to the underlying file.
(setq global-auto-revert-mode 1)

;; Revert other buffers (e.g, Dired)
(setq global-auto-revert-non-file-buffers t)
(setq global-auto-revert-ignore-modes '(Buffer-menu-mode))

;; Save-place

;; Enables Emacs to remember the last location within a file upon reopening.
(setq save-place-file (expand-file-name "saveplace" my-cache-directory))
(setq save-place-limit 600)

;; Remove trailing whitespace from lines when saving files
;; (before-save-hook . delete-trailing-whitespace)

;; Skip confirmation prompts when creating a new file or buffer
(setq confirm-nonexistent-file-or-buffer nil)

;;; Findfile 

(use-package emacs
  :custom
  ;; Speed up 'find-library' and reduce completion clutter by excluding internal
  ;; helper files. This provides a library-focused list.
  (find-library-include-other-files nil)

  ;; Ignoring this is acceptable since it will redirect to the buffer regardless.
  (find-file-suppress-same-file-warnings t)

  ;; Automatically resolve symlinks to their true paths. This sets the correct
  ;; working directory so C-x C-f opens in the right folder and version control
  ;; tools recognize the Git repository.
  (find-file-visit-truename t)
  ;; Automatically follow a symlink to its source if that source is managed
  ;; by a version control system, rather than asking for permission.
  (vc-follow-symlinks t)

  ;; Protect the system from code injection vulnerabilities when browsing files.
  ;; Disabling local 'eval' expressions ensures that opening a malicious project
  ;; or third-party script cannot execute arbitrary Lisp code on your machine.
  (enable-local-eval nil))

;;; Help 

(use-package emacs
  :custom
  ;; Enhance `apropos' and related functions to perform more extensive searches
  (apropos-do-all t)
  ;; Prevents help command completion from triggering autoload.
  ;; Loading additional files for completion can slow down help commands and may
  ;; unintentionally execute initialization code from some libraries.
  (help-enable-completion-autoload nil)
  (help-enable-autoload nil)
  (help-enable-symbol-autoload nil)
  (help-window-select t))  ;; Focus new help windows when opened

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

;; Rebind C-g to use the modified my-keyboard-quit
(keymap-global-set "C-g" #'my-keyboard-quit)

;; Compilation output, next/previous error. (<alt-{page up/page down}>)
(keymap-global-set "M-<prior>" #'previous-error)
(keymap-global-set "M-<next>"  #'next-error)

;; Move to window support (<C-c-{up,down,left,right}>)
(keymap-global-set "C-c <left>"  #'windmove-left)
(keymap-global-set "C-c <right>" #'windmove-right)
(keymap-global-set "C-c <up>"    #'windmove-up)
(keymap-global-set "C-c <down>"  #'windmove-down)

;; Configure mouse-3 ffap bindings as documented here:
;; https://www.gnu.org/software/emacs/manual/html_node/emacs/FFAP.html
(keymap-global-set "C-S-<mouse-1>" #'ffap-at-mouse)
(keymap-global-set "C-S-<mouse-3>" #'ffap-menu)

;; Configure cua mode to allow selection of text only.
;; This allows the C-x,c,v keys to retain their original functionality
;; but allow cua rectangle selection.
;; (cua-selection-mode 1)

;; Darwin (Mac OS X) key bindings

(when (eq system-type 'darwin)
  (keymap-global-set "<kp-delete>" #'delete-char) ; Make fn-backspace delete forward
  (keymap-global-set "s-=" #'text-scale-increase)
  (keymap-global-set "s--" #'text-scale-decrease)
  (keymap-global-set "s-0" (lambda () (interactive) (text-scale-set 0))))

;; Linux key mappings

(when (eq system-type 'linux))

;; Windows key mappings

(when (eq system-type 'windows-nt))

;;; Killing 

(use-package emacs
  :custom
  ;; Remove duplicates from the kill ring to reduce clutter
  (kill-do-not-save-duplicates t)
  ;; Preserve the system clipboard before Emacs delete/kill operations.
  ;; By default, deleting text in Emacs overwrites your system clipboard. For
  ;; example, if you copy a link from a browser, switch to Emacs, and delete some
  ;; text, your copied link is lost. This setting fixes that by pushing the
  ;; clipboard contents into your paste history right before the deletion,
  ;; ensuring external data remains retrievable via `yank-pop'.
  (save-interprogram-paste-before-kill t))

;;; Lisp 

(use-package emacs
  :custom
  ;; Disable ellipsis when printing s-expressions in the message buffer
  (eval-expression-print-length nil)
  (eval-expression-print-level nil)
  ;; Speed up 'find-library' and reduce completion clutter by excluding
  ;; internal helper files. This provides a library-focused list.
  (find-library-include-other-files nil))

;;; Minibuffer 

(use-package emacs
  :custom
  ;; Allow nested minibuffers
  (enable-recursive-minibuffers t)
  ;; Keep the cursor out of the read-only portions of the.minibuffer
  (minibuffer-prompt-properties
        '(read-only t intangible t cursor-intangible t face minibuffer-prompt))
  :hook
  (minibuffer-setup-hook . cursor-intangible-mode))

;;; Mouse 

(use-package emacs
  :custom
  ;; Force the mouse to paste text at the active cursor position.
  (mouse-yank-at-point t))

;;; Context Menu
;; TODO: How do we handle this when running as a `daemon' started from the command line?
(when (memq 'context-menu my-ui-features)
  (when (and (display-graphic-p) (fboundp 'context-menu-mode))
    (add-hook 'after-init-hook #'context-menu-mode)))

;;; Prog-mode 

(use-package emacs
  :custom
  ;; Show unprettified symbol at point
  (prettify-symbols-unprettify-at-point 'right-edge))

;;; Text mode 

;; Text editing, indent, font, and formatting

;; Avoid automatic frame resizing when adjusting settings.
(setq global-text-scale-adjust-resizes-frames nil)

;; A longer delay can be annoying as it causes a noticeable pause after each
;; deletion, disrupting the flow of editing.
(setq delete-pair-blink-delay 0.03)

;; Continue wrapped lines at whitespace rather than breaking in the
;; middle of a word.
(setq-default word-wrap t)

;; Disable wrapping by default due to its performance cost.
(setq-default truncate-lines t)

;; If enabled and `truncate-lines' is disabled, soft wrapping will not occur
;; when the window is narrower than `truncate-partial-width-windows' characters.
(setq truncate-partial-width-windows nil)

;; Configure automatic indentation to be triggered exclusively by newline and
;; DEL (backspace) characters.
(setq-default electric-indent-chars '(?\n ?\^?))

;; Prefer spaces over tabs. Spaces offer a more consistent default compared to
;; 8-space tabs. This setting can be adjusted on a per-mode basis as needed.
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

;; Enable indentation and completion using the TAB key
(setq tab-always-indent 'complete)
(setq tab-first-completion 'word-or-paren-or-punct)

;; Perf: Reduce command completion overhead.
(setq read-extended-command-predicate #'command-completion-default-include-p)

;; Enable multi-line commenting which ensures that `comment-indent-new-line'
;; properly continues comments onto new lines.
(setq comment-multi-line t)

;; Ensures that empty lines within the commented region are also commented out.
;; This prevents unintended visual gaps and maintains a consistent appearance.
(setq comment-empty-lines t)

;; We often split terminals and editor windows or place them side-by-side,
;; making use of the additional horizontal space.
(setq-default fill-column 80)

;; Disable the obsolete practice of end-of-line spacing from the typewriter era.
(setq sentence-end-double-space nil)

;; According to the POSIX, a line is defined as "a sequence of zero or more
;; non-newline characters followed by a terminating newline".
(setq require-final-newline t)

;; Eliminate delay before highlighting search matches
(setq lazy-highlight-initial-delay 0)

;; Only affect leading indentation. This prevents destroying mid-line visual
;; alignments, such as aligning variable assignments or trailing comments, by
;; ensuring spaces in the middle of a line are never converted to tabs.
(setq tabify-regexp (rx line-start (zero-or-more ?\t) ?\s (one-or-more blank)))

;; Prevent Emacs filling commands (such as `fill-paragraph', `fill-region',
;; `auto-fill-mode', and Evil's `gq' operator) from inserting line breaks inside
;; text that is currently hidden via text properties. This prevents accidental
;; corruption of folded outlines (e.g., in Org or Outline mode) and concealed
;; markup (e.g., hidden Markdown URLs).
(setq fill-nobreak-invisible t)

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
;; TODO: This section needs to be reviewed!

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
  (defun my-make-frame-darwin(&optional frame)
    "Configure a new FRAME (default: selected frame) on `darwin' system"

    (message "my-make-frame-darwin(%s)" frame)

    ;; When the frame is GUI
    (when (display-graphic-p)

      ;; set key to toggle fullscreen mode
      (global-set-key (kbd "s-<return>") 'toggle-frame-fullscreen)

      ;; Default Font
      (let* ((font-priority '("0xProto Nerd Font"  "FiraCode Nerd Font" "Menlo"))
             (available-fonts (font-family-list))
             (chosen-font (seq-find (lambda (font) (member font available-fonts)) font-priority)))
        (when chosen-font
          (message "Setting default font: %s" chosen-font)
          (set-face-font 'default (format "%s 12" chosen-font))))

      ;; raise Emacs using AppleScript."
      (ns-do-applescript "tell application \"Emacs\" to activate")))

  ;; If Emacs is in `daemon' mode, hook the server-after-make-frame-hook 
  (when (daemonp)
    (add-hook 'server-after-make-frame-hook #'my-make-frame-darwin))

  ;; Always call my frame configuration function
  (my-make-frame-darwin))

;; Configure Linux
(when (eq system-type 'gnu/linux)

  ;; Frame configuration for `windows' systems.
  (defun my-make-frame-linux(&optional frame)
    "Configure a new FRAME (default: selected frame) on `linux' system"

    (message "my-make-frame-linux(&optional %s)" frame)

    ;; When the frame is GUI
    (when (display-graphic-p)

      ;; Set the default font
      (let* ((font-priority '("0xProto Nerd Font"  "FiraCode Nerd Font" "Monospace"))
             (available-fonts (font-family-list))
             (chosen-font (seq-find (lambda (font) (member font available-fonts)) font-priority)))
        (when chosen-font
          (message "Setting default font: %s" chosen-font)
          (set-face-font 'default (format "%s 10" chosen-font))))))

  ;; If Emacs is in `daemon' mode, hook the server-after-make-frame-hook 
  (when (daemonp)
    (add-hook 'server-after-make-frame-hook #'my-make-frame-linux))
  
  ;; Always call my frame configuration function
  (my-make-frame-linux))

;; Configure Windows
(when (eq system-type 'windows-nt)

  ;; Frame configuration for `windows' systems.
  (defun my-make-frame-windows(&optional frame)
    "Configure a new FRAME (default: selected frame) on `windows' system"

    (message "my-make-frame-windows(&optional %s)" frame)

    ;; When the frame is GUI
    (when (display-graphic-p)

      ;; Set the default font
      (let* ((font-priority '("0xProto Nerd Font"  "FiraCode Nerd Font" "Cascadia Code" "Consolas"))
             (available-fonts (font-family-list))
             (chosen-font (seq-find (lambda (font) (member font available-fonts)) font-priority)))
        (when chosen-font
          (message "Setting default font: %s" chosen-font)
          (set-face-font 'default (format "%s 10" chosen-font))))))


  ;; If Emacs is in `daemon' mode, hook the server-after-make-frame-hook 
  (when (daemonp)
    (add-hook 'server-after-make-frame-hook #'my-make-frame-windows))
  
  ;; Always call my frame configuration function
  (my-make-frame-windows))

;;; Undo 

(setq undo-limit (* 13 160000))
(setq undo-strong-limit (* 13 240000))
(setq undo-outer-limit (* 13 24000000))

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
  (if my-debug
      (setq eglot-events-buffer-config '(:size 2000000 :format full))
    (setq jsonrpc-event-hook nil)
    (setq eglot-events-buffer-config '(:size 0 :format short)))
  :custom
  (eglot-report-progress my-debug) ; Prevent minibuffer spam
  (eglot-autoshutdown t) ; Shut down after killing last managed buffer
  (eglot-sync-connect 0) ; Connect asynchronously in background
  (eglot-extend-to-xref t) ; Activate in cross-referenced non-project files
  (eglot-code-action-indications '(eldoc-hint))) ; Disable margin indicators

;;; emacs-lock (built-in)

;; Lock buffers so they can not be killed
(use-package emacs-lock
  :config
  (with-current-buffer "*scratch*"
    (emacs-lock-mode 'kill))
  (with-current-buffer "*Messages*"
    (emacs-lock-mode 'kill)))

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

;; initialize and configure the `hideshow.el' system package
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

;; Configure spelling

;; configure ispell if a spelling tool is installed
(when (executable-find "hunspell")
  (use-package ispell
    :straight (:type built-in)
    :custom
    (ispell-program-name "hunspell")
    (ispell-local-dictionary "en_US")))

;; prefer `aspell' over `hunspell'
(when (executable-find "aspell")
  (use-package ispell
    :straight (:type built-in)
    :custom
    (ispell-program-name "aspell")
    (ispell-silently-savep t)))

;; Darwin (macOS) specific config
(when (eq system-type 'darwin)
  (use-package ispell
    :straight (:type built-in)))

;; Linux specific config
(when (eq system-type 'gnu/linux)
  (use-package ispell
    :straight (:type built-in)))

;; Windows specific config
(when (eq system-type 'windows-nt)
  (use-package ispell
    :straight (:type built-in)
    :custom
    (ispell-hunspell-dict-paths-alist '(("en_US" "c:/hunspell/en_US.aff")))
    :config
    (setenv "LANG" "en_US")))

;;; python (built-in)

(use-package python
  :straight (:type built-in)
  :custom
  ;; Do not notify the user each time Python tries to guess the indentation offset
  (python-indent-guess-indent-offset-verbose nil))

(use-package eglot
  :straight (:type built-in)
  :hook
  ((python-ts-mode . eglot-ensure)
   (python-ts-mode . flyspell-prog-mode)
   (python-ts-mode . hs-minor-mode)
   (python-ts-mode . (lambda () (set-fill-column 88)))))

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

;;; tree-sitter (built-in)

(use-package tree-sitter
  :disabled
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
  
;;; Package management (using `straight')

;;; Require external packages.

;; Require all files matching FILESPEC in DIRECTORY.
(defun my-require-features (filespec directory)
  "Require all `.el' files matching FILESPEC in DIRECTORY."
  (when (file-exists-p directory)
    (add-to-list 'load-path directory)
    (let ((pattern (wildcard-to-regexp filespec)))
      (dolist (file (directory-files directory nil pattern))
        (message "require file %s..." file)
        (require (intern (file-name-sans-extension file)) nil t)))))

(message "Require external packages...")
(my-require-features "package-*.el" (expand-file-name "lisp" user-emacs-directory))

;;; end of init.el
