;;; core-dired.el --- Initialize the `dired' mode

;; Mike Barker <mike@thebarkers.com>
;; Created: November 24th, 2025
;; Updated: August 13th, 2026

;;; Commentary:
;; Any user customizations to the `dired' mode should go here.
;; dired.el, dired-aux.el, dired-x.el, ls-lisp.el

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:

(setq dired-free-space nil
      dired-dwim-target t  ; Propose a target for intelligent moving/copying
      dired-deletion-confirmer 'y-or-n-p
      dired-filter-verbose nil
      dired-recursive-deletes 'top
      dired-recursive-copies 'always
      dired-vc-rename-file t
      dired-create-destination-dirs 'ask
      ;; Suppress Dired buffer kill prompt for deleted dirs
      dired-clean-confirm-killing-deleted-buffers nil)

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

;; dired-omit-mode
(setq dired-omit-verbose nil
      dired-omit-files (concat "\\`[.]\\'"))

;; Highlight the current line when in dired mode.
(add-hook 'dired-mode-hook 'hl-line-mode)

(setq ls-lisp-verbosity nil)
(setq ls-lisp-dirs-first t)

(provide 'core-dired)
;;; End of core-dired.el
