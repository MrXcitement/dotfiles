;;; core-tramp.el --- Configure Emacs tramp options

;; Mike Barker <mike@thebarkers.com>
;; Created: August 13th, 2026
;; Updated: August 13th, 2026

;;; Commentary:
;; Configure Emacs tramp options
;; C source, files.el

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:

(setq tramp-verbose 1
      remote-file-name-inhibit-cache 50
      ;; Disable lockfiles and auto-saves for remote files to eliminate lag
      remote-file-name-inhibit-locks t
      remote-file-name-inhibit-auto-save-visited t)

(provide 'core-tramp)
;;; core-tramp.el ends here.
