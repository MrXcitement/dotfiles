;;; core-abbrev.el --- Configure Emacs abbrev and dabbrev options

;; Mike Barker <mike@thebarkers.com>
;; Created: August 13th, 2026
;; Updated: August 13th, 2026

;;; Commentary:
;; Configure Emacs abbrev options
;; abbrev.el, dabbrev.el, files.el

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:

;; Ensure the abbrev_defs file is stored in the correct location when
;; `user-emacs-directory' is modified, as it defaults to ~/.emacs.d/abbrev_defs
;; regardless of the change.

(setq save-abbrevs 'silently)

(setq dabbrev-upcase-means-case-search t)

(setq dabbrev-ignored-buffer-modes
      '(archive-mode image-mode docview-mode tags-table-mode
                     pdf-view-mode tags-table-mode))

(setq dabbrev-ignored-buffer-regexps
      '(;; - Buffers starting with a space (internal or temporary buffers)
        "\\` "
        ;; Tags files such as ETAGS, GTAGS, RTAGS, TAGS, e?tags, and GPATH,
        ;; including versions with numeric extensions like <123>
        "\\(?:\\(?:[EG]?\\|GR\\)TAGS\\|e?tags\\|GPATH\\)\\(<[0-9]+>\\)?"))
(provide 'core-abbrev)
;;; core-abbrev.el ends here.
