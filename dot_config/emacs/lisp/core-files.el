;;; core-files.el --- Initialize autosave, backup and file saving options

;; Mike Barker <mike@thebarkers.com>
;; Created: November 23rd, 2025
;; Updated: August 13th, 2026

;;; Commentary:
;; Initialize the save, autosave and backup of files
;; C source, files.el, simple.el, startup.el, vc-hooks.el, window.el

;;; History:
;; See my dotfiles and emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:

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

;;; Auto revert

;; Auto-revert in Emacs is a feature that automatically updates the contents of
;; a buffer to reflect changes made to the underlying file.

;; Revert other buffers (e.g, Dired)
(setq global-auto-revert-non-file-buffers t)
(setq global-auto-revert-ignore-modes '(Buffer-menu-mode))

;;; Save-place

;; Enables Emacs to remember the last location within a file upon reopening.
(setq save-place-file (expand-file-name "saveplace" my-cache-directory))
(setq save-place-limit 600)

;; Remove trailing whitespace from lines when saving files
;; (before-save-hook . delete-trailing-whitespace)

(provide 'core-files)
;;; core-files.el ends here.
