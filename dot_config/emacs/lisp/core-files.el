;;; core-files.el --- Initialize files save, autosave and backup settings

;; Mike Barker <mike@thebarkers.com>
;; Created: November 23rd, 2025
;; Updated: August 9th, 2026

;;; Commentary:
;; Initialize the save, autosave and backup of files

;;; History:
;; See my dotfiles and emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:
(use-package emacs
  :straight nil
  :config
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

  ;; Configure file auto-save and backup settings
  (let ((backups-dir    (expand-file-name "backups/" my-cache-directory))
	(auto-saves-dir (expand-file-name "auto-saves/" my-cache-directory)))

    ;; Create directories if they don't exist
    (make-directory auto-saves-dir t)
    (make-directory backups-dir t)

    ;; File Auto-save settings
    (setq auto-save-list-file-prefix auto-saves-dir)
    (setq auto-save-file-name-transforms
          `(( ,".*" ,auto-saves-dir t)))

    ;; File Backup settings
    (setq backup-by-copying t)
    (setq backup-directory-alist
          `((".*" . ,backups-dir)
            (,tramp-file-name-regexp nil))))
  :hook
  ;; Remove trailing whitespace from lines when saving files
  (before-save-hook . delete-trailing-whitespace))

(provide 'core-files)
;;; core-files.el ends here.
