;;; core-findfile.el --- Configure Emacs findfile options

;; Mike Barker <mike@thebarkers.com>
;; Created: August 13th, 2026
;; Updated: August 13th, 2026

;;; Commentary:
;; Configure Emacs findfile options
;; find-func.el

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:

;; Speed up 'find-library' and reduce completion clutter by excluding internal
;; helper files. This provides a library-focused list.
(setq find-library-include-other-files nil)

;; Ignoring this is acceptable since it will redirect to the buffer regardless.
(setq find-file-suppress-same-file-warnings t)

;; Automatically resolve symlinks to their true paths. This sets the correct
;; working directory so C-x C-f opens in the right folder and version control
;; tools recognize the Git repository.
(setq find-file-visit-truename t
      ;; Automatically follow a symlink to its source if that source is managed
      ;; by a version control system, rather than asking for permission.
      vc-follow-symlinks t)

(provide 'core-findfile)
;;; core-findfile.el ends here.
