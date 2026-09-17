;;; core-dired.el --- Initialize the `dired' mode

;; Mike Barker <mike@thebarkers.com>
;; Created: November 24th, 2025
;; Updated: September 17th, 2026

;;; Commentary:
;; Any user customizations to the `dired' mode should go here.
;; dired.el, dired-aux.el, dired-x.el, ls-lisp.el
;; James Cherti has some useful configuration recomendations here:
;; https://www.jamescherti.com/emacs-dired-configuration/

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:

;; Configure dired behavior
(use-package emacs
  :ensure nil
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

(provide 'core-dired)
;;; End of core-dired.el
